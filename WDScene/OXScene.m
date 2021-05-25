//
//  OXScene.m
//  BattleHeartNew
//
//  Created by Mac on 2021/4/2.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "OXScene.h"
#import "WDBaseScene+Moive.h"

@implementation OXScene
{
    BOOL _isBossDead;
    WDBoss4Node *_boss;
    WDBaseNode *_rewardNode;
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
    [self createMonsterWithName:kOX position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
   // [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    
    self.passStr = kPassCheckPoint5;
    
    [self createSnowEmitter];

}

- (void)diedAction:(NSNotification *)notification{
    
    [super diedAction:notification];
    
    for (WDBaseNode *node in self.monsterArr) {
        
        if (node.state & SpriteState_dead){
            [self.monsterArr removeObject:node];
            [node releaseAction];
            
            if ([node.name isEqualToString:kRedBat] && !_isBossDead) {
                [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
            }
            
            if ([node.name isEqualToString:kOX]) {
                NSLog(@"boss死了");
                _isBossDead = YES;
                self.textureManager.goText = @"很好很强大！\n继续找老大!";
                [self bossDeadActionMovie];
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
        if ([node.name isEqualToString:kOX]) {
            _boss = (WDBoss4Node *)node;
            break;
        }
    }
    
    for (WDMonsterNode *node in self.monsterArr) {
        if (![node.name isEqualToString:kOX]) {
            [node releaseAction];
            break;
        }
    }
    
    [self.monsterArr removeAllObjects];
    [self.monsterArr addObject:_boss];
    
    weakSelf.textureManager.goText = @"引导闪电球\n攻击他自己";

    [_boss.talkNode setText:@"太弱了太弱了！\n再去练练吧！" hiddenTime:3 completeBlock:^{
        [weakSelf backToRealPubScene];
    }];
}

@end
