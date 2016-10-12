//
//  HBThreadDispatcher.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/12.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBThreadDispatcher.h"
#import "HBThreadTask.h"

@interface HBThreadDispatcher()

@property (nonatomic, strong) NSMutableDictionary       *taskMapDictionary; //key:class value:taskType
@property (nonatomic, strong) NSMutableDictionary       *threadDictionary;  //key:taskType value:YYThreadTask

@end

@implementation HBThreadDispatcher

#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _taskMapDictionary = [NSMutableDictionary dictionary];
        _threadDictionary = [[NSMutableDictionary alloc] initWithCapacity:HBThreadTaskType_Count];
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - Public
- (void)addClass:(Class)clazz taskType:(HBThreadTaskType)taskType
{
    [self.taskMapDictionary setObject:@(taskType) forKey:NSStringFromClass(clazz)];
}

- (void)operationWithClass:(Class)clazz block:(dispatch_block_t)block
{
    HBThreadTask *task = [self threadTaskForClass:clazz];
    [task operationWithBlock:block];
}

#pragma mark - Private
- (HBThreadTask *)threadTaskForClass:(Class)clazz
{
    NSString *key = NSStringFromClass(clazz);
    NSNumber *taskTypeNumber = [self.taskMapDictionary objectForKey:key];
    return [self threadTaskForKey:taskTypeNumber];
}

- (HBThreadTask *)threadTaskForKey:(NSNumber*)key
{
    HBThreadTask *thread = [self.threadDictionary objectForKey:key];
    if (!thread)
    {
        thread = [[HBThreadTask alloc] initWithType:key];
        [self.threadDictionary setObject:thread forKey:key];
    }
    return thread;
}

@end
