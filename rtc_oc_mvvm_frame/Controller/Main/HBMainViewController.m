//
//  HBMainViewController.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBMainViewController.h"
#import "HBMainViewModel.h"
#import "HBMainView.h"

@interface HBMainViewController ()

@end

@implementation HBMainViewController

#pragma mark -- Lifecycle

- (void)loadView
{
    [super loadView];
    
    self.title = @"首页";
}

- (void)loadContent
{
    self.viewModel.viewStatus = HBViewState_Content;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - HBBaseViewControllerInterface
- (HBBaseViewModel *)createViewModel
{
    return [[HBMainViewModel alloc] init];
}

- (HBBaseView *)createContentView
{
    return [[HBMainView alloc] initWithFrame:self.view.bounds withViewModel:self.viewModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
