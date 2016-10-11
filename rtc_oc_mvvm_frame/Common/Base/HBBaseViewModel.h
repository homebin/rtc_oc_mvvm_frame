//
//  HBBaseViewModel.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HBBaseViewModelInterface<NSObject>

@optional
- (void)loadContent;

@end

@interface HBBaseViewModel : NSObject<HBBaseViewModelInterface>

@property (nonatomic, assign) HBViewState   viewStatus;
@property (nonatomic, assign) HBNetStatus   netStatus;

@end

NS_ASSUME_NONNULL_END
