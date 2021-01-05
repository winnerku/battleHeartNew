//
//  WDSkillView.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/23.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDSkillView.h"
#import "WDSkillBtn.h"
@implementation WDSkillView
{
    NSMutableDictionary *_skillViewDic;
    NSArray *_timeArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUser:) name:kNotificationForChangeUser object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(canUse:) name:kNotificationForSkillCanUse object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(show:) name:kNotificationForShowSkill object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isHiddenOrShow:) name:kNotificationForHiddenSkill object:nil];

    }
    return self;
}

- (void)isHiddenOrShow:(NSNotification *)notifiaction
{
    int a = [notifiaction.object intValue];
    if (a == 0) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
}

- (void)show:(NSNotification *)notifiaction
{
    UIImageView *imageVV = [self viewWithTag:1000];
    [imageVV removeFromSuperview];
    
    
    int tag = [notifiaction.object intValue];
    if (tag == 5) {
        return;
    }
    NSArray *arr = self.skillViewDic[@"Archer_arr"];
    CGFloat width1 = 67 / 2.0;
    CGFloat height = 152 / 2.0;
       
    UIButton *btn = arr[tag];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, -height, width1, height)];
    imageV.center = CGPointMake(btn.center.x, imageV.center.y);
    imageV.image = [UIImage imageNamed:@"arrow"];
    imageV.tag = 1000;
    [self addSubview:imageV];
       
}

- (void)canUse:(NSNotification *)notification
{
    self.userInteractionEnabled = YES;
}

- (void)createSubViewsWithName:(NSString *)name{
    CGFloat width = 50;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.hidden = YES;
    [self addSubview:bgView];
    for (int i = 0; i < 5; i ++) {
       
        WDSkillBtn *btn = [[WDSkillBtn alloc] initWithFrame:CGRectMake(i * width + i * 10, 0, width, width)];
        NSString *skillName = [NSString stringWithFormat:@"%@_%d",name,i];
        UIImage *image = [UIImage imageNamed:skillName];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(skillAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        [bgView addSubview:btn];
        btn.backgroundColor = UICOLOR_RANDOM;
        [arr addObject:btn];
        if (!image) {
            btn.hidden = YES;
        }
        
    }
    
    NSArray *timeArr = @[];
    ///射手时间轴
    if ([name isEqualToString:kArcher]) {
        timeArr = @[@(30),@(15),@(10),@(10),@(10)];
    }else if([name isEqualToString:kIceWizard]){
        timeArr = @[@(30),@(15),@(10),@(10),@(10)];
    }else{
        timeArr = @[@(30),@(15),@(10),@(10),@(10)];
    }
    
    NSString *viewNameKey = [NSString stringWithFormat:@"%@_view",name];
    NSString *btnArrKey   = [NSString stringWithFormat:@"%@_arr",name];
    NSString *timeArrKey  = [NSString stringWithFormat:@"%@_time",name];
    
    [self.skillViewDic setValue:bgView forKey:viewNameKey];
    [self.skillViewDic  setValue:arr forKey:btnArrKey];
    [self.skillViewDic  setValue:timeArr forKey:timeArrKey];
    
}

- (void)skillOK:(NSDictionary *)dic
{
    
}

- (void)skillAction:(WDSkillBtn *)sender
{
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    
    CGFloat time = [_timeArr[sender.tag - 100]floatValue];
    [sender setTime:time];
    
    if (self.skillActionBlock) {
        self.skillActionBlock(sender.tag);
    }
    
    if (sender.tag == 100) {
        NSLog(@"技能1");
    }else if(self.tag == 101){
        NSLog(@"技能2");
    }else if(self.tag == 102){
        NSLog(@"技能3");
    }else if(self.tag == 103){
        NSLog(@"技能4");
    }else if(self.tag == 104){
        NSLog(@"技能5");
    }
}

- (void)setSkillViewWithUserName:(NSString *)name
{
    NSString *viewNameKey = [NSString stringWithFormat:@"%@_view",name];
    NSString *btnArrKey   = [NSString stringWithFormat:@"%@_arr",name];
    NSString *timeArrKey  = [NSString stringWithFormat:@"%@_time",name];
    
    
    if (!self.skillViewDic[btnArrKey]) {
        [self createSubViewsWithName:name];
    }
    
    for (int i = 0; i < self.skillViewDic.allKeys.count; i ++) {
        NSString *keyName = self.skillViewDic.allKeys[i];
       
        //背景
        if ([keyName containsString:@"_view"]) {
            UIView *view = self.skillViewDic[keyName];
            if ([keyName isEqualToString:viewNameKey]) {
                view.hidden = NO;
            }else{
                view.hidden = YES;
            }
        }
        
        //技能cd
        if ([keyName containsString:@"_time"]) {
            if ([keyName isEqualToString:timeArrKey]) {
                _timeArr = self.skillViewDic[keyName];
            }
        }
        
        
    }
    

}

- (void)changeUser:(NSNotification *)notification
{
    [self setSkillViewWithUserName:notification.object];
}

- (NSMutableDictionary *)skillViewDic
{
    if (!_skillViewDic) {
        _skillViewDic = [NSMutableDictionary dictionary];
    }
    
    return _skillViewDic;
}

@end
