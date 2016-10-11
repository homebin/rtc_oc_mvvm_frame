//
//  HBKeyPath.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/10.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HB_AUTO_KEY_PATH_BIND_PREFIX @"__$$autoKeyPathBind_"

extern void HBAutoBindingKeyPath(id bindable);

//AUTO BIND
#define AUTO_BIND_TARGET(__target)   HBAutoBindingKeyPath(__target);

//AUTO BIND NOTIFICATION
#define ON_KEYPATH_CHANGE(__object, __keypath)                          \
- (void)__$$autoKeyPathBind_##__object##_##__keypath{                   \
    __weak __typeof(self) weakSelf = self;                                  \
    [RACObserve([self __object], __keypath) subscribeNext:^(id value) {     \
        __strong __typeof(weakSelf) strongSelf = weakSelf;                       \
        [strongSelf __$$autoObserver_##__object##_##__keypath:value];           \
    }];                                                                     \
}                                                                       \
- (void)__$$autoObserver_##__object##_##__keypath:(id)value
