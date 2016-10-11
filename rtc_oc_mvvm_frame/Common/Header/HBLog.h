//
//  HBLog.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#ifndef HBLog_h
#define HBLog_h

#if __HBLOG__

    #undef  TRACE
    #define TRACE               NSLog(@"[TRACE] %s %s:%d", __func__, __FILE__, __LINE__);

    #undef  CC
    #define CC( ... )           NSLog(__VA_ARGS__);

    #undef  INFO
    #define INFO( ... )         NSLog(__VA_ARGS__);

    #undef  PERF
    #define PERF( ... )         NSLog(__VA_ARGS__);

    #undef  WARN
    #define WARN( ... )         NSLog(__VA_ARGS__);

    #undef  ERROR
    #define ERROR( ... )        NSLog(__VA_ARGS__);

    #undef  PRINT
    #define PRINT( ... )        NSLog(__VA_ARGS__);

#else

    #undef  TRACE
    #define TRACE

    #undef  CC
    #define CC( ... )

    #undef  INFO
    #define INFO( ... )

    #undef  PERF
    #define PERF( ... )

    #undef  WARN
    #define WARN( ... )

    #undef  ERROR
    #define ERROR( ... )

    #undef  PRINT
    #define PRINT( ... )

    #endif

    #undef	VAR_DUMP
    #define VAR_DUMP( __obj )	PRINT( [__obj description] );

    #undef	OBJ_DUMP
    #define OBJ_DUMP( __obj )	PRINT( [__obj objectToDictionary] );

#endif /* HBLog_h */


// For Release

#ifdef DEBUG
#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define HBLog(...) printf("%s: %s 第%d行: %s\n\n",[[NSString lr_stringDate] UTF8String], [LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
#define HBRLog(...)
#endif
