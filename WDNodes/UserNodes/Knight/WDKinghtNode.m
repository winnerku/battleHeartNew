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
     [super setChildNodeWithModel:model];
    
     self.xScale = 0.5;
     self.yScale = 0.5;

     _kinghtModel = (WDKinghtModel *)model;
     self.model = model;
     self.realSize = CGSizeMake(self.size.width - 150, self.size.height - 20);
     SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:self.realSize center:CGPointMake(0, 0)];
     self.physicsBody = body;
     self.physicsBody.affectedByGravity = NO;
     self.physicsBody.allowsRotation = NO;
     
     [self setBodyCanUse];
     
     
     [WDNumberManager initNodeValueWithName:kKinght node:self];

    
    
     [self setShadowNodeWithPosition:CGPointMake(0, -self.size.height / 2.0 - 30) scale:0.3];
     [self setArrowNodeWithPosition:CGPointMake(0, self.size.height / 2.0 + 110) scale:1.5];
     [self setBloodNodeNumber:0];
 
    
     [self standAction];

}

- (void)observedNode
{
    [super observedNode];
    
    if ([self.targetMonster isKindOfClass:[WDMonsterNode class]] && self.targetMonster) {
        [self removeActionForKey:@"move"];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(moveFinishAction) object:nil];
        [self moveToEnemy];
    }
}

- (BOOL)canAttack{
   
    CGPoint point = [WDCalculateTool calculateUserMovePointWithUserNode:self monsterNode:self.targetMonster];
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
    if (fabs(distanceX) < mini + 10 && fabs(distanceY) < 10) {
        return YES;
    }else{
        return NO;
    }
}

- (void)attackAction1WithNode:(WDBaseNode *)enemyNode
{
    [super attackAction1WithNode:enemyNode];
    
   
    NSArray *att = [self.model.attackArr1 subarrayWithRange:NSMakeRange(0, 6)];
    NSArray *last = [self.model.attackArr1 subarrayWithRange:NSMakeRange(6, self.model.attackArr1.count - 6)];
    [self removeAllActions];
    self.colorBlendFactor = 0;
    SKAction *texture = [SKAction animateWithTextures:att timePerFrame:0.1];
    texture.timingMode = SKActionTimingEaseIn;
    __weak typeof(self)weakSelf = self;
    [self runAction:texture completion:^{
        
        if (weakSelf.isMove) {
            return ;
        }
        
         if ([self canReduceTargetBlood]) {
            [weakSelf.targetMonster setBloodNodeNumber:weakSelf.attackNumber];
         }
        
        [weakSelf runAction:[SKAction animateWithTextures:last timePerFrame:0.1] completion:^{
            weakSelf.isAttack = NO;
        }];
    }];

}

- (void)beAttackActionWithTargetNode:(WDBaseNode *)targetNode
{
    
    NSLog(@"%@",self.targetMonster);
    NSLog(@"%d",self.isMove);
    if (!self.targetMonster && !self.isMove) {
        self.targetMonster = targetNode;
        targetNode.randomDistanceY = 0;
        targetNode.randomDistanceX = 0;
    }
}

- (void)moveToEnemy{
   
    if (self.isAttack) {
        if (self.targetMonster.isDead) {
            self.targetMonster = nil;
            [self standAction];
        }
        return;
    }
    
    if ([self canAttack]) {
        [self attackAction1WithNode:self.targetMonster];
        return;
    }
    
    if (self.targetMonster.isAttack) {
        return;
    }
    
     CGPoint point = [WDCalculateTool calculateUserMovePointWithUserNode:self monsterNode:self.targetMonster];
    
    
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
