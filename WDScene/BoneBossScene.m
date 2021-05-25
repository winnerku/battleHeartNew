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
    int _allRedNumber;
    int _redNumber;
    int _boneNumber;
    int _allBoneNumber;
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
    
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kBoneSolider position:CGPointMake(0, 0)];
    
    _boneNumber = 1;
    _redNumber  = 4;
    _allRedNumber = 10;
    _allBoneNumber = 3;
    
    [self createSnowEmitter];

    
}

- (void)diedAction:(NSNotification *)notification{
    
    [super diedAction:notification];
    
    for (WDBaseNode *node in self.monsterArr) {
        if (node.state & SpriteState_dead){
            
            [node releaseAction];
            
            /// BOSS死亡
            if ([node.name isEqualToString:kBoneKnight]) {
                [self bossDeadAction];
            }
            
            
            [self.monsterArr removeObject:node];
            
            if ([node.name isEqualToString:kRedBat]) {
                
                if (_redNumber < _allRedNumber) {
                    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
                    _redNumber++;
                }
            }
            
            if ([node.name isEqualToString:kBoneSolider]) {
                
                if (_boneNumber < _allBoneNumber) {
                    [self createMonsterWithName:kBoneSolider position:CGPointMake(0, 0)];
                    _boneNumber ++;
                }else{
                    [self createMonsterWithName:kBoneKnight position:CGPointMake(0, 0)];
                }
                
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
                [self backToRealPubScene];
            }
            
            break;
        }
   
    }
    
}

- (void)bossDeadAction{
    
    SKEmitterNode *_doubleKill = (SKEmitterNode *)[self childNodeWithName:@"black"];
    
    CGFloat page = 100;
    
    CGPoint point1 = CGPointMake(-kScreenWidth + page, kScreenHeight - page);
    CGPoint point2 = CGPointMake(kScreenWidth - page, kScreenHeight - page);
    CGPoint point3 = CGPointMake(kScreenWidth - page, -kScreenHeight + page);
    CGPoint point4 = CGPointMake(-kScreenWidth + page, -kScreenHeight + page);
    CGPoint point5 = CGPointMake(-kScreenWidth + page, kScreenHeight - page);
    CGPoint point6 = CGPointMake(0, 0);

    CGFloat distance1 = [WDCalculateTool distanceBetweenPoints:_doubleKill.position seconde:point1];
    CGFloat distance2 = [WDCalculateTool distanceBetweenPoints:point1 seconde:point2];
    CGFloat distance3 = [WDCalculateTool distanceBetweenPoints:point2 seconde:point3];
    CGFloat distance4 = [WDCalculateTool distanceBetweenPoints:point3 seconde:point4];
    CGFloat distance5 = [WDCalculateTool distanceBetweenPoints:point4 seconde:point5];
    CGFloat distance6 = [WDCalculateTool distanceBetweenPoints:point5 seconde:point6];

    CGFloat velocity = 3000.f;
    
    NSTimeInterval time1 = distance1 / velocity;
    NSTimeInterval time2 = distance2 / velocity;
    NSTimeInterval time3 = distance3 / velocity;
    NSTimeInterval time4 = distance4 / velocity;
    NSTimeInterval time5 = distance5 / velocity;
    NSTimeInterval time6 = distance6 / velocity;

    SKAction *move1 = [SKAction moveTo:point1 duration:time1];
    SKAction *move2 = [SKAction moveTo:point2 duration:time2];
    SKAction *move3 = [SKAction moveTo:point3 duration:time3];
    SKAction *move4 = [SKAction moveTo:point4 duration:time4];
    SKAction *move5 = [SKAction moveTo:point5 duration:time5];
    SKAction *move6 = [SKAction moveTo:point6 duration:time6];
    SKAction *seq = [SKAction sequence:@[move1,move2,move3,move4,move5,move6,[SKAction waitForDuration:3],[SKAction removeFromParent]]];
    __weak typeof(self)weakSelf = self;
    [_doubleKill runAction:seq completion:^{
        [weakSelf createReward];
    }];
}

- (void)createReward{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveActionForClick) name:kNotificationForClickPrompt object:nil];
    WDBaseNode *reward = [WDBaseNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"select_no"]]];
    [self addChild:reward];
    reward.name = @"click";
    reward.xScale = 0.1;
    reward.yScale = 0.1;
    reward.alpha = 0;
    reward.zPosition = 10000;
    reward.position = CGPointMake(0,0);
    
    SKAction *alphaA = [SKAction fadeAlphaTo:1 duration:0.6];
    SKAction *xS = [SKAction scaleTo:1.0 duration:0.6];
    SKAction *gr = [SKAction group:@[alphaA,xS]];
    
    _rewardNode = reward;
    
    __weak typeof(self)weakSelf = self;
    [reward runAction:gr completion:^{
        reward.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"select_yes"]];
        weakSelf.clickNode.hidden = NO;
        weakSelf.clickNode.position = CGPointMake(0, 0 - weakSelf.clickNode.size.height / 2.0 - reward.size.width / 2.0 + 10);
        //[weakSelf moveActionForClick];
    }];
}

- (void)moveActionForClick{
    CGPoint movePoint = CGPointMake(kScreenWidth - 90, kScreenHeight - 90);
    CGFloat distance = [WDCalculateTool distanceBetweenPoints:movePoint seconde:_rewardNode.position];
    NSTimeInterval time = distance / 1200;
    SKAction *moveAction = [SKAction moveTo:CGPointMake(kScreenWidth - 90, kScreenHeight - 90) duration:time];
    [self.clickNode removeAllActions];
    [self.clickNode removeFromParent];
    __weak typeof(self)weakSelf = self;
    [_rewardNode runAction:moveAction completion:^{
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kPassCheckPoint3];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger ballCount = [defaults integerForKey:kSkillBall];
        ballCount ++;
        [defaults setInteger:ballCount forKey:kSkillBall];
        weakSelf.textureManager.goText = @"它不是幕后人\n没有任何线索";
        [weakSelf backToRealPubScene];
    }];
}

- (void)releaseAction
{
    [super releaseAction];
    
}

@end
