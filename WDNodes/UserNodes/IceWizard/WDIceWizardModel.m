//
//  WDIceWizardModel.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/11.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDIceWizardModel.h"

@implementation WDIceWizardModel

- (void)changeArr{
    
    NSMutableArray *attack1 = [NSMutableArray arrayWithArray:self.attackArr1];
    
    [attack1 addObject:self.attackArr1.firstObject];
    
    self.attackArr1 = attack1;
}

@end
