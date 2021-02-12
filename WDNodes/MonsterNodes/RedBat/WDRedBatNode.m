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
    CGPoint _position;
    int _stagger;
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDRedBatNode *node = [WDRedBatNode spriteNodeWithTexture:model.standArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    [super setChildNodeWithModel:model];
    
    _stagger = 1;
    self.xScale = 0.3;
    self.yScale = 0.3;
    
    _batModel = (WDRedBatModel *)model;
    [_batModel changeArr];
    
    self.model = _batModel;
    self.realSize = CGSizeMake(self.size.width - 80, self.size.height - 10);
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(25, 50) center:CGPointMake(0, 0)];
    self.physicsBody = body;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
        
    [self setBodyCanUse];
 
    
    [WDNumberManager initNodeValueWithName:kRedBat node:self];
   
    [self setShadowNodeWithPosition:CGPointMake(0, -self.size.height / 2.0 - 130) scale:0.3];
    [self setBloodNodeNumber:0];
   
   
//    CGFloat randomX = arc4random() % 25;
//    if (arc4random() % 2 == 0) {
//        self.randomDistanceX  = randomX * -1;
//    }else{
//        self.randomDistanceX  = randomX * 1;
//    }
   
    SKAction *stand = [SKAction animateWithTextures:self.model.standArr timePerFrame:0.1];
    SKAction *rep = [SKAction repeatActionForever:stand];
    [self runAction:rep withKey:@"stand"];
    _position = CGPointMake(0, 0);
}

- (void)beAttackActionWithTargetNode:(WDBaseNode *)targetNode
{
    [WDActionTool demageAnimation:self point:CGPointMake(0, 0) scale:2 demagePic:@""];
    
    ///血量少于一半，硬直
    if (self.lastBlood * 2 < self.blood && _stagger == 1) {
        _stagger = 0;
        [self removeAllActions];
        self.isAttack = NO;
        self.isMove = NO;
        self.isStagger = YES;
        self.colorBlendFactor = 0;
        CGFloat direction = 1;
        if (self.isRight) {
            direction = -1;
        }else{
            direction = 1;
        }
        
        SKAction *action = [SKAction animateWithTextures:self.model.beHurtArr timePerFrame:0.1];
        SKAction *move = [SKAction moveTo:CGPointMake(self.position.x + 60 * direction, self.position.y) duration:0.3];
        SKAction *gr = [SKAction group:@[action,move]];
        __weak typeof(self)weakSelf = self;
        [self runAction:gr completion:^{
            weakSelf.isStagger = NO;
        }];
    }
}

- (void)attackAction1WithNode:(WDBaseNode *)enemyNode
{
    [super attackAction1WithNode:enemyNode];
    
    CGFloat direction = 1;
    if (self.isRight) {
        direction = 1;
    }else{
        direction = -1;
    }
    
    NSArray *sub = [self.model.attackArr1 subarrayWithRange:NSMakeRange(0, 6)];
    NSArray *sub2 = [self.model.attackArr1 subarrayWithRange:NSMakeRange(6, self.model.attackArr1.count - 6)];
    SKAction *texture = [SKAction animateWithTextures:sub timePerFrame:0.1];
    texture.timingMode = SKActionTimingEaseIn;

    
    //突进
    SKAction *wait = [SKAction waitForDuration:0.1 * 4];
    SKAction *move = [SKAction moveTo:CGPointMake(self.position.x + 70 * direction, self.position.y) duration:0.2];
    SKAction *seqq = [SKAction sequence:@[wait,move]];
    SKAction *gro = [SKAction group:@[seqq,texture]];
    
    
    //位移回去
    SKAction *move2 = [SKAction moveTo:self.position duration:0.2];
    move2.timingMode = SKActionTimingEaseOut;
    SKAction *texture2 = [SKAction animateWithTextures:sub2 timePerFrame:0.1 * sub2.count];
    texture2.timingMode = SKActionTimingEaseOut;
    SKAction *gr = [SKAction group:@[move2,texture2]];
    
    
    __weak typeof(self)weakSelf = self;
    [self runAction:gro completion:^{
        
        if ([self canReduceTargetBlood]) {
            [weakSelf.targetMonster setBloodNodeNumber:weakSelf.attackNumber];
            [weakSelf.targetMonster beAttackActionWithTargetNode:weakSelf];
        }
        
        [weakSelf runAction:gr completion:^{
            weakSelf.isAttack = NO;
        }];
        
    }];
}

- (BOOL)canAttack{
   
    CGPoint point = [WDCalculateTool calculateMonsterMovePointWithMonsterNode:self userNode:self.targetMonster];
    CGFloat distanceX = self.position.x - point.x;
    CGFloat distanceY = self.position.y - point.y;
    
    if (fabs(distanceX) < 10 && fabs(distanceY) < 10) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)canReduceTargetBlood{
    CGPoint point = self.targetMonster.position;
    CGFloat distanceX = self.position.x - point.x;
    CGFloat distanceY = self.position.y - point.y;
    
    CGFloat mini = self.realSize.width / 2.0 + self.targetMonster.realSize.width / 2.0 + self.targetMonster.randomDistanceX;
    if (fabs(distanceX) < mini && fabs(distanceY) < fabs(self.randomDistanceY) + 10) {
        return YES;
    }else{
        return NO;
    }
}



- (void)observedNode
{
    [super observedNode];
    if (self.isBoss) {
        
        if (self.isPubScene) {
            int z = 2 * kScreenHeight - self.position.y;
            self.zPosition = z;
        }else{
            self.zPosition = [WDCalculateTool calculateZposition:self];
            self.zPosition = self.zPosition + 100;
        }
    }
    
    
    if (self.isLearn) {
        return;
    }
    
    if (self.isInit) {
        return;
    }
    
    if (self.isStagger) {
        return;
    }
    
    if (!self.targetMonster) {
        WDBaseNode *target = [WDCalculateTool searchUserNearNode:self];
        if (target) {
            self.targetMonster = target;
        }
        return;
    }
    
    if (self.targetMonster.isDead) {
        self.targetMonster = nil;
        [self standAction];
        return;
    }
    
    
    
    
   
   
    if (self.isAttack) {
        return;
    }
    
    if ([self canAttack]) {
        [self attackAction1WithNode:self.targetMonster];
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

@end
