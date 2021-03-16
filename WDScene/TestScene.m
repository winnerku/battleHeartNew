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
    
    //[self addChild:self.ninjaNode];
    
    
    [self createBoss2];
}

- (void)createBoss2{
    
    for (WDBaseNode *node in self.userArr) {
        node.state = SpriteState_movie;
    }
    
    _bossNode = [WDBoss1Node initWithModel:self.textureManager.boss1Model];
    _bossNode.state = SpriteState_movie;
    _bossNode.lastBlood = 3000;
    [self addChild:_bossNode];
    [self.monsterArr addObject:_bossNode];
    
    __weak typeof(self)weakSelf = self;
    [_bossNode moveToTheMap:^(BOOL isComplete) {
        [_bossNode endAction:^(BOOL isComplete) {
                
        }];
    }];
}

- (void)touchUpAtPoint:(CGPoint)pos
{
    [super touchUpAtPoint:pos];
    
}

@end
