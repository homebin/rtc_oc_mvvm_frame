//
//  HBProperty.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/10.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#ifndef HBProperty_h
#define HBProperty_h

#import <Foundation/Foundation.h>

#pragma mark -

#undef	AS_STATIC_PROPERTY
#define AS_STATIC_PROPERTY( __name )            \
- (NSString *)__name;                         \
+ (NSString *)__name;

#if __has_feature(objc_arc)

#undef	DEF_STATIC_PROPERTY
#define DEF_STATIC_PROPERTY( __name )                   \
- (NSString *)__name                                  \
{                                                     \
    return (NSString *)[[self class] __name];           \
}                                                     \
+ (NSString *)__name                                  \
{                                                     \
    return [NSString stringWithFormat:@"%s", #__name];  \
}

#else

#undef	DEF_STATIC_PROPERTY
#define DEF_STATIC_PROPERTY( __name )                   \
- (NSString *)__name                                  \
{                                                     \
    return (NSString *)[[self class] __name];           \
}                                                     \
+ (NSString *)__name                                  \
{                                                     \
    return [NSString stringWithFormat:@"%s", #__name];  \
}

#endif

#if __has_feature(objc_arc)

#undef	DEF_STATIC_PROPERTY2
#define DEF_STATIC_PROPERTY2( __name, __prefix )                        \
- (NSString *)__name                                                  \
{                                                                     \
    return (NSString *)[[self class] __name];                           \
}                                                                     \
+ (NSString *)__name                                                  \
{                                                                     \
    return [NSString stringWithFormat:@"%@.%s", __prefix, #__name];     \
}

#else

#undef	DEF_STATIC_PROPERTY2
#define DEF_STATIC_PROPERTY2( __name, __prefix )                        \
- (NSString *)__name                                                  \
{                                                                     \
    return (NSString *)[[self class] __name];                           \
}                                                                     \
+ (NSString *)__name                                                  \
{                                                                     \
    return [NSString stringWithFormat:@"%@.%s", __prefix, #__name];     \
}

#endif

#if __has_feature(objc_arc)

#undef	DEF_STATIC_PROPERTY3
#define DEF_STATIC_PROPERTY3( __name, __prefix, __prefix2 )             \
- (NSString *)__name                                                  \
{                                                                     \
    return (NSString *)[[self class] __name];                           \
}                                                                     \
+ (NSString *)__name                                                  \
{                                                                     \
    return [NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__name]; \
}

#else

#undef	DEF_STATIC_PROPERTY3
#define DEF_STATIC_PROPERTY3( __name, __prefix, __prefix2 )             \
- (NSString *)__name                                                  \
{                                                                     \
    return (NSString *)[[self class] __name];                           \
}                                                                     \
+ (NSString *)__name                                                  \
{                                                                     \
    return [NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__name]; \
}

#endif

#if __has_feature(objc_arc)

#undef	DEF_STATIC_PROPERTY4
#define DEF_STATIC_PROPERTY4( __name, __value, __prefix, __prefix2 )    \
- (NSString *)__name                                                  \
{                                                                     \
    return (NSString *)[[self class] __name];                           \
}                                                                     \
+ (NSString *)__name                                                  \
{                                                                     \
    return [NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__value]; \
}

#else

#undef	DEF_STATIC_PROPERTY4
#define DEF_STATIC_PROPERTY4( __name, __value, __prefix, __prefix2 )    \
- (NSString *)__name                                                  \
{                                                                     \
    return (NSString *)[[self class] __name];                           \
}                                                                     \
+ (NSString *)__name                                                  \
{                                                                     \
    return [NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__value]; \
}

#endif

#pragma mark -

#undef	AS_STATIC_PROPERTY_INT
#define AS_STATIC_PROPERTY_INT( __name )        \
- (NSInteger)__name;                          \
+ (NSInteger)__name;

#undef	DEF_STATIC_PROPERTY_INT
#define DEF_STATIC_PROPERTY_INT( __name, __value )      \
- (NSInteger)__name                                   \
{                                                     \
    return (NSInteger)[[self class] __name];            \
}                                                     \
+ (NSInteger)__name                                   \
{                                                     \
    return __value;                                     \
}

#undef	AS_INT
#define AS_INT	AS_STATIC_PROPERTY_INT

#undef	DEF_INT
#define DEF_INT	DEF_STATIC_PROPERTY_INT

#pragma mark -

#undef	AS_STATIC_PROPERTY_NUMBER
#define AS_STATIC_PROPERTY_NUMBER( __name )     \
- (NSNumber *)__name;                         \
+ (NSNumber *)__name;

#undef	DEF_STATIC_PROPERTY_NUMBER
#define DEF_STATIC_PROPERTY_NUMBER( __name, __value )   \
- (NSNumber *)__name                                  \
{                                                     \
    return (NSNumber *)[[self class] __name];           \
}                                                     \
+ (NSNumber *)__name                                  \
{                                                     \
    return [NSNumber numberWithInt:__value];            \
}

#undef	AS_NUMBER
#define AS_NUMBER	AS_STATIC_PROPERTY_NUMBER

#undef	DEF_NUMBER
#define DEF_NUMBER	DEF_STATIC_PROPERTY_NUMBER

#pragma mark -

#undef	AS_STATIC_PROPERTY_STRING
#define AS_STATIC_PROPERTY_STRING( __name )     \
- (NSString *)__name;                         \
+ (NSString *)__name;

#undef	DEF_STATIC_PROPERTY_STRING
#define DEF_STATIC_PROPERTY_STRING( __name, __value )   \
- (NSString *)__name                                  \
{                                                     \
    return [[self class] __name];                       \
}                                                     \
+ (NSString *)__name                                  \
{                                                     \
    return __value;                                     \
}

#undef	AS_STRING
#define AS_STRING	AS_STATIC_PROPERTY_STRING

#undef	DEF_STRING
#define DEF_STRING	DEF_STATIC_PROPERTY_STRING

#undef  AS_PROPERTY_UINT
#define AS_PROPERTY_UINT( __name ) \
@property (nonatomic, assign) NSUInteger    __name;

#undef  AS_PROPERTY_INT
#define AS_PROPERTY_INT( __name ) \
@property (nonatomic, assign) NSInteger     __name;

#undef  AS_PROPERTY_STRING
#define AS_PROPERTY_STRING( __name ) \
@property (nonatomic, strong) NSString*     __name;

#undef  AS_PROPERTY_NUMBER
#define AS_PROPERTY_NUMBER( __name ) \
@property (nonatomic, strong) NSNumber*     __name;

#undef  AS_PROPERTY_ARRAY
#define AS_PROPERTY_ARRAY( __name ) \
@property (nonatomic, strong) NSArray*      __name;

#undef  AS_PROPERTY_DICTIONARY
#define AS_PROPERTY_DICTIONARY( __name ) \
@property (nonatomic, strong) NSDictionary* __name;


#undef  AS_PROPERTY_STRING_COPY
#define AS_PROPERTY_STRING_COPY( __name ) \
@property (nonatomic, copy) NSString*     __name;

#undef  AS_PROPERTY_NUMBER_COPY
#define AS_PROPERTY_NUMBER_COPY( __name ) \
@property (nonatomic, copy) NSNumber*     __name;

#undef DICTIONARY_KEY_VALUE
#define DICTIONARY_KEY_VALUE( __name ) @#__name : @#__name


#endif /* HBProperty_h */
