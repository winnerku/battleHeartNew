//
//  WDRedBatModel.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/11.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDRedBatModel.h"

@implementation WDRedBatModel
- (void)changeArr
{
    self.beHurtArr = [self stateName:@"hurt" textureName:kRedBat number:8];
    NSLog(@"%@",self.beHurtArr);
}
@end
