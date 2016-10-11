//
//  NSObject+HBNotification.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "NSObject+HBNotification.h"
#import "HBRuntime.h"

@implementation NSObject (HBNotification)

+ (NSString *)NOTIFICATION
{
    return [self NOTIFICATION_TYPE];
}

+ (NSString *)NOTIFICATION_TYPE
{
    return [NSString stringWithFormat:@"notify.%@.", [self description]];
}

- (void)handleNotification:(NSNotification *)notification
{
    
}

- (void)observeNotification:(NSString *)notificationName
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:notificationName
                                                  object:nil];
    
    NSArray * array = [notificationName componentsSeparatedByString:@"."];
    if ( array && array.count > 1 )
    {
        //		NSString * prefix = (NSString *)[array objectAtIndex:0];
        NSString * clazz = (NSString *)[array objectAtIndex:1];
        NSString * name = (NSString *)[array objectAtIndex:2];
        
        {
            NSString * selectorName;
            SEL selector;
            
            selectorName = [NSString stringWithFormat:@"handleNotification_%@_%@:", clazz, name];
            selector = NSSelectorFromString(selectorName);
            
            if ( [self respondsToSelector:selector] )
            {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:selector
                                                             name:notificationName
                                                           object:nil];
                return;
            }
            
            selectorName = [NSString stringWithFormat:@"handleNotification_%@:", clazz];
            selector = NSSelectorFromString(selectorName);
            
            if ( [self respondsToSelector:selector] )
            {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:selector
                                                             name:notificationName
                                                           object:nil];
                return;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:notificationName
                                               object:nil];
}

- (void)observeAllNotifications
{
    NSArray * methods = [HBRuntime allInstanceMethodsOf:[self class] withPrefix:@"handleNotification_"];
    if ( nil == methods || 0 == methods.count )
    {
        return;
    }
    
    for ( NSString * methodName in methods )
    {
        NSArray * array = [methodName componentsSeparatedByString:@"_"];
        if ( array && array.count >= 3 )
        {
            NSString * clazz = (NSString *)[array objectAtIndex:1];
            NSUInteger index = [@"handleNotification_" length] + [clazz length] + [@"_" length];
            NSString * selectorName = [methodName substringFromIndex:index];
            NSString * name = [selectorName substringToIndex:([selectorName length]-1)];
            if ([clazz length] > 0 && [name length] > 0) {
                id target = [[NSClassFromString(clazz) alloc] init];
                SEL selector = NSSelectorFromString(name);
                if ([target respondsToSelector:selector]) {
                    SuppressPerformSelectorLeakWarning (
                                                        NSString* notificationName = [NSClassFromString(clazz) performSelector:selector];
                                                        [self observeNotification:notificationName]; );
                }
            }
        }
    }
}

- (void)unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)unobserveAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (BOOL)postNotification:(NSString *)name
{
    INFO( @"Notification '%@'", [name stringByReplacingOccurrencesOfString:@"notify." withString:@""] );
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    return YES;
}

+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    return YES;
}

- (BOOL)postNotification:(NSString *)name
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self class] postNotification:name];
    });
    return YES;
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self class] postNotification:name withObject:object];
    });
    return YES;
}


@end
