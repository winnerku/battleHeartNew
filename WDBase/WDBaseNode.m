//
//  WDBaseNode.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseNode.h"

@implementation WDBaseNode

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    return [[WDBaseNode alloc] init];
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    
}


- (void)setBodyCanUse
{
    NSLog(@"1");
}


#pragma mark - 阴影 -
- (void)setShadowNodeWithPosition:(CGPoint)point
                            scale:(CGFloat)scale
{
    SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:@"shadow"]];
    _shadowNode = [WDBaseNode spriteNodeWithTexture:texture];
    _shadowNode.position = point;
    _shadowNode.xScale = scale;
    _shadowNode.yScale = scale;
    _shadowNode.zPosition = -1;
    [self addChild:_shadowNode];
}

#pragma mark - 绿色指示箭头 -
- (void)setArrowNodeWithPosition:(CGPoint)point
                           scale:(CGFloat)scale
{
    SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:@"arrow"]];
    _arrowNode = [WDBaseNode spriteNodeWithTexture:texture];
    _arrowNode.position = point;
    _arrowNode.xScale = scale;
    _arrowNode.yScale = scale;
    _arrowNode.zPosition = 1;
    [self addChild:_arrowNode];
    
    
}

- (void)standAction
{
    SKAction *stand = [SKAction animateWithTextures:self.model.standArr timePerFrame:0.1];
    SKAction *rep = [SKAction repeatActionForever:stand];
    [self runAction:rep withKey:@"stand"];
}

- (void)moveActionWithPoint:(CGPoint)point
{
    [self removeActionForKey:@"move"];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(moveFinish) object:nil];
    
    
    if (point.x > self.position.x) {
        self.xScale = fabs(self.xScale);
    }else{
        self.xScale = -fabs(self.xScale);
    }
    
    CGFloat distanceX = fabs(point.x - self.position.x);
    CGFloat distanceY = fabs(point.y - self.position.y);
    
    CGFloat distance = sqrt(distanceX * distanceX + distanceY * distanceY);
    
    SKAction *move = [SKAction moveTo:point duration:distance / self.moveSpeed];
    
    [self runAction:move withKey:@"move"];
    [self performSelector:@selector(moveFinish) withObject:nil afterDelay:distance / self.moveSpeed];
    
    SKAction *moveAnimation = [self actionForKey:@"moveAnimation"];
    if (!moveAnimation) {
        SKAction *texture = [SKAction animateWithTextures:self.model.walkArr timePerFrame:0.05];
        SKAction *rep = [SKAction repeatActionForever:texture];
        [self runAction:rep withKey:@"moveAnimation"];
    }
}

- (void)moveFinish{
    [self standAction];
    [self removeActionForKey:@"moveAnimation"];
}

@end



@implementation WDUserNode

- (void)setBodyCanUse
{
    self.physicsBody.categoryBitMask    = PLAYER_CATEGORY;
    self.physicsBody.collisionBitMask   = PLAYER_COLLISION;
    self.physicsBody.contactTestBitMask = PLAYER_CONTACT;
}

@end



@implementation WDMonsterNode

- (void)setBodyCanUse
{
    self.physicsBody.categoryBitMask    = MONSTER_CATEGORY;
    self.physicsBody.collisionBitMask   = MONSTER_COLLISION;
    self.physicsBody.contactTestBitMask = MONSTER_CONTACT;
}

@end
