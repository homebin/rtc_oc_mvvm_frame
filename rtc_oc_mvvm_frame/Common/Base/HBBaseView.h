//
//  HBBaseView.h
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HBBaseViewInterface

- (instancetype)initWithFrame:(CGRect)frame withViewModel:(id)viewModel;
- (void)loadView;
- (void)bindingKeyPath;
- (void)afterBindingLoadView;

@optional
- (void)setViewModel:(id)viewModel;

@end

@interface HBBaseView : UIView<HBBaseViewInterface>

@property (nonatomic, assign) HBViewState  viewState;

@end

NS_ASSUME_NONNULL_END
