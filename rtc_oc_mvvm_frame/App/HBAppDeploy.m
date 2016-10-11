//
//  HBAppDeploy.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/11.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBAppDeploy.h"
#import "HBNetworkManager.h"

@implementation HBAppDeploy

DEF_SINGLETON(HBAppDeploy)

#pragma mark -- Public
- (void)launchBackground
{
    self.appLoadStatus = HBAppLoadStatus_Loading;
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _netWorkManager = [[HBNetworkManager alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            self.appLoadStatus = HBAppLoadStatus_Loaded;
        });
    });
}

@end
