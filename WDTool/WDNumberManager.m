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
    if ([name isEqualToString:kRedBat]) {
        [self initRedBat:node];
    }else if([name isEqualToString:kKinght]){
        [self initKknight:node];
    }else if([name isEqualToString:kIceWizard]){
        [self initIceWizard:node];
    }
}

////////////////////// 玩家 ////////////////////
#pragma mark - 骑士 -
+ (void)initKknight:(WDBaseNode *)node
{
    node.name = kKinght;
    node.moveSpeed = 300;
    node.blood     = 100;
    node.lastBlood = 80;
    node.attackDistance = 0;
    node.moveCADisplaySpeed = 4;
    node.attackNumber = 10;
    node.isRight = YES;
}

#pragma mark - 冰女巫 -
+ (void)initIceWizard:(WDBaseNode *)node
{
    node.name = kIceWizard;
    node.moveSpeed = 300;
    node.moveCADisplaySpeed = 2.5;
    node.blood     = 300;
    node.lastBlood = 300;
    node.zPosition = 10;
    node.addBuff = YES;
    node.cureNumber = 50;
}

////////////////////// 怪物 ////////////////
#pragma mark - 红色蝙蝠 -
+ (void)initRedBat:(WDBaseNode *)node
{
    node.name = kRedBat;
    node.moveSpeed = 2;
    node.moveCADisplaySpeed = 2;
    node.blood     = 100;
    node.lastBlood = 100;
    node.zPosition = 10;
    node.attackNumber = 10;
}




@end
