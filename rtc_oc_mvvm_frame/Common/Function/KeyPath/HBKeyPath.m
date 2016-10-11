//
//  HBKeyPath.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/10.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBKeyPath.h"
#import <objc/runtime.h>
#import <objc/message.h>

inline void HBAutoBindingKeyPath(id bindable)
{
    NSMutableSet *names = [[NSMutableSet alloc] initWithCapacity:3];
    Class rootClass = [NSObject class];
    Class clazz = [bindable class];
    while (clazz != nil && clazz != rootClass)
    {
        unsigned int methodCount;
        Method *methods = class_copyMethodList(clazz, &methodCount);
        if (methods && methodCount > 0)
        {
            for (unsigned int i = 0; i < methodCount; i++)
            {
                SEL selector = method_getName(methods[i]);
                NSString *selectorName = NSStringFromSelector(selector);
                if ([selectorName hasPrefix:HB_AUTO_KEY_PATH_BIND_PREFIX]) {
                    [names addObject:selectorName];      //为了去重
                }
            }
        }
        if (methods) {
            free(methods);
        }
        clazz = class_getSuperclass(clazz);
    }
    
    if (names.count > 0)
    {
        for (NSString *name in names)
        {
            SEL selector = NSSelectorFromString(name);
            IMP imp = [bindable methodForSelector:selector];
            void (*func)(id, SEL) = (void *)imp;
            func(bindable, selector);
        }
    }
}
