//
//  WDBoneSoliderNode.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/17.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBoneSoliderNode.h"
#import "WDBoneSoliderModel.h"

@implementation WDBoneSoliderNode
{
    WDBoneSoliderModel *_boneModel;
    WDBaseNode         *_defineNode;
    CGPoint _position;
    int _stagger;
    int _cureNumber;
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDBoneSoliderNode *node = [WDBoneSoliderNode spriteNodeWithTexture:model.walkArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    [super setChildNodeWithModel:model];
   
    self.xScale = 1.7;
    self.yScale = 1.7;
    
    _boneModel = (WDBoneSoliderModel *)model;
    [_boneModel changeArr];
    self.model = _boneModel;
    self.realSize = CGSizeMake(self.size.width - 55, self.size.height - 10);
    
    self.bloodY = self.realSize.height / 2.0 / 2.0 + 10;
    self.bloodHeight = 10;
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.realSize.width, self.realSize.height) center:CGPointMake(0, 0)];
    self.physicsBody = body;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
        
    [self setBodyCanUse];
    
    [self setShadowNodeWithPosition:CGPointMake(-23, -self.size.height / 2.0 + 60) scale:0.11];
    [self setBloodNodeNumber:0];
    [WDNumberManager initNodeValueWithName:kBoneSolider node:self];
    self.balloonNode.xScale = 1.0;
    self.balloonNode.yScale = 1.0;
    self.balloonNode.position = CGPointMake(0, self.size.height / 2.0 - 15);
    self.balloonNode.hidden = YES;
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

- (void)beAttackActionWithTargetNode:(WDBaseNode *)targetNode
{
    [super beAttackActionWithTargetNode:targetNode];
    if (self.lastBlood <= self.blood * 0.1) {
        
        /// 只有忍者未出场的时候出现
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForCallNinja object:nil];
            
        if (_defineNode) {
            return;;
        }
        
        _defineNode = [WDBaseNode spriteNodeWithTexture:_boneModel.defineArr[0]];
        _defineNode.zPosition = 10;
        _defineNode.xScale = 1.5;
        _defineNode.yScale = 1.5;
        _defineNode.name = @"add";
        [self addChild:_defineNode];
        
        _defineNode.position = CGPointMake(10 * self.directionNumber, 0);
        
        SKAction *animation = [SKAction animateWithTextures:_boneModel.defineArr timePerFrame:0.05];
        SKAction *rep = [SKAction repeatActionForever:animation];
        
        //__weak typeof(self)weakSelf = self;
        [_defineNode runAction:rep completion:^{
            
        }];
        
        self.defense = 10000;
        
    }
}

- (void)attackActionWithEnemyNode:(WDBaseNode *)enemyNode
{
    [super attackActionWithEnemyNode:enemyNode];
    
    self.colorBlendFactor = 0;
    //[self removeAllActions];
    
    NSArray *attack1 = [_boneModel.attackArr1 subarrayWithRange:NSMakeRange(0, 1)];
    NSArray *attack2 = [_boneModel.attackArr1 subarrayWithRange:NSMakeRange(1, 3)];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:attack2];
    [arr addObject:attack2.lastObject];
    [arr addObject:attack2.lastObject];
    SKAction *action1 = [SKAction animateWithTextures:attack1 timePerFrame:0.4];
    __weak typeof(self)weakSelf = self;
    [self runAction:action1 completion:^{
        
        SKAction *action2 = [SKAction animateWithTextures:arr timePerFrame:0.1];
        if ([weakSelf canAttack]) {
            [weakSelf.targetMonster beAttackActionWithTargetNode:weakSelf];
           BOOL isDead = [weakSelf.targetMonster setBloodNodeNumber:weakSelf.attackNumber + arc4random() % weakSelf.floatAttackNumber];
            if (isDead) {
                weakSelf.targetMonster = nil;
            }
        }
        [weakSelf runAction:action2 completion:^{
            weakSelf.state = SpriteState_stand;
        }];
    }];
}

- (void)observedNode
{
    [super observedNode];
    
    if (self.state & SpriteState_movie || self.state & SpriteState_init || self.state & SpriteState_stagger || self.state & SpriteState_attack || self.state & SpriteState_dead) {
        return;
    }
    
   
    if (!self.targetMonster) {
        WDBaseNode *target = [WDCalculateTool searchUserNearNode:self];
        if (target) {
            self.targetMonster = target;
        }
        return;
    }
    
    
    /// 玩家死亡
    if (self.targetMonster.state & SpriteState_dead) {
        self.targetMonster = nil;
        self.state = SpriteState_stand;
        return;
    }
    
    if ([self canAttack]) {
        [self attackActionWithEnemyNode:self.targetMonster];
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
        SKAction *texture = [SKAction animateWithTextures:self.model.walkArr timePerFrame:0.2];
        SKAction *rep = [SKAction repeatActionForever:texture];
        [self runAction:rep withKey:@"moveAnimation"];
    }
}

@end
