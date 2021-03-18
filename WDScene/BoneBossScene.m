//
//  BoneBossScene.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/18.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "BoneBossScene.h"

@implementation BoneBossScene
{
    int _redNumber;
    int _boneNumber;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
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
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:kArcher];
     [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForHiddenSkill object:@(1)];
    
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kBoneSolider position:CGPointMake(0, 0)];
    
    _boneNumber = 1;
    _redNumber  = 4;
}

- (void)diedAction:(NSNotification *)notification{
    
    [super diedAction:notification];
    
    for (WDBaseNode *node in self.monsterArr) {
        if (node.state & SpriteState_dead){
            [node releaseAction];
            [self.monsterArr removeObject:node];
            
            if ([node.name isEqualToString:kRedBat]) {
                
                if (_redNumber < 10) {
                    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
                    _redNumber++;
                }
            }
            
            if ([node.name isEqualToString:kBoneSolider]) {
                
                if (_boneNumber < 3) {
                    [self createMonsterWithName:kBoneSolider position:CGPointMake(0, 0)];
                    _boneNumber ++;
                }
                
            }
            
            if (_redNumber + _boneNumber > 13) {
                NSLog(@"该出现BOSS啦！");
            }
            
            
            break;
        }
    }
    
    
}

@end
