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
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:kNinja];
     [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForHiddenSkill object:@(1)];
    
    [self createMonsterWithName:kBoneKnight position:CGPointMake(10, 10)];
    for (WDBaseNode *node in self.monsterArr) {
        _bossNode2 = node;
    }
    
    self.iceWizardNode.lastBlood = 10000;
    self.iceWizardNode.blood = 10000;
    [self addChild:self.iceWizardNode];
    
    
    
}




- (void)touchUpAtPoint:(CGPoint)pos
{
    [super touchUpAtPoint:pos];
    
}

@end
