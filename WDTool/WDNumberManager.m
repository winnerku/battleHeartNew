//
//  WDNumberManager.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/16.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDNumberManager.h"

@implementation WDNumberManager


+ (void)initNodeValueWithName:(NSString *)name
                         node:(WDBaseNode *)node
{
    NSString *methodName = [NSString stringWithFormat:@"init%@:",name];
    SEL method = NSSelectorFromString(methodName);
    if (method) {
        [self performSelector:method withObject:node];
    }
}

////////////////////// 玩家 ////////////////////
#pragma mark - 骑士 -
+ (void)initKnight:(WDBaseNode *)node
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger skill2 = [defaults integerForKey:kKinght_skill_2];
    if (skill2 == 0) {
        [defaults setInteger:10 forKey:kKinght_skill_2];
    }
    
    NSInteger skill3 = [defaults integerForKey:kKinght_skill_3];
    if (skill3 == 0) {
        [defaults setInteger:10 forKey:kKinght_skill_3];
    }
    
    NSInteger skill4 = [defaults integerForKey:kKinght_skill_4];
    if (skill4 == 0) {
        [defaults setInteger:10 forKey:kKinght_skill_4];
    }
    
    NSInteger skill5 = [defaults integerForKey:kKinght_skill_5];
    if (skill5 == 0) {
        [defaults setInteger:60 forKey:kKinght_skill_5];
    }
    
    node.name = kKinght;
    node.moveSpeed = 300;
    node.trueMoveSpeed = 300;
    node.blood     = 300;
    node.lastBlood = 300;
    node.attackDistance = 0;
    node.moveCADisplaySpeed = 4;
    node.attackNumber = 30;
    node.floatAttackNumber = 5;
    node.isRight = YES;
}

#pragma mark - 冰女巫 -
+ (void)initIceWizard:(WDBaseNode *)node
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger skill1 = [defaults integerForKey:kIceWizard_skill_1];
    if (skill1 == 0) {
        [defaults setInteger:10 forKey:kIceWizard_skill_1];
    }
    
    NSInteger skill3 = [defaults integerForKey:kIceWizard_skill_3];
    if (skill3 == 0) {
        [defaults setInteger:10 forKey:kIceWizard_skill_3];
    }
    
    NSInteger skill4 = [defaults integerForKey:kIceWizard_skill_4];
    if (skill4 == 0) {
        [defaults setInteger:5 forKey:kIceWizard_skill_4];
    }
    
    node.name = kIceWizard;
    node.moveSpeed = 300;
    node.trueMoveSpeed = 300;
    node.moveCADisplaySpeed = 2.5;
    node.blood     = 100;
    node.lastBlood = 100;
    node.zPosition = 10;
    node.addBuff = YES;
    node.cureNumber = 50;
    node.trueCureNumber = 50;
    node.attackNumber = 15;
    node.floatAttackNumber = 10;
}

#pragma mark - 弓箭手 -
+ (void)initArcher:(WDBaseNode *)node
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger skill1 = [defaults integerForKey:kArcher_skill_1];
    if (skill1 == 0) {
        [defaults setInteger:10 forKey:kArcher_skill_1];
    }
    NSInteger skill2 = [defaults integerForKey:kArcher_skill_2];
    if (skill2 == 0) {
        [defaults setInteger:8 forKey:kArcher_skill_2];
    }
    NSInteger skill3 = [defaults integerForKey:kArcher_skill_3];
    if (skill3 == 0) {
        [defaults setInteger:5 forKey:kArcher_skill_3];
    }
    
    NSInteger skill4 = [defaults integerForKey:kArcher_skill_4];
    if (skill4 == 0) {
        [defaults setInteger:5 forKey:kArcher_skill_4];
    }
    
    node.name = kArcher;
    node.moveSpeed = 300;
    node.trueMoveSpeed = 300;
    node.moveCADisplaySpeed = 2.5;
    node.blood     = 100;
    node.lastBlood = 100;
    node.zPosition = 10;
    node.attackNumber = 20;
    node.trueAttackNumber = 20;
    node.floatAttackNumber = 10;
}

/// 忍者
+ (void)initNinja:(WDBaseNode *)node
{
    node.name = kNinja;
    node.moveSpeed = 300;
    node.trueMoveSpeed = 300;
    node.moveCADisplaySpeed = 4.5;
    node.blood     = 100;
    node.lastBlood = 100;
    node.zPosition = 10;
    node.attackNumber = 30;
    node.floatAttackNumber = 10;
}  

/// 石头人
+ (void)initStone:(WDBaseNode *)node
{
    node.name = kArcher;
    node.moveSpeed = 300;
    node.moveCADisplaySpeed = 2.5;
    node.blood     = 100;
    node.lastBlood = 100;
    node.zPosition = 10;
    node.attackNumber = 10;
}

////////////////////// 怪物 ////////////////
#pragma mark - 红色蝙蝠 -
+ (void)initRedBat:(WDBaseNode *)node
{
    node.name = kRedBat;
    node.moveSpeed = 250;
    node.moveCADisplaySpeed = 2;
    node.blood     = 100;
    node.lastBlood = 100;
    node.zPosition = 10;
    node.attackNumber = 10;
}

/// boss1
+ (void)initBoss1:(WDBaseNode *)node
{
    node.name = kBoss1;
    node.moveSpeed = 300;
    node.blood     = 1500;
    node.lastBlood = 1500;
    node.attackDistance = 0;
    node.moveCADisplaySpeed = 2;
    node.attackNumber = 40;
    node.isRight = YES;
    node.floatAttackNumber = 25;
}

/// 骷髅骑士
+ (void)initBoneKnight:(WDBaseNode *)node
{
    node.name = kBoneKnight;
    node.moveSpeed = 300;
    node.blood     = 2000;
    node.lastBlood = 2000;
    node.attackDistance = 0;
    node.moveCADisplaySpeed = 2;
    node.attackNumber = 40;
    node.isRight = YES;
    node.floatAttackNumber = 25;
}

/// 骷髅兵
+ (void)initBoneSolider:(WDBaseNode *)node
{
    node.name = kBoneSolider;
    node.moveSpeed = 300;
    node.blood     = 400;
    node.lastBlood = 400;
    node.attackDistance = 0;
    node.moveCADisplaySpeed = 2;
    node.attackNumber = 25;
    node.isRight = YES;
    node.floatAttackNumber = 25;
}

/// 僵尸
+ (void)initZombie:(WDBaseNode *)node
{
    node.name = kZombie;
    node.moveSpeed = 300;
    node.blood     = 3000;
    node.lastBlood = 3000;
    node.attackDistance = 0;
    node.moveCADisplaySpeed = 2;
    node.attackNumber = 25;
    node.isRight = YES;
    node.floatAttackNumber = 25;
}

/// 牛
+ (void)initOX:(WDBaseNode *)node
{
    node.name = kOX;
    node.moveSpeed = 300;
    node.blood     = 4000;
    node.lastBlood = 4000;
    node.attackDistance = 0;
    node.moveCADisplaySpeed = 2;
    node.attackNumber = 40;
    node.isRight = YES;
    node.floatAttackNumber = 25;
}

/// 鬼魂
+ (void)initGhost:(WDBaseNode *)node
{
    node.name = kGhost;
    node.moveSpeed = 300;
    node.blood     = 6000;
    node.lastBlood = 6000;
    node.attackDistance = 0;
    node.moveCADisplaySpeed = 2;
    node.attackNumber = 40;
    node.isRight = YES;
    node.floatAttackNumber = 25;
}

/// 狗
+ (void)initDog:(WDBaseNode *)node
{
    node.name = kDog;
    node.moveSpeed = 300;
    node.blood     = 6000;
    node.lastBlood = 6000;
    node.attackDistance = 0;
    node.moveCADisplaySpeed = 2;
    node.attackNumber = 40;
    node.isRight = YES;
    node.floatAttackNumber = 25;
}

+ (void)initSquid:(WDBaseNode *)node
{
    node.name = kSquid;
    node.moveSpeed = 300;
    node.blood     = 6000;
    node.lastBlood = 6000;
    node.attackDistance = 0;
    node.moveCADisplaySpeed = 2;
    node.attackNumber = 40;
    node.isRight = YES;
    node.floatAttackNumber = 25;
}

@end
