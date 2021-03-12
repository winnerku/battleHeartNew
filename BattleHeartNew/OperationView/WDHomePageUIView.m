//
//  WDHomePageUIView.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/12.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDHomePageUIView.h"

@implementation WDHomePageUIView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    CGFloat btnWidth = 70;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - btnWidth) / 2.0, kScreenHeight - btnWidth, btnWidth, btnWidth)];
    [btn setImage:[UIImage imageNamed:@"backpack"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backPackAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    btn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.7];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius  = btnWidth / 2.0;
    
}

- (void)backPackAction:(UIButton *)sender
{
    
}

@end
