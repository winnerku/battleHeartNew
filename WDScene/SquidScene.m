//
//  SquidScene.m
//  BattleHeartNew
//
//  Created by Mac on 2021/6/1.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "SquidScene.h"
#import "WDBaseScene+Moive.h"

@implementation SquidScene
{
    WDBoss7Node *_boss;
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

    [self createMonsterWithName:kSquid position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];

    self.passStr = kPassCheckPoint8;
    
    [self createSnowEmitter];

    
}

- (void)diedAction:(NSNotification *)notification{
    
    [super diedAction:notification];
    
    for (WDBaseNode *node in self.monsterArr) {
        
        if (node.state & SpriteState_dead){
            [self.monsterArr removeObject:node];
            [node releaseAction];
            
            
            if ([node.name isEqualToString:kSquid]) {
                WDBoss7Node *boss = (WDBoss7Node *)node;
                for (WDWeaponNode *weapon in boss.inkArr) {
                    [weapon removeAllActions];
                    [weapon runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0 duration:2],[SKAction removeFromParent]]] completion:^{
                                            
                    }];
                }
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
        if ([node.name isEqualToString:kSquid]) {
            _boss = (WDBoss7Node *)node;
            break;
        }
    }
    
    for (WDMonsterNode *node in self.monsterArr) {
        if (![node.name isEqualToString:kSquid]) {
            [node releaseAction];
            break;
        }
    }
    
    [self.monsterArr removeAllObjects];
    [self.monsterArr addObject:_boss];
    
    weakSelf.textureManager.goText = @"尽量躲避炸弹\n加油加油！";
    [_boss.talkNode setText:@"汪汪汪汪！\n汪汪汪汪汪！" hiddenTime:3 completeBlock:^{
        [weakSelf backToRealPubScene];
    }];
    
    
}

@end
