//
//  HBBaseViewController.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBBaseViewController.h"
#import "HBBaseView.h"
#import "HBBaseViewModel.h"
#import "HBContentBaseView.h"
#import "HBLoadingBaseView.h"
#import "HBEmptyBaseView.h"
#import "HBErrorBaseView.h"

#import "HBAppDeploy.h"
#import "HBNetworkManager.h"

#import "UIView+Toast.h"

#import <objc/message.h>

#define HBViewController_CanShowContent  (self.appDeploy.appLoadStatus == HBAppLoadStatus_Loaded && self.isViewLoaded)

@interface HBBaseViewController ()

@property (nonatomic, strong) HBBaseView        *currentView;
@property (nonatomic, strong) HBBaseViewModel   *baseViewModel;

@end

@implementation HBBaseViewController

#pragma mark -- Lifecycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _appDeploy = [HBAppDeploy sharedInstance];
        
        SEL selector = @selector(setViewModel:);
        if ([self respondsToSelector:selector])
        {
            id viewModel = [self createViewModel];
            void (*objc_msgSendTypeAll)(id, SEL, id) = (void (*)(id, SEL, id)) objc_msgSend;
            objc_msgSendTypeAll(self, selector, viewModel);
        }
        
        @weakify(self)
        [[HBRACObserve(_appDeploy, appLoadStatus) filter:^BOOL(id value) {
            return !HBNumberCompareWithTuple(value);
        }] subscribeNext:^(id x) {
            @strongify(self)
            if (HBViewController_CanShowContent) {
                [self loadContent];
            }
        }];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    AUTO_BIND_TARGET(self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self)
    [RACObserve(self.viewModel, viewStatus) subscribeNext:^(id x) {
        @strongify(self)
        [self switchToViewState:self.viewModel.viewStatus];
    }];
    
    [[HBRACObserve(self.viewModel, netStatus) filter:^BOOL(id value) {
        RACTuple* tuple = (RACTuple *)value;
        NSNumber* newValue = tuple[0];
        NSNumber* oldValue = tuple[1][@"old"];
        if ([oldValue intValue] == HBNetStatus_None) {
            return NO;
        }
        return ![newValue isEqualToNumber:oldValue];
    }] subscribeNext:^(id x) {
        @strongify(self)
        NSString* message = [NSString stringWithFormat:@"当前网络：%@", [self.appDeploy.netWorkManager networkInfoDescription]];
        [self.currentView makeToast:message
                           duration:2.0f
                           position:CSToastPositionCenter];
    }];
    
    if (HBViewController_CanShowContent) {
        [self loadContent];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -- Lazy Getter
- (HBBaseView *)contentView
{
    if (!_contentView)
    {
        _contentView = [self createContentView];
    }
    return _contentView;
}

- (HBBaseView *)loadingView
{
    if (!_loadingView)
    {
        _loadingView = [self createLoadingView];
    }
    return _loadingView;
}

- (HBBaseView *)emptyView
{
    if (!_emptyView)
    {
        _emptyView = [self createEmptyView];
    }
    return _emptyView;
}

- (HBBaseView *)errorView
{
    if (!_errorView)
    {
        _errorView = [self createErrorView];
    }
    return _errorView;
}

#pragma mark -- HBBaseViewControllerInterface
- (HBBaseViewModel *)viewModel
{
    if(!_baseViewModel)
    {
        _baseViewModel = [[HBBaseViewModel alloc] init];
    }
    return _baseViewModel;
}

- (HBBaseViewModel *)createViewModel
{
    return [[HBBaseViewModel alloc] init];
}

- (HBBaseView *)createContentView
{
    return [[HBContentBaseView alloc] initWithFrame:self.view.bounds withViewModel:self.viewModel];
}

- (HBBaseView *)createLoadingView
{
    return [[HBLoadingBaseView alloc] initWithFrame:self.view.bounds withViewModel:self.viewModel];
}

- (HBBaseView *)createEmptyView
{
    return [[HBEmptyBaseView alloc] initWithFrame:self.view.bounds withViewModel:self.viewModel];
}

- (HBBaseView *)createErrorView
{
    return [[HBErrorBaseView alloc] initWithFrame:self.view.bounds withViewModel:self.viewModel];
}

- (void)loadContent
{
    
}

- (void)refreshContent
{
    
}

#pragma mark -- HBViewStateInterface
-(HBBaseView *)viewForState:(HBViewState)viewState
{
    if(self.currentView && viewState == self.currentView.viewState){
        return self.currentView;
    }
    
    HBBaseView *currentView = nil;
    switch (viewState)
    {
        case HBViewState_Loading:
            currentView = [self loadingView];
            break;
            
        case HBViewState_Content:
            currentView = [self contentView];
            break;
            
        case HBViewState_Empty:
            currentView = [self emptyView];
            break;
            
        case HBViewState_Error:
            currentView = [self errorView];
            break;
        default:
            break;
    }
    
    return currentView;
}

#pragma mark - Private
- (void)switchToViewState:(HBViewState)viewState
{
    HBBaseView *oldView = self.currentView;
    if (oldView)
    {
        if (viewState == oldView.viewState) {
            WARN(@"视图已经就位，无须切换");
            return;
        }
    }
    
    HBBaseView* newView = [self viewForState:viewState];
    if(newView)
    {
        //hidden old view
        if (oldView)
        {
            [oldView setHidden:YES];
        }
        
        //show new view
        if (newView.superview)
        {
            [newView setHidden:NO];
        }
        else
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            [self.view addSubview:newView];
            [newView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
        self.currentView = newView;
    }
    else
    {
        ERROR(@"视图获取出错");
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end




