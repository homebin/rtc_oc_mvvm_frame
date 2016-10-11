//
//  HBBaseNavigationController.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBBaseNavigationController : UINavigationController<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *currentShowViewController;

@end

NS_ASSUME_NONNULL_END
