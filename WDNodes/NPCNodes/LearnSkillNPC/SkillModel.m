//
//  SkillModel.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/6.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "SkillModel.h"

@implementation SkillModel
- (void)changeArr
{
    WDTextureManager *m = [WDTextureManager shareTextureManager];
    self.standArr = [m loadWithImageName:@"npc_Base_stay_" count:9];
    self.sitArr = [m loadWithImageName:@"npc_Base_sit_" count:6];
    self.learnArr = [m loadWithImageName:@"npc_Base_learn_" count:2];
}
@end
