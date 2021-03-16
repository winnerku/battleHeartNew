//
//  WDLearnSkillView.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/6.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDLearnSkillView.h"

@implementation WDLearnSkillView
{
    NSString *_name;
}

- (instancetype)initWithFrame:(CGRect)frame
                         name:(NSString *)name
                        index:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViewWithName:name index:index];
    }
    return self;
}

- (void)createSubViewWithName:(NSString *)name
                        index:(NSInteger)index
{
    _name = name;
    if ([name isEqualToString:kArcher]) {
        [self archer:index];
    }
}

- (void)archer:(NSInteger)index{
    
    CGFloat width = self.width / 3.0;
   
    //timeArr = @[@(30),@(15),@(10),@(20),@(20)];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger time1 = [defaults integerForKey:kArcher_skill_1];
    NSInteger time2 = [defaults integerForKey:kArcher_skill_2];
    NSInteger time3 = [defaults integerForKey:kArcher_skill_3];
    NSInteger time4 = [defaults integerForKey:kArcher_skill_4];
    NSInteger time5 = [defaults integerForKey:kArcher_skill_5];

    NSString *str1 = [NSString stringWithFormat:@"增加攻击速度\n持续%ld秒\nCD:30秒",time1];
    NSString *str2 = [NSString stringWithFormat:@"连发箭矢攻击\n持续%ld秒\nCD:15秒",time2];
    NSString *str3 = [NSString stringWithFormat:@"增加移动速度\n持续%ld秒\nCD:10秒",time3];
    NSString *str4 = [NSString stringWithFormat:@"攻击100%%吸血\n持续%ld秒\nCD:20秒",time4];
    NSString *str5 = [NSString stringWithFormat:@"还没想好呢\n持续%ld秒\nCD:20秒",time4];
    
    NSArray *labelArr = @[str1,str2,str3,str4,str5];
    
    NSString *name = [NSString stringWithFormat:@"%@_%ld",kArcher,index];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    imageView.image = [UIImage imageNamed:name];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10.f;
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:25.f],NSForegroundColorAttributeName:[UIColor whiteColor],NSParagraphStyleAttributeName:style};
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:labelArr[index] attributes:dic];
    
    imageView.center = CGPointMake(imageView.center.x, self.center.y);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 10, 0, self.width - 20 - imageView.width, self.height)];
    label.attributedText = att;
    label.numberOfLines = 0;
   // label.backgroundColor = [UIColor blackColor];
    [self addSubview:label];
    
    
    BOOL isLearn = [defaults boolForKey:name];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((imageView.width - 45)  / 2.0, (imageView.height - 45) / 2.0, 45, 45)];
    UIImage *image = nil;
    if (isLearn) {
        image = [UIImage imageNamed:@"select_yes"];
    }else{
        if (index - 1 >= 0) {
            NSInteger index2 = index - 1;
            BOOL beforeIsLearn = [defaults boolForKey:[NSString stringWithFormat:@"%@_%ld",kArcher,index2]];
            if (beforeIsLearn) {
                image = [UIImage imageNamed:@"select_no"];
            }else{
                image = [UIImage imageNamed:@"lock"];
            }
        }
    }
    
    btn.tag = index + 100;
    [btn setImage:image forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [btn addTarget:self action:@selector(learnAction:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btn];
    
}

- (void)learnAction:(UIButton *)sender
{
    NSString *name = [NSString stringWithFormat:@"%@_%ld",_name,sender.tag - 100];
    if (self.ClickLearnBlock) {
        self.ClickLearnBlock(name,sender.tag - 100,_name,sender);
    }
}

@end
