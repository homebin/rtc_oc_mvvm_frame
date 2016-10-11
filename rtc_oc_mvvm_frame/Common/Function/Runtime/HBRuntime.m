//
//  HBRuntime.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBRuntime.h"
#import <objc/runtime.h>

@implementation HBRuntime

+ (id)allocByClass:(Class)clazz
{
    if ( nil == clazz )
        return nil;
    
    return [clazz alloc];
}

+ (id)allocByClassName:(NSString *)clazzName
{
    if ( nil == clazzName || 0 == [clazzName length] )
        return nil;
    
    Class clazz = NSClassFromString( clazzName );
    if ( nil == clazz )
        return nil;
    
    return [clazz alloc];
}

+ (NSArray *)allClasses
{
    static NSMutableArray * __allClasses = nil;
    
    if ( nil == __allClasses )
    {
        __allClasses = [NSMutableArray array];
    }
    
    if ( 0 == __allClasses.count )
    {
        static const char * __blackList[] =
        {
        };
        
        unsigned int	classesCount = 0;
        Class *			classes = objc_copyClassList( &classesCount );
        
        for ( unsigned int i = 0; i < classesCount; ++i )
        {
            Class classType = classes[i];
            Class superClass = class_getSuperclass( classType );
            
            if ( nil == superClass )
                continue;
            //			if ( NO == class_conformsToProtocol( classType, @protocol(NSObject)) )
            //				continue;
            if ( NO == class_respondsToSelector( classType, @selector(doesNotRecognizeSelector:) ) )
                continue;
            if ( NO == class_respondsToSelector( classType, @selector(methodSignatureForSelector:) ) )
                continue;
            //			if ( class_respondsToSelector( classType, @selector(initialize) ) )
            //				continue;
            //			if ( NO == [classType isSubclassOfClass:[NSObject class]] )
            //				continue;
            
            BOOL			isBlack = NO;
            const char *	className = class_getName( classType );
            NSInteger		listSize = sizeof( __blackList ) / sizeof( __blackList[0] );
            
            for ( int i = 0; i < listSize; ++i )
            {
                if ( 0 == strcmp( className, __blackList[i] ) )
                {
                    isBlack = YES;
                    break;
                }
            }
            
            if ( isBlack )
                continue;
            
            [__allClasses addObject:classType];
        }
        
        free( classes );
    }
    
    return __allClasses;
}

+ (NSArray *)allSubClassesOf:(Class)superClass
{
    NSMutableArray * results = [[NSMutableArray alloc] init];
    
    for ( Class classType in [self allClasses] )
    {
        if ( classType == superClass )
            continue;
        
        if ( NO == [classType isSubclassOfClass:superClass] )
            continue;
        
        [results addObject:classType];
    }
    
    return results;
}

+ (NSArray *)allInstanceMethodsOf:(Class)clazz
{
    static NSMutableDictionary * __cache = nil;
    
    if ( nil == __cache )
    {
        __cache = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableArray * methodNames = [__cache objectForKey:[clazz description]];
    if ( nil == methodNames )
    {
        methodNames = [NSMutableArray array];
        
        Class thisClass = clazz;
        
        while ( NULL != thisClass )
        {
            unsigned int	methodCount = 0;
            Method *		methods = class_copyMethodList( thisClass, &methodCount );
            
            for ( unsigned int i = 0; i < methodCount; ++i )
            {
                SEL selector = method_getName( methods[i] );
                if ( selector )
                {
                    const char * cstrName = sel_getName(selector);
                    if ( NULL == cstrName )
                        continue;
                    
                    NSString * selectorName = [NSString stringWithUTF8String:cstrName];
                    if ( NULL == selectorName )
                        continue;
                    
                    [methodNames addObject:selectorName];
                }
            }
            
            thisClass = class_getSuperclass( thisClass );
            if ( thisClass == [NSObject class] )
            {
                break;
            }
        }
        
        [__cache setObject:methodNames forKey:[clazz description]];
    }
    
    return methodNames;
}

+ (NSArray *)allInstanceMethodsOf:(Class)clazz withPrefix:(NSString *)prefix
{
    NSArray * methods = [self allInstanceMethodsOf:clazz];
    if ( nil == methods || 0 == methods.count )
    {
        return nil;
    }
    
    if ( nil == prefix )
    {
        return methods;
    }
    
    NSMutableArray * result = [NSMutableArray array];
    
    for ( NSString * selectorName in methods )
    {
        if ( NO == [selectorName hasPrefix:prefix] )
        {
            continue;
        }
        
        [result addObject:selectorName];
    }
    
    return result;
}

+ (NSArray *)allPropertyNamesOf:(Class)clazz
{
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList(clazz, &propertyCount);
    for (int i = 0; i < propertyCount; i ++) {
        objc_property_t property = propertys[i];
        const char * propertyName = property_getName(property);
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    //释放
    free(propertys);
    return allNames;
}

+ (NSDictionary *)allPropertyValueWithTarget:(id)target
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([target class], &propertyCount);
    for (int i = 0; i < propertyCount; i ++){
        objc_property_t property = propertys[i];
        //获取属性名
        const char * propertyName = property_getName(property);
        SEL getSel = NSSelectorFromString([NSString stringWithUTF8String:propertyName]);
        if ([target respondsToSelector:getSel])
        {
            NSMethodSignature *signature = [target methodSignatureForSelector:getSel];
            if(!signature)
                continue;
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:target];
            [invocation setSelector:getSel];
            
            //获取属性类型
            const char *type = property_getAttributes(property);
            NSString *typeString = [NSString stringWithUTF8String:type];
            NSArray *attributes = [typeString componentsSeparatedByString:@","];
            NSString *typeAttribute = [attributes objectAtIndex:0];
            NSString *propertyType = [typeAttribute substringFromIndex:1];
            const char *rawPropertyType = [propertyType UTF8String];
            if (strspn(rawPropertyType, @encode(id)) > 0)
            {
                NSObject *__unsafe_unretained returnValue = nil;
                [invocation invoke];
                [invocation getReturnValue:&returnValue];
                if(returnValue){
                    [resultDic setObject:returnValue forKey:[NSString stringWithUTF8String:propertyName]];
                }
            }
            
            else if(strspn(rawPropertyType, @encode(char)) > 0)
            {
                char *value;
                [invocation invoke];
                [invocation getReturnValue:&value];
                if(strlen(value) > 0){
                    NSNumber *num = [NSNumber numberWithChar:*value];
                    [resultDic setObject:num forKey:[NSString stringWithUTF8String:propertyName]];
                }
            }
            else if(strspn(rawPropertyType, @encode(int)) > 0)
            {
                int *value;
                [invocation invoke];
                [invocation getReturnValue:&value];
                if(value != NULL){
                    NSNumber *num = [NSNumber numberWithInt:*value];
                    [resultDic setObject:num forKey:[NSString stringWithUTF8String:propertyName]];
                }
            }
            else if(strspn(rawPropertyType, @encode(short)) > 0)
            {
                short *value;
                [invocation invoke];
                [invocation getReturnValue:&value];
                if(value != NULL){
                    NSNumber *num = [NSNumber numberWithShort:*value];
                    [resultDic setObject:num forKey:[NSString stringWithUTF8String:propertyName]];
                }
            }
            else if(strspn(rawPropertyType, @encode(long)) > 0)
            {
                long *value;
                [invocation invoke];
                [invocation getReturnValue:&value];
                if(value != NULL){
                    NSNumber *num = [NSNumber numberWithLong:*value];
                    [resultDic setObject:num forKey:[NSString stringWithUTF8String:propertyName]];
                }
            }
            else if(strspn(rawPropertyType, @encode(long long)) > 0)
            {
                long long *value;
                [invocation invoke];
                [invocation getReturnValue:&value];
                if(value != NULL){
                    NSNumber *num = [NSNumber numberWithLongLong:*value];
                    [resultDic setObject:num forKey:[NSString stringWithUTF8String:propertyName]];
                }
            }
            else if(strspn(rawPropertyType, @encode(unsigned int)) > 0)
            {
                unsigned int *value;
                [invocation invoke];
                [invocation getReturnValue:&value];
                if(value != NULL){
                    NSNumber *num = [NSNumber numberWithUnsignedInt:*value];
                    [resultDic setObject:num forKey:[NSString stringWithUTF8String:propertyName]];
                }
            }
            else if(strspn(rawPropertyType, @encode(unsigned short)) > 0)
            {
                unsigned short *value;
                [invocation invoke];
                [invocation getReturnValue:&value];
                if(value != NULL){
                    NSNumber *num = [NSNumber numberWithUnsignedShort:*value];
                    [resultDic setObject:num forKey:[NSString stringWithUTF8String:propertyName]];
                }
            }
            else if(strspn(rawPropertyType, @encode(unsigned long)) > 0)
            {
                unsigned long *value;
                [invocation invoke];
                [invocation getReturnValue:&value];
                if(value != NULL){
                    NSNumber *num = [NSNumber numberWithUnsignedLong:*value];
                    [resultDic setObject:num forKey:[NSString stringWithUTF8String:propertyName]];
                }
            }
            else if(strspn(rawPropertyType, @encode(unsigned long long)) > 0)
            {
                unsigned long long *value;
                [invocation invoke];
                [invocation getReturnValue:&value];
                if(value != NULL){
                    NSNumber *num = [NSNumber numberWithUnsignedLongLong:*value];
                    [resultDic setObject:num forKey:[NSString stringWithUTF8String:propertyName]];
                }
            }
            else if(strspn(rawPropertyType, @encode(float)) > 0)
            {
                float *value;
                [invocation invoke];
                [invocation getReturnValue:&value];
                if(value != NULL){
                    NSNumber *num = [NSNumber numberWithFloat:*value];
                    [resultDic setObject:num forKey:[NSString stringWithUTF8String:propertyName]];
                }
            }
            else if(strspn(rawPropertyType, @encode(double)) > 0)
            {
                double *value;
                [invocation invoke];
                [invocation getReturnValue:&value];
                if(value != NULL){
                    NSNumber *num = [NSNumber numberWithDouble:*value];
                    [resultDic setObject:num forKey:[NSString stringWithUTF8String:propertyName]];
                }
            }
            else
            {
                //暂不处理
            }
        }
    }
    free(propertys);
    return resultDic;
}

+ (NSDictionary *)allPropertyValue:(NSArray *)propertyNames withTarget:(id)target
{
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
    for(NSString *propertyName in propertyNames)
    {
        SEL getSel = NSSelectorFromString(propertyName);
        if ([target respondsToSelector:getSel])
        {
            NSMethodSignature *signature = [target methodSignatureForSelector:getSel];
            if(!signature)
                continue;
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:target];
            [invocation setSelector:getSel];
            NSObject *__unsafe_unretained returnValue = nil;
            [invocation invoke];
            [invocation getReturnValue:&returnValue];
            
            if(returnValue){
                [resultDic setObject:returnValue forKey:propertyName];
            }
        }
    }
    return resultDic;
}

@end
