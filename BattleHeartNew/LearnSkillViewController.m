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
        
        __weak typeof(self)weakSelf = self;
        [view setClickLearnBlock:^(NSString * _Nonnull skillName, NSInteger index,NSString * _Nonnull userName,UIButton *sender) {
            [weakSelf learnAction:skillName index:index userName:userName sender:sender];
        }];
        
    }
}

- (void)learnAction:(NSString *)skillName
              index:(NSInteger)index
           userName:(NSString *)userName
             sender:(UIButton *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isLearn = [defaults boolForKey:skillName];
    if (isLearn) {
        
        [self isLearnAlertView];
        
    }else{
        
        if (index - 1 >= 0) {
            NSInteger beforeIndex = index - 1;
            BOOL isBeforeLearn = [defaults boolForKey:[NSString stringWithFormat:@"%@_%ld",userName,beforeIndex]];
            if (isBeforeLearn) {
                [self learnAction:skillName sender:sender];
            }else{
                [self beforeSkillIsNoLearn];
            }
            
        }
        
    }
}

- (void)learnAction:(NSString *)skillName
             sender:(UIButton *)sender{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger ball = [defaults integerForKey:kSkillBall];
    if (ball > 0) {
        
        ///这里要判断是否有钱
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"学习该技能将会消耗一个绿球道具\n确定学习嘛？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"在想想..." style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSInteger balls = [defaults integerForKey:kSkillBall];
            balls --;
            [defaults setInteger:balls forKey:kSkillBall];
            [defaults setBool:YES forKey:skillName];
            [sender setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForLearnSkill object:nil];
        }];
        
        [alertC addAction:action];
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:^{
        }];
        
    }else{
        ///这里要判断是否有钱
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"没有相对应的道具" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:^{
        }];
    }
    
}


/// 新技能需要解锁上一个技能才可以学习
- (void)beforeSkillIsNoLearn{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请先学习上一个技能！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:^{
    }];
}


- (void)isLearnAlertView{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"已经学过了！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:^{
    }];
}

- (void)cancelAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
