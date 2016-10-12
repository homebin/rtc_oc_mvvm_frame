//
//  HBThreadTask.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/12.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBThreadTask : NSObject

- (instancetype)initWithType:(NSNumber *)type;
- (void)operationWithBlock:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
