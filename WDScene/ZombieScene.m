//
//  ZombieScene.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/25.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "ZombieScene.h"
#import "WDBaseScene+Moive.h"


@implementation ZombieScene
{
    BOOL _isBossDead;
    WDBoss3Node *_boss;
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
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:kArcher];
     [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForHiddenSkill object:@(1)];
    
    self.selectNode = self.archerNode;
    [self createMonsterWithName:kZombie position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    
    self.passStr = kPassCheckPoint4;
    
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
            
            if ([node.name isEqualToString:kZombie]) {
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
        if ([node.name isEqualToString:kZombie]) {
            _boss = (WDBoss3Node *)node;
            break;
        }
    }
    
    for (WDMonsterNode *node in self.monsterArr) {
        if (![node.name isEqualToString:kZombie]) {
            [node releaseAction];
            break;
        }
    }
    
    [self.monsterArr removeAllObjects];
    [self.monsterArr addObject:_boss];
    
    weakSelf.textureManager.goText = @"治疗可以解毒\n注意大家血量";

    [_boss.talkNode setText:@"@@##%$#%#$\n$!@$!@$#!" hiddenTime:3 completeBlock:^{
        [weakSelf backToRealPubScene];
    }];
}

@end
