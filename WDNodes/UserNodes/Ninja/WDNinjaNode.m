//
//  WDNinjaNode.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/15.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDNinjaNode.h"
#import "WDNinjaModel.h"

@implementation WDNinjaNode
{
    WDNinjaModel *_ninjaModel;
    CGFloat _speed;
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDNinjaNode *node = [WDNinjaNode spriteNodeWithTexture:model.standArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    
    [super setChildNodeWithModel:model];
    
    self.xScale = 0.65;
    self.yScale = 0.65;
 
   
    
    self.model = model;
    _ninjaModel = (WDNinjaModel *)model;

    
    self.realSize = CGSizeMake(self.size.width - 230, self.size.height - 150);
 
    self.bloodY = self.realSize.height / (1 / 0.65) + 15;
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:self.realSize center:CGPointMake(0, 0)];
    self.physicsBody = body;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
    
    [self setBodyCanUse];
    
    [WDNumberManager initNodeValueWithName:kNinja node:self];

    [self setBloodNodeNumber:0];
    [self setArrowNodeWithPosition:CGPointMake(0, self.size.height / 2.0 + 50) scale:1.5];
    [self setShadowNodeWithPosition:CGPointMake(0, -self.size.height / 2.0 + 50) scale:0.24];
    
    [self standAction];
    
}

- (void)beAttackActionWithTargetNode:(WDBaseNode *)targetNode
{
    [super beAttackActionWithTargetNode:targetNode];
    
    if (!self.targetMonster) {
        self.targetMonster = targetNode;
    }
    
}


- (BOOL)canAttack{
   
    CGPoint point = [WDCalculateTool calculateUserMovePointWithUserNode:self monsterNode:self.targetMonster];
    point = self.targetMonster.position;
    CGFloat distanceX = self.position.x - point.x;
    CGFloat distanceY = self.position.y - point.y;
    CGFloat minDistance = self.realSize.width / 2.0 + self.targetMonster.realSize.width / 2.0 + self.targetMonster.randomDistanceX;
    
    if (fabs(distanceX) < minDistance && fabs(distanceY) < 30) {
        return YES;
    }else{
        return NO;
    }
}

- (void)observedNode
{
    [super observedNode];
    
    if (!self.targetMonster) {
        return;
    }
    
    if (self.state & SpriteState_movie || self.state & SpriteState_init || self.state & SpriteState_stagger || self.state & SpriteState_attack || self.state & SpriteState_dead || self.state & SpriteState_move) {
        return;
    }
    
   
    /// 玩家死亡
    if (self.targetMonster.state & SpriteState_dead) {
        self.targetMonster = nil;
        [self standAction];
        return;
    }
    
    
    
    
    if ([self canAttack]) {
        [self attackActionWithEnemyNode:self.targetMonster];
        return;
    }
    
    CGPoint point = [WDCalculateTool calculateMonsterMovePointWithMonsterNode:self userNode:self.targetMonster];
    
    
    CGFloat distanceX = self.position.x - point.x;
    CGFloat distanceY = self.position.y - point.y;
    
  
    NSInteger xDirection = 1;
    NSInteger yDirection = 1;
    
    if (distanceX > 0) {
        xDirection = -1;
    }else{
        xDirection = 1;
    }
       
    if (distanceY > 0) {
        yDirection = -1;
    }else{
        yDirection = 1;
    }
       
    CGFloat aDX = fabs(distanceX);
    CGFloat aDY = fabs(distanceY);
    //斜边英文。。。。等比计算
    CGFloat hypotenuse = sqrt(aDX * aDX + aDY * aDY);
       
    CGFloat moveX = self.moveCADisplaySpeed * aDX / hypotenuse * xDirection;
    CGFloat moveY = self.moveCADisplaySpeed * aDY / hypotenuse * yDirection;
       
           
    CGFloat pointX = self.position.x + moveX;
    CGFloat pointY = self.position.y + moveY;
    
    
   
    self.position = CGPointMake(pointX, pointY);
       
    SKAction *moveAnimation = [self actionForKey:@"moveAnimation"];
    if (!moveAnimation) {
        SKAction *texture = [SKAction animateWithTextures:self.model.walkArr timePerFrame:0.05];
        SKAction *rep = [SKAction repeatActionForever:texture];
        [self runAction:rep withKey:@"moveAnimation"];
    }
}

/// 攻击1
- (void)attackActionWithEnemyNode:(WDBaseNode *)enemyNode
{
    [super attackActionWithEnemyNode:enemyNode];
    
    self.state = SpriteState_attack;

    NSArray *attackArr1 = [_ninjaModel.attackArr1 subarrayWithRange:NSMakeRange(0, 6)];
    NSArray *attackArr2 = [_ninjaModel.attackArr1 subarrayWithRange:NSMakeRange(6, _ninjaModel.attackArr1.count - 6)];
    
    SKAction *attack1 = [SKAction animateWithTextures:attackArr1 timePerFrame:0.1];
    SKAction *attack2 = [SKAction animateWithTextures:attackArr2 timePerFrame:0.1];
    
    __weak typeof(self)weakSelf = self;
    [self runAction:attack1 completion:^{
        
        if (weakSelf.state & SpriteState_move) {
            return ;
        }
        
        BOOL isDead = NO;
        if ([self canAttack]) {
           isDead = [weakSelf.targetMonster setBloodNodeNumber:weakSelf.attackNumber];
            if (isDead) {
                weakSelf.targetMonster = nil;
            }
        }
        
        [weakSelf runAction:attack2 completion:^{
            [weakSelf standAction];
        }];
    }];
    
    
   
}

@end
