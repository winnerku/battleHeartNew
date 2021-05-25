//
//  Boss5Model.m
//  BattleHeartNew
//
//  Created by Mac on 2021/4/20.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "Boss5Model.h"

@implementation Boss5Model
- (void)changeArr
{
    NSArray *attack1 = [self.attackArr1 subarrayWithRange:NSMakeRange(0, 7)];
    NSArray *attack2 = [self.attackArr1 subarrayWithRange:NSMakeRange(7, 7)];
    NSArray *attack3 = [self.attackArr1 subarrayWithRange:NSMakeRange(14, self.attackArr1.count - 14)];
    self.attackArr1 = attack1;
    self.attackArr2 = attack2;
    self.attackArr3 = attack3;
    
    self.blowUpArr = [self stateName:@"blowUp" textureName:@"ghost" number:17];
    self.axeArr = [self stateName:@"axe" textureName:@"ghost" number:17];
    self.handArr = [self stateName:@"hand" textureName:@"ghost" number:22];
    self.flashArr = [self stateName:@"flash" textureName:@"ghost" number:17];
}

- (void)dealloc
{
    NSLog(@"我是销毁了");
}

@end
