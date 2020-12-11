//
//  WDRedBatNode.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/11.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDRedBatNode.h"
#import "WDRedBatModel.h"

@implementation WDRedBatNode
{
    WDRedBatModel *_batModel;
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDRedBatNode *node = [WDRedBatNode spriteNodeWithTexture:model.standArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    self.xScale = 0.3;
    self.yScale = 0.3;
    
    _batModel = (WDRedBatModel *)model;
    
    self.model = model;
    self.realSize = CGSizeMake(self.size.width - 80, self.size.height - 10);
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:self.realSize center:CGPointMake(0, 0)];
    self.physicsBody = body;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
        
    [self setBodyCanUse];
    
 
    
    self.name = kRedBat;
    self.moveSpeed = 300;
    self.blood     = 100;
    self.lastBlood = 100;
   
    [self setShadowNodeWithPosition:CGPointMake(0, -self.size.height / 2.0 - 30) scale:0.5];
    [self setArrowNodeWithPosition:CGPointMake(0, self.size.height / 2.0 + 110) scale:1.5];
    [self setBloodNodeWithAttackNumber:0];
   
   
   
   
    SKAction *stand = [SKAction animateWithTextures:self.model.standArr timePerFrame:0.1];
    SKAction *rep = [SKAction repeatActionForever:stand];
    [self runAction:rep withKey:@"stand"];
    
}

@end
