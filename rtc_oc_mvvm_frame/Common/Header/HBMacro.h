//
//  HBMacro.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#ifndef HBMacro_h
#define HBMacro_h

//Sigleton Helper
#if __has_feature(objc_instancetype)

#undef	AS_SINGLETON
#define AS_SINGLETON

#undef	AS_SINGLETON
#define AS_SINGLETON( ... )                     \
- (instancetype)sharedInstance;                 \
+ (instancetype)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON                                                   \
- (instancetype)sharedInstance                                        \
{                                                                     \
    return [[self class] sharedInstance];                               \
}                                                                     \
+ (instancetype)sharedInstance                                        \
{                                                                     \
    static dispatch_once_t once;                                        \
    static id __singleton__;                                            \
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );  \
    return __singleton__;                                               \
}

#undef	DEF_SINGLETON
#define DEF_SINGLETON( ... )                                            \
- (instancetype)sharedInstance                                        \
{                                                                     \
    return [[self class] sharedInstance];                               \
}                                                                     \
+ (instancetype)sharedInstance                                        \
{                                                                     \
    static dispatch_once_t once;                                        \
    static id __singleton__;                                            \
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );  \
    return __singleton__;                                               \
}

#else

#undef	AS_SINGLETON
#define AS_SINGLETON( __class )                 \
- (__class *)sharedInstance;                  \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class )                                        \
- (__class *)sharedInstance                                           \
{                                                                     \
    return [__class sharedInstance];                                    \
}                                                                     \
+ (__class *)sharedInstance                                           \
{                                                                     \
    static dispatch_once_t once;                                        \
    static __class * __singleton__;                                     \
    dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
    return __singleton__;                                               \
}

#endif

//Igore Warning
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

#endif

//@weakify
#ifndef    weakify
#if __has_feature(objc_arc)

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")

#else

#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __block __typeof__(x) __block_##x##__ = x; \
_Pragma("clang diagnostic pop")

#endif
#endif

//@strongify
#ifndef    strongify
#if __has_feature(objc_arc)

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")

#else

#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __block_##x##__; \
_Pragma("clang diagnostic pop")

#endif

#endif /* HBMacro_h */
