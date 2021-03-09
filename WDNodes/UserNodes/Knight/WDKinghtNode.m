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
    
    if (self.state & SpriteState_dead) {
        return;
    }
    
    if (self.targetMonster) {
        [self moveToEnemy];
    }
}

- (BOOL)canAttack{
   
    CGPoint point = [WDCalculateTool calculateUserMovePointWithUserNode:self monsterNode:self.targetMonster];
    CGFloat distanceX = self.position.x - point.x;
    CGFloat distanceY = self.position.y - point.y;
    
    if (fabs(distanceX) < 10 && fabs(distanceY) < 30) {
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

- (void)attackActionWithEnemyNode:(WDBaseNode *)enemyNode
{
    [super attackActionWithEnemyNode:enemyNode];
    
    NSArray *att = [self.model.attackArr1 subarrayWithRange:NSMakeRange(0, 6)];
    NSArray *last = [self.model.attackArr1 subarrayWithRange:NSMakeRange(6, self.model.attackArr1.count - 6)];
    //[self removeAllActions];
    self.colorBlendFactor = 0;
    SKAction *texture = [SKAction animateWithTextures:att timePerFrame:0.1];
    texture.timingMode = SKActionTimingEaseIn;
    __weak typeof(self)weakSelf = self;
    [self runAction:texture completion:^{
        
        if (weakSelf.state & SpriteState_move) {
            return ;
        }
        
        BOOL isDead = NO;
        if ([self canReduceTargetBlood]) {
           isDead = [weakSelf.targetMonster setBloodNodeNumber:weakSelf.attackNumber];
            if (isDead) {
                weakSelf.targetMonster = nil;
                [weakSelf standAction];
                return;
            }
        }
        
        //如果之前怪物目标不是玩家，切换下
        if (![weakSelf.targetMonster.targetMonster.name isEqualToString:weakSelf.name] && !isDead) {
            
            [weakSelf.balloonNode setBalloonWithLine:7 hiddenTime:2];
            //吸引仇恨
            weakSelf.targetMonster.targetMonster = weakSelf;
            weakSelf.targetMonster.randomDistanceX = 0;
            weakSelf.targetMonster.randomDistanceY = 0;
            [weakSelf.targetMonster.balloonNode setBalloonWithLine:5 hiddenTime:2];
        }
        
        [weakSelf runAction:[SKAction animateWithTextures:last timePerFrame:0.1] completion:^{
            weakSelf.state = SpriteState_stand;
        }];
    }];

}

- (void)beAttackActionWithTargetNode:(WDBaseNode *)targetNode
{
    
    [super beAttackActionWithTargetNode:targetNode];

    if (!self.targetMonster && !(self.state & SpriteState_move) && !(self.state & SpriteState_init)) {
        self.targetMonster = targetNode;
        targetNode.randomDistanceY = 0;
        targetNode.randomDistanceX = 0;
    }
}

- (void)moveToEnemy{
   
    if (self.targetMonster.state & SpriteState_dead) {
        self.targetMonster = nil;
        [self standAction];
        return;
    }
    
    if (self.state & SpriteState_attack || self.state & SpriteState_move) {
        return;
    }
    
    if ([self canAttack]) {
        [self attackActionWithEnemyNode:self.targetMonster];
        return;
    }
    
    //攻击的对象是自己
    if ((self.targetMonster.state & SpriteState_attack) && [self.targetMonster.targetMonster.name isEqualToString:self.name]) {
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


#pragma mark - 技能 -
- (void)skill1Action
{
    if (self.mockBlock) {
        self.mockBlock();
    }
}

- (void)dealloc
{
    NSLog(@"骑士销毁了");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _kinghtModel = nil;
}

@end
