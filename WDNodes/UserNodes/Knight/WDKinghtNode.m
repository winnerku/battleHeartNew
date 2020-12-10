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
    _kinghtModel = (WDKinghtModel *)model;
    self.model = model;
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:self.size center:CGPointMake(0, 0)];
     self.physicsBody = body;
     self.physicsBody.affectedByGravity = NO;
     self.physicsBody.allowsRotation = NO;
     
     [self setBodyCanUse];
     
     self.xScale = 0.5;
     self.yScale = 0.5;
     
    
    [self setShadowNodeWithPosition:CGPointMake(0, -self.size.height / 2.0 - 30) scale:0.5];
    [self setArrowNodeWithPosition:CGPointMake(0, self.size.height / 2.0 + 200) scale:2];
    
    self.name = kKinght;
    self.moveSpeed = 300;
     
     SKAction *stand = [SKAction animateWithTextures:self.model.standArr timePerFrame:0.1];
     SKAction *rep = [SKAction repeatActionForever:stand];
     [self runAction:rep withKey:@"stand"];
}







@end
