//
//  WDKinghtNode.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/10.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDKinghtNode.h"
#import "WDKinghtModel.h"

@implementation WDKinghtNode
{
    WDKinghtModel *_kinghtModel;
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDKinghtNode *node = [WDKinghtNode spriteNodeWithTexture:model.standArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    NSLog(@"%lf %lf",self.size.width ,self.size.height);
    self.xScale = 0.5;
    self.yScale = 0.5;
    NSLog(@"%lf %lf",self.size.width ,self.size.height);

     _kinghtModel = (WDKinghtModel *)model;
     self.model = model;
     self.realSize = CGSizeMake(self.size.width - 150, self.size.height - 20);
     SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:self.realSize center:CGPointMake(0, 0)];
     self.physicsBody = body;
     self.physicsBody.affectedByGravity = NO;
     self.physicsBody.allowsRotation = NO;
     
     [self setBodyCanUse];
     
     
      
     self.name = kKinght;
     self.moveSpeed = 300;
     self.blood     = 100;
     self.lastBlood = 100;
    
     [self setShadowNodeWithPosition:CGPointMake(0, -self.size.height / 2.0 - 30) scale:0.5];
     [self setArrowNodeWithPosition:CGPointMake(0, self.size.height / 2.0 + 110) scale:1.5];
     [self setBloodNodeWithAttackNumber:0];
    
    
//    SKSpriteNode *coloc = [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:self.size];
//    [self addChild:coloc];
    
     [self standAction];

}



- (void)attackAction1WithNode:(WDBaseNode *)enemyNode
{
    [super attackAction1WithNode:enemyNode];
    
    CGFloat distance = enemyNode.position.x - self.position.x;
    if (distance < 0) {
        self.xScale = -fabs(self.xScale);
    }else{
        self.xScale = +fabs(self.xScale);
    }
   
    [self removeAllActions];
    SKAction *texture = [SKAction animateWithTextures:self.model.attackArr1 timePerFrame:0.1];
    SKAction *rep = [SKAction repeatActionForever:texture];
    rep.timingMode = SKActionTimingEaseIn;
    [self runAction:rep withKey:@"attack1"];

}



@end
