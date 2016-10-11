//
//  HBContentBaseView.m
//  rtc_oc_mvvm_frame
//
//  Created by 林鸿彬 on 2016/10/10.
//  Copyright © 2016年 林鸿彬. All rights reserved.
//

#import "HBContentBaseView.h"

@implementation HBContentBaseView

- (instancetype)initWithFrame:(CGRect)frame withViewModel:(id)viewModel
{
    self = [super initWithFrame:frame withViewModel:viewModel];
    if(self)
    {
        UILabel *loadingLB = [[UILabel alloc] init];
        loadingLB.text = @"显示正常";
        loadingLB.textColor = [UIColor lightGrayColor];
        loadingLB.font = [UIFont systemFontOfSize:18.0f];
        [self addSubview:loadingLB];
        @weakify(self)
        [loadingLB mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        self.viewState = HBViewState_Content;
    }
    return self;
}

@end
