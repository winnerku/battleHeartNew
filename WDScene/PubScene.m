//
//  PubScene.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/18.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "PubScene.h"

@implementation PubScene

- (void)diedAction{
    
    for (WDBaseNode *node in self.userArr) {
        if (node.isDead) {
            [node releaseAction];
            [self.userArr removeObject:node];
            break;
        }
    }
    
    for (WDBaseNode *node in self.monsterArr) {
        if (node.isDead) {
            [node releaseAction];
            [self.monsterArr removeObject:node];
            [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
            break;
        }
    }
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    [self addChild:self.kNightNode];
    [self addChild:self.iceWizardNode];
    [self addChild:self.archerNode];
    
    self.iceWizardNode.position = CGPointMake(0, 0);
    self.kNightNode.position = CGPointMake(-kScreenWidth - 100, 0);
    self.archerNode.position = CGPointMake(100, 0);
    
    [self performSelector:@selector(a) withObject:nil afterDelay:1];
    
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];

}

- (void)a{
    [self.kNightNode moveActionWithPoint:CGPointMake(-150, 0) moveComplete:^{
       }];
}



@end
