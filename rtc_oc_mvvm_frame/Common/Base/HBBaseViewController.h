//
//  HBBaseViewController.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBBaseView;
@class HBBaseViewModel;
@class HBAppDeploy;

NS_ASSUME_NONNULL_BEGIN

@protocol HBBaseViewControllerInterface <NSObject>

@required
- (HBBaseViewModel *)viewModel;
- (HBBaseViewModel *)createViewModel;
- (HBBaseView *)createContentView;
- (HBBaseView *)createLoadingView;
- (HBBaseView *)createEmptyView;
- (HBBaseView *)createErrorView;

- (void)loadContent;
- (void)refreshContent;

@optional
- (void)setViewModel:(id)viewModel;

@end

#pragma mark - YYViewStateInterface
@protocol HBViewStateInterface <NSObject>

@optional
- (HBBaseView *)viewForState:(HBViewState)viewState;

@end

@interface HBBaseViewController : UIViewController<HBBaseViewControllerInterface, HBViewStateInterface>

@property (nonatomic, strong) HBAppDeploy   *appDeploy;

@property (nonatomic, strong) HBBaseView    *contentView;
@property (nonatomic, strong) HBBaseView    *loadingView;
@property (nonatomic, strong) HBBaseView    *emptyView;
@property (nonatomic, strong) HBBaseView    *errorView;

@end

NS_ASSUME_NONNULL_END
