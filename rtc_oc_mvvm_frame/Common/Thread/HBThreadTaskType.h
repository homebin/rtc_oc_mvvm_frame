//
//  HBThreadTaskType.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/12.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#ifndef HBThreadTaskType_h
#define HBThreadTaskType_h

// 这里涉及业务逻辑，当某一业务需要单独线程时，需在这里填充
typedef NS_ENUM(NSUInteger, HBThreadTaskType) {
    HBThreadTaskType_Default = 0,
    
    HBThreadTaskType_Count,
};

#endif /* HBThreadTaskType_h */
