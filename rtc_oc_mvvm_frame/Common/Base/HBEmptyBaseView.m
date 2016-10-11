//
//  HBEmptyBaseView.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/10.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBEmptyBaseView.h"

@implementation HBEmptyBaseView

- (instancetype)initWithFrame:(CGRect)frame withViewModel:(id)viewModel
{
    self = [super initWithFrame:frame withViewModel:viewModel];
    if(self)
    {
        UILabel *loadingLB = [[UILabel alloc] init];
        loadingLB.text = @"暂无内容";
        loadingLB.textColor = [UIColor lightGrayColor];
        loadingLB.font = [UIFont systemFontOfSize:18];
        [self addSubview:loadingLB];
        @weakify(self)
        [loadingLB mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        self.viewState = HBViewState_Empty;
    }
    return self;
}

@end
