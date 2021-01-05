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
    
//    NSMutableArray *a = [NSMutableArray array];
//    for (int i = 0; i < 8; i ++) {
//        NSString *name = [NSString stringWithFormat:@"shana_miss_%d",i+1];
//        UIImage *image = [UIImage imageNamed:name];
//        SKTexture *texture = [SKTexture textureWithImage:image];
//        [a addObject:texture];
//    }
//    
//    self.doubleArr = a;
}

@end
