//
//  HBBaseViewModel.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBBaseViewModel.h"

@implementation HBBaseViewModel

#pragma mark -- LifeCycle
- (instancetype)init
{
    if(self = [super init])
    {
        self.viewStatus = HBViewState_Loading;
        [self observeAllNotifications];
    }
    return self;
}

- (void)dealloc
{
    [self unobserveAllNotifications];
}

#pragma mark -- HBBaseViewModelInterface
- (void)loadContent
{
    
}

#pragma mark -- Notification
// 网络变化
ON_NOTIFICATION3(HBNetworkNotify, HBNetworkStatus_Changed, notification)
{
    if(notification.object) {
        NSNumber *netStatus = [notification.object objectForKey:@"HBNetStatus"];
        self.netStatus = netStatus.integerValue;
    }
}

@end
