//
//  HBThreadDispatcher.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/12.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBThreadTaskType.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBThreadDispatcher : NSObject

//子类继承可使用不同线程
- (void)addClass:(Class)clazz taskType:(HBThreadTaskType)taskType;

//异步调用，请确认block的生命周期
- (void)operationWithClass:(Class)clazz block:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
