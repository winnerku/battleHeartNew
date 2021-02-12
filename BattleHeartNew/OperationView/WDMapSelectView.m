//
//  WDMapSelectView.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/5.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDMapSelectView.h"

@implementation WDMapSelectView
{
    UIScrollView *_scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createScrollView];
    }
    return self;
}

- (void)createScrollView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imageView.image = [UIImage imageNamed:@"gogogo.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //_scrollView.backgroundColor = [UIColor orangeColor]col;
    [self addSubview:_scrollView];
    _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake(kScreenWidth * 2.0, 0)];
    
    CGFloat cancelBtnWidth = 176 / 2.0;
    CGFloat cancelBtnHeight = 84 / 2.0;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 20 - cancelBtnWidth, 20, cancelBtnWidth, cancelBtnHeight)];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self addSubview:cancelBtn];
}

- (void)cancelAction:(UIButton *)sender
{
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

- (void)setDataWithArr:(NSArray *)images
               textArr:(NSArray *)textArr
{
    NSArray *sub = _scrollView.subviews;
    for (UIView *v in sub) {
        [v removeFromSuperview];
    }
    
    
    for (int i = 0; i < images.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50 + kScreenWidth * i, 20, kScreenWidth - 100, kScreenHeight - 40)];
        imageView.image = images[i];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 40.f;
        imageView.layer.borderWidth = 3.f;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:imageView];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:imageView.bounds];
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:imageView.bounds];
        label.text = @"";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont boldSystemFontOfSize:40];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = textArr[i];
        [imageView addSubview:label];
        
    }
    
    [_scrollView setContentSize:CGSizeMake(kScreenWidth * images.count, 0)];
    
    //[self performSelector:@selector(a) withObject:nil afterDelay:0.5];
}

- (void)mapAction:(UIButton *)sender
{
    NSArray *mapArr = @[@"RedBatScene"];
    NSString *mapName = mapArr[sender.tag - 100];
    if (self.selectSceneBlock) {
        self.selectSceneBlock(mapName);
    }
}


@end
