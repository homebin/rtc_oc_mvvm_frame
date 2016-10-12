//
//  HBThreadTask.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/12.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBThreadTask.h"

@interface HBThreadTask()

@property (nonatomic, strong) dispatch_queue_t      queue;

@end

@implementation HBThreadTask

- (instancetype)initWithType:(NSNumber*)type
{
    if (self = [super init]) {
        NSString *typeString = [NSString stringWithFormat:@"dispatch_queue_%@", type];
        _queue = dispatch_queue_create([typeString UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - Public
- (void)operationWithBlock:(dispatch_block_t)block
{
    dispatch_async(self.queue, block);
}

@end
