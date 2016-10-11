//
//  HBRAC.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/10.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#ifndef HBRAC_h
#define HBRAC_h

//HBRACObserve 首次不触发；  RACObserve 首次触发
#define HBRACObserve(TARGET, KEYPATH) \
({ \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wreceiver-is-weak\"") \
    __weak id target_ = (TARGET); \
    [target_ rac_valuesAndChangesForKeyPath:@keypath(TARGET, KEYPATH) options:NSKeyValueObservingOptionOld observer:self]; \
        _Pragma("clang diagnostic pop") \
})

#define HBNumberCompareWithTuple(VALUE) \
({ \
    RACTuple* tuple = (RACTuple*)value; \
    NSNumber* newValue = tuple[0]; \
    NSNumber* oldValue = tuple[1][@"old"]; \
    [newValue isEqualToNumber:oldValue]; \
})

#define HBStringCompareWithTuple(VALUE) \
({ \
    RACTuple* tuple = (RACTuple*)value; \
    NSString* newValue = tuple[0]; \
    NSString* oldValue = tuple[1][@"old"]; \
    [newValue isEqualToString:oldValue]; \
})


#endif /* HBRAC_h */
