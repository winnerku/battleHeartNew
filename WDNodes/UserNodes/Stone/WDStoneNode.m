//
//  WDStoneNode.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/28.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDStoneNode.h"
#import "WDStoneModel.h"
@implementation WDStoneNode
{
    WDStoneModel *_stoneModel;
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDStoneModel *m = (WDStoneModel *)model;
    WDStoneNode *node = [WDStoneNode spriteNodeWithTexture:m.appearArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    [super setChildNodeWithModel:model];
    _stoneModel = (WDStoneModel *)model;
    
    [WDNumberManager initNodeValueWithName:kStone node:self];

    self.model = model;
    self.name = kStone;
    self.realSize = CGSizeMake(self.size.width - 150, self.size.height - 20);
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:self.realSize center:CGPointMake(0, 0)];
    self.physicsBody = body;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
    
    [self setBodyCanUse];
    
    [self setShadowNodeWithPosition:CGPointMake(10, -self.size.height / 2.0) scale:0.3];
    
}

- (void)appearActionWithBlock:(void (^)(void))completeBlock
{
    SKAction *a = [SKAction animateWithTextures:_stoneModel.appearArr timePerFrame:0.1];
    [self runAction:a completion:^{
        completeBlock();
    }];
}

- (void)openDoorActionWithBlock:(void (^)(void))completeBlock
{
    SKAction *a = [SKAction animateWithTextures:_stoneModel.attackArr1 timePerFrame:0.1];
    SKAction *rep = [SKAction repeatAction:a count:5];
    rep.timingMode = SKActionTimingEaseIn;
    [self runAction:rep completion:^{
        completeBlock();
    }];
}


- (void)standAction
{
    [self removeAllActions];
    SKAction *a = [SKAction animateWithTextures:_stoneModel.walkArr timePerFrame:0.1];
    SKAction *r = [SKAction repeatActionForever:a];
    [self runAction:r withKey:@"stand"];
}

@end
