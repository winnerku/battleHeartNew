//
//  GhostScene.m
//  BattleHeartNew
//
//  Created by Mac on 2021/4/20.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "GhostScene.h"
#import "WDBaseScene+Moive.h"

@implementation GhostScene
{
    WDBoss5Node *_boss;
    BOOL _isBossDead;

}

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

    [self createMonsterWithName:kGhost position:CGPointMake(0, 0)];
    
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];

    
    self.passStr = kPassCheckPoint6;
    
    [self createSnowEmitter];

}


- (void)diedAction:(NSNotification *)notification{
    
    [super diedAction:notification];
    
    for (WDBaseNode *node in self.monsterArr) {
        
        if (node.state & SpriteState_dead){
            [self.monsterArr removeObject:node];
            [node releaseAction];
            
            
            if ([node.name isEqualToString:kGhost]) {
                _isBossDead = YES;
                [self bossDeadActionMovie];
               
            }
            
            
            
            if ([node.name isEqualToString:kRedBat] && !_isBossDead) {
                [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
            }
            
            break;
        }
    }
    
    
    for (WDUserNode *node in self.userArr) {
        if (node.state & SpriteState_dead) {
            
            [self.userArr removeObject:node];
            [node releaseAction];
            
            if ([node.name isEqualToString:self.selectNode.name]) {
                self.selectNode = self.userArr.firstObject;
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:self.selectNode.name];
                [self.selectNode selectSpriteAction];
            }
            
            if (self.userArr.count == 0) {
                [self diedAll];
            }
            break;
        }
    }
    
}

- (void)diedAll{
    __weak typeof(self)weakSelf = self;
  
    for (WDMonsterNode *node in self.monsterArr) {
        if ([node.name isEqualToString:kGhost]) {
            _boss = (WDBoss5Node *)node;
            break;
        }
    }
    
    for (WDMonsterNode *node in self.monsterArr) {
        if (![node.name isEqualToString:kGhost]) {
            [node releaseAction];
            break;
        }
    }
    
    [self.monsterArr removeAllObjects];
    [self.monsterArr addObject:_boss];
    
    weakSelf.textureManager.goText = @"尽量躲避炸弹\n加油加油！";
    [_boss.talkNode setText:@"我是幽灵！\n我是幽灵哦！" hiddenTime:3 completeBlock:^{
        [weakSelf backToRealPubScene];
    }];
    
    
}

@end
