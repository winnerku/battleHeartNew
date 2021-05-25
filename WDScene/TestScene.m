//
//  TestScene.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/5.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "TestScene.h"
#import "WDBoss1Node.h"

@implementation TestScene
{
    WDBoss1Node *_bossNode;
    WDBoss2Node *_bossNode2;
    WDBoss3Node *_bossNode3;
    WDBoss4Node *_bossNode4;
    SKEmitterNode *_doubleKill;
    WDBaseNode *_node;

}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callAction:) name:kNotificationForCallMonster1 object:nil];
    
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"RedBatScene.png"]];
    CGFloat scale = 2 * kScreenWidth / self.bgNode.size.width;
    self.bgNode.xScale = scale;
    self.bgNode.yScale = scale;
    
    self.textureManager.mapBigY_Up = 100;
    self.textureManager.mapBigY_down = 230;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:kKinght];
     [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForHiddenSkill object:@(1)];
    [self createMonsterWithName:kRedBat position:CGPointMake(10, 10)];
    for (WDMonsterNode *node in self.monsterArr) {
        node.blood = 10000000;
        node.lastBlood = 1000000;
    }
//    [self addChild:self.archerNode];
    [self addChild:self.kNightNode];
//    [self addChild:self.iceWizardNode];
//    [self addChild:self.ninjaNode];
//
//    self.archerNode.position = CGPointMake(0, 0);
//    self.iceWizardNode.position = CGPointMake(-200, 0);
//    self.kNightNode.position = CGPointMake(200, 0);
//    self.ninjaNode.position = CGPointMake(400, 0);
   
//    _bossNode = [WDBoss1Node initWithModel:self.textureManager.boss1Model];
//    _bossNode.state = SpriteState_movie;
//    [self addChild:_bossNode];
//    [self.monsterArr addObject:_bossNode];
//
//    __weak typeof(self)weakSelf = self;
//    [_bossNode moveToTheMap:^(BOOL isComplete) {
//        for (WDBaseNode *node in weakSelf.userArr) {
//            node.state = SpriteState_stand;
//        }
//    }];
}





- (void)touchUpAtPoint:(CGPoint)pos
{
    [super touchUpAtPoint:pos];
}

@end
