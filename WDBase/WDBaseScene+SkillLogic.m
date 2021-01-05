//
//  WDBaseScene+SkillLogic.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/5.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseScene+SkillLogic.h"



@implementation WDBaseScene (SkillLogic)

- (void)mockSkill
{
    for (int i = 0; i < self.monsterArr.count; i ++) {
        WDMonsterNode *node = self.monsterArr[i];
        [node.balloonNode setBalloonWithLine:5 hiddenTime:2];
        node.targetMonster = self.kNightNode;
    }
}

@end
