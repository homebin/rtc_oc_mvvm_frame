//
//  HBBaseView.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/9.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBBaseView.h"
#import <objc/message.h>

@implementation HBBaseView

- (instancetype)initWithFrame:(CGRect)frame withViewModel:(id)viewModel
{
    self = [self initWithFrame:frame];
    if (self)
    {
        SEL selector = @selector(setViewModel:);
        if ([self respondsToSelector:selector])
        {
            void (*objc_msgSendTypeAll)(id, SEL, id) = (void (*)(id, SEL, id)) objc_msgSend;
            objc_msgSendTypeAll(self, selector, viewModel);
        }
        
        [self loadView];
        [self autoBindingKeyPath];
        [self bindingKeyPath];
        [self afterBindingLoadView];
        
        self.viewState = HBViewState_Content;
    }
    return self;
}

- (void)loadView
{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)autoBindingKeyPath
{
    AUTO_BIND_TARGET(self);
}

- (void)bindingKeyPath
{
    
}

- (void)afterBindingLoadView
{
    
}


@end
