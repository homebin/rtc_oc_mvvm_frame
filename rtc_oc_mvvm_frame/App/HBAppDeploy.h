//
//  HBAppDeploy.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/11.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HBNetworkManager;
@class HBThreadDispatcher;

typedef NS_ENUM(NSInteger, HBAppLoadStatus) {
    HBAppLoadStatus_Idle = 0,
    HBAppLoadStatus_Loading,
    HBAppLoadStatus_Loaded
};

@interface HBAppDeploy : NSObject

@property (nonatomic, assign) HBAppLoadStatus       appLoadStatus;

@property (nonatomic, strong) HBNetworkManager      *netWorkManager;
@property (nonatomic, strong) HBThreadDispatcher    *threadDispatcher;

AS_SINGLETON(HBAppDeploy)

- (void)launchBackground;

@end
