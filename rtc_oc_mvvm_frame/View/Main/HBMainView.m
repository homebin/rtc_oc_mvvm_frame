//
//  HBMainView.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/11.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBMainView.h"
#import "HBMainViewModel.h"

@interface HBMainView()

@property (nonatomic, strong) HBMainViewModel           *viewModel;

@end

@implementation HBMainView

- (void)loadView
{
    [super loadView];
    
    self.backgroundColor = [UIColor grayColor];
}

@end
