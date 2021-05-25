//
//  DogScene.m
//  BattleHeartNew
//
//  Created by Mac on 2021/5/25.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "DogScene.h"

@implementation DogScene

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.speed = 1;
    
    self.textureManager.mapBigY_Up = 100;
    self.textureManager.mapBigY_down = 230;
    
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"RedBatScene.png"]];
    CGFloat scale = 2 * kScreenWidth / self.bgNode.size.width;
    self.bgNode.xScale = scale;
    self.bgNode.yScale = scale;
    
    
    [self addChild:self.archerNode];
    [self addChild:self.kNightNode];
    [self addChild:self.iceWizardNode];
    [self addChild:self.ninjaNode];
    
    self.archerNode.position = CGPointMake(0, 0);
    self.iceWizardNode.position = CGPointMake(-200, 0);
    self.kNightNode.position = CGPointMake(200, 0);
    self.ninjaNode.position = CGPointMake(400, 0);
    
//    self.kNightNode.lastBlood = 100000000;
//    self.kNightNode.blood     = 100000000;
//    self.ninjaNode.lastBlood  = 100000000;
//    self.ninjaNode.blood      = 100000000;
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:kArcher];
     [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForHiddenSkill object:@(1)];
    
    self.selectNode = self.archerNode;

    [self createMonsterWithName:kDog position:CGPointMake(0, 0)];
    
    
    self.passStr = kPassCheckPoint7;
    
    [self createSnowEmitter];

}

@end
