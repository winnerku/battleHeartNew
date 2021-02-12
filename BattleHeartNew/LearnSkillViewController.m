//
//  LearnSkillViewController.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/6.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "LearnSkillViewController.h"
#import "WDLearnSkillView.h"
@interface LearnSkillViewController ()
{
    UIScrollView *_bgScrollView;
    UIImageView *_learnImageView;
    CGFloat      _scale;
}
@end

@implementation LearnSkillViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imageView2.image = [UIImage imageNamed:@"iceBg"];
    [self.view addSubview:imageView2];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImage *image = [UIImage imageNamed:@"skillLearnBG"];
    
    CGFloat width = image.size.width / 2.0;
    CGFloat height = image.size.height / 2.0;
    if (height < kScreenHeight) {
        _scale = kScreenHeight / height;
        width = _scale * width;
        height = kScreenHeight;
        
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - width) / 2.0, 0, width, height)];
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    _learnImageView = imageView;
    
    CGFloat cancelBtnWidth = 176 / 2.0;
    CGFloat cancelBtnHeight = 84 / 2.0;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 20 - cancelBtnWidth, 20, cancelBtnWidth, cancelBtnHeight)];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    
    [self createScrollView];
}

- (void)createScrollView
{
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(260 * _scale, kScreenHeight / 3.0, _learnImageView.size.width - 260 * _scale - 60 * _scale, kScreenHeight / 3.0)];
   // _bgScrollView.backgroundColor = [UIColor orangeColor];
    [_learnImageView addSubview:_bgScrollView];
    
    _bgScrollView.pagingEnabled = YES;
    [_bgScrollView setContentSize:CGSizeMake(_bgScrollView.size.width * 5.0, 0)];
    _bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    for (int i = 0; i < 5; i ++) {
        CGFloat x = i * _bgScrollView.width;
        CGFloat y = 0;
        
        WDLearnSkillView *view = [[WDLearnSkillView alloc] initWithFrame:CGRectMake(x, y, _bgScrollView.width, _bgScrollView.height) name:self.userName index:i];
        
        [_bgScrollView addSubview:view];
        
    }
}



- (void)learnAction:(UIButton *)sender
{
    
}

- (void)cancelAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
