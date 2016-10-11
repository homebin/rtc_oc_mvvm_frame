//
//  HBTypeDefine.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HBSuccessBlock) (id _Nullable object);
typedef void (^HBFailureBlock) (NSError * _Nullable error);
typedef void (^HBResponseBlock) (id _Nullable object, NSError * _Nullable error);

typedef NS_ENUM(NSUInteger, HBViewState){
    // system uistate
    HBViewState_Loading = 0,
    HBViewState_Content = 1,
    HBViewState_Empty   = 2,
    HBViewState_Error   = 3
    
    // custom uistate
};

typedef NS_ENUM(NSInteger, HBNetStatus) {
    HBNetStatus_None = 0,
    HBNetStatus_Wifi = 1,
    HBNetStatus_WWan = 2
};

