//
//  HBRuntime.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBRuntime : NSObject

@property (nonatomic, readonly) NSArray *allClasses;

+ (id)allocByClass:(Class)clazz;
+ (id)allocByClassName:(NSString *)clazzName;

+ (NSArray *)allClasses;
+ (NSArray *)allSubClassesOf:(Class)clazz;

+ (NSArray *)allInstanceMethodsOf:(Class)clazz;
+ (NSArray *)allInstanceMethodsOf:(Class)clazz withPrefix:(NSString *)prefix;

+ (NSArray *)allPropertyNamesOf:(Class)clazz;
+ (NSDictionary *)allPropertyValueWithTarget:(id)target;
+ (NSDictionary *)allPropertyValue:(NSArray *)propertyNames withTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
