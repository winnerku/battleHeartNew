//
//  WDArcherNode.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/21.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDArcherNode.h"
#import "WDArcherModel.h"
@implementation WDArcherNode
{
    WDArcherModel *_archerModel;
    CGFloat _speed;
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDArcherNode *node = [WDArcherNode spriteNodeWithTexture:model.standArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{

    [super setChildNodeWithModel:model];
    
    self.xScale = 0.5;
    self.yScale = 0.5;

     _archerModel = (WDArcherModel *)model;
    [_archerModel changeArr];
     self.model = model;
     self.realSize = CGSizeMake(self.size.width - 150, self.size.height - 20);
     SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:self.realSize center:CGPointMake(0, 0)];
     self.physicsBody = body;
     self.physicsBody.affectedByGravity = NO;
     self.physicsBody.allowsRotation = NO;
     
     [self setBodyCanUse];
     
     [WDNumberManager initNodeValueWithName:kArcher node:self];
      
     
    
     [self setShadowNodeWithPosition:CGPointMake(0, -self.size.height / 2.0 - 30) scale:0.3];
     [self setArrowNodeWithPosition:CGPointMake(0, self.size.height / 2.0 + 110) scale:1.5];
     [self setBloodNodeNumber:0];
    
    _speed = self.moveSpeed;
//    SKSpriteNode *coloc = [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:self.size];
//    [self addChild:coloc];
    
    [self standAction];
}

- (void)attackAction1WithNode:(WDBaseNode *)enemyNode
{
    
    [super attackAction1WithNode:enemyNode];
    [self removeAllActions];
    self.isAttack = YES;
    self.isMove = NO;
    
    NSArray *a = _archerModel.attackArr1;
    NSArray *laArr = [a subarrayWithRange:NSMakeRange(0, 6)];
    NSArray *attackArr = [a subarrayWithRange:NSMakeRange(6, _archerModel.attackArr1.count - 6)];
    
    NSTimeInterval time = 0.1;
    if (self.skill1) {
        time = 0.03;
    }
    
    SKAction *att = [SKAction animateWithTextures:laArr timePerFrame:time];
    att.timingMode = SKActionTimingEaseIn;
    __weak typeof(self)weakSelf = self;
    [self runAction:att completion:^{
        
        if (weakSelf.isMove) {
            return ;
        }
  
        if (!weakSelf.targetMonster) {
            return;
        }
        
        if (weakSelf.targetMonster.isDead) {
            return;
        }
       
        
        if (weakSelf.skill2) {
            [weakSelf createThreeArrow];
        }else{
            [weakSelf createArrow];
        }
        
        SKAction *att2 = [SKAction animateWithTextures:attackArr timePerFrame:0.05];
        [weakSelf runAction:att2 completion:^{
            weakSelf.isAttack = NO;
        }];
        
    }];
    
}

- (void)createThreeArrow{
    
    SKTexture *arrow = _archerModel.arrowTexture;
    __weak typeof(self)weakSelf = self;

    NSArray *pos = @[@(weakSelf.targetMonster.position),@(CGPointMake(weakSelf.targetMonster.position.x - 40, weakSelf.targetMonster.position.y - 40)),@(CGPointMake(weakSelf.targetMonster.position.x - 40, weakSelf.targetMonster.position.y + 40))];
    for (int i = 0; i < 3; i ++) {
        
        CGPoint targetPoint = [pos[i] CGPointValue];
        WDBaseNode *arrowN = [WDBaseNode spriteNodeWithTexture:arrow];
        arrowN.position = CGPointMake(weakSelf.position.x + 50 * weakSelf.directionNumber, weakSelf.position.y + 10);
        arrowN.zPosition = 10000;
        arrowN.xScale = 0.6;
        arrowN.yScale = 0.6;
        arrowN.zRotation = [WDCalculateTool angleForStartPoint:arrowN.position EndPoint:targetPoint];
        SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(arrowN.size.width / 3.0, arrowN.size.height / 3.0) center:CGPointMake(0, 0)];
        arrowN.physicsBody = body;
        arrowN.physicsBody.affectedByGravity = NO;
        arrowN.physicsBody.allowsRotation = NO;
        arrowN.name = @"user_arrow";
        arrowN.attackNumber = weakSelf.attackNumber;
        body.categoryBitMask = ARROW_CATEGORY;
        body.collisionBitMask = 0;
        [weakSelf.parent addChild:arrowN];
        
        CGFloat distance = [WDCalculateTool distanceBetweenPoints:arrowN.position seconde:targetPoint];
        NSTimeInterval time = distance / 2000;
        
        SKAction *aa = [SKAction moveTo:targetPoint duration:time];
        SKAction *rem = [SKAction removeFromParent];
        SKAction *seee = [SKAction sequence:@[aa,rem]];
        [arrowN runAction:seee completion:^{
        }];
        
        ///火焰
        SKAction *moveAction = [SKAction moveTo:targetPoint duration:time];
        SKAction *alpha = [SKAction scaleTo:0 duration:0.3];
        SKAction *removeAction = [SKAction removeFromParent];
        SKAction *seq = [SKAction sequence:@[moveAction,alpha,removeAction]];
        
        SKEmitterNode *blueFire = [SKEmitterNode nodeWithFileNamed:@"Fire"];
        blueFire.zPosition = 20000;
        blueFire.targetNode = weakSelf.parent;
        blueFire.position = CGPointMake(arrowN.position.x + 10, arrowN.position.y);
        blueFire.name = @"blueFire";
        [blueFire runAction:seq completion:^{
        }];
        
        [weakSelf.parent addChild:blueFire];
    }
     
    
    
    
     
     
     
     
    
}

- (void)createArrow{
    
    SKTexture *arrow = _archerModel.arrowTexture;
    __weak typeof(self)weakSelf = self;

    WDBaseNode *arrowN = [WDBaseNode spriteNodeWithTexture:arrow];
     arrowN.position = CGPointMake(weakSelf.position.x + 50 * weakSelf.directionNumber, weakSelf.position.y + 10);
     arrowN.zPosition = 10000;
     arrowN.xScale = 0.6;
     arrowN.yScale = 0.6;
     arrowN.zRotation = [WDCalculateTool angleForStartPoint:arrowN.position EndPoint:weakSelf.targetMonster.position];
     SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(arrowN.size.width / 3.0, arrowN.size.height / 3.0) center:CGPointMake(0, 0)];
     arrowN.physicsBody = body;
     arrowN.physicsBody.affectedByGravity = NO;
     arrowN.physicsBody.allowsRotation = NO;
     arrowN.name = @"user_arrow";
     arrowN.attackNumber = weakSelf.attackNumber;
     body.categoryBitMask = ARROW_CATEGORY;
     body.collisionBitMask = 0;
     [weakSelf.parent addChild:arrowN];
     
    
     
     CGFloat distance = [WDCalculateTool distanceBetweenPoints:arrowN.position seconde:weakSelf.targetMonster.position];
     NSTimeInterval time = distance / 2000;
     
     SKAction *aa = [SKAction moveTo:weakSelf.targetMonster.position duration:time];
     SKAction *rem = [SKAction removeFromParent];
     SKAction *seee = [SKAction sequence:@[aa,rem]];
     [arrowN runAction:seee completion:^{
     }];
     
     ///火焰
     SKAction *moveAction = [SKAction moveTo:weakSelf.targetMonster.position duration:time];
     SKAction *alpha = [SKAction scaleTo:0 duration:0.3];
     SKAction *removeAction = [SKAction removeFromParent];
     SKAction *seq = [SKAction sequence:@[moveAction,alpha,removeAction]];
     
     SKEmitterNode *blueFire = [SKEmitterNode nodeWithFileNamed:@"Fire"];
     blueFire.zPosition = 20000;
     blueFire.targetNode = weakSelf.parent;
     blueFire.position = CGPointMake(arrowN.position.x + 10, arrowN.position.y);
     blueFire.name = @"blueFire";
     [blueFire runAction:seq completion:^{
     }];
     
     [weakSelf.parent addChild:blueFire];
}

- (BOOL)canAttack{
   
    return YES;
}

- (void)observedNode
{
    [super observedNode];
    
    if (self.isLearn) {
        return;
    }
    
    if (self.isInit) {
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
    
    if (self.isMove) {
        return;
    }
    
    if (self.targetMonster && [self canAttack]) {
        [self attackAction1WithNode:self.targetMonster];
        return;
    }
    
    if (!self.targetMonster) {
        WDBaseNode *target = [WDCalculateTool searchMonsterNearNode:self];
        if (target) {
            self.targetMonster = target;
        }
    }
    
}


#pragma mark - 技能 -
//加速射击技能,持续5秒
- (void)skill1Action
{
    self.skill1 = YES;
    [self performSelector:@selector(cd1) withObject:nil afterDelay:10];
}


- (void)cd1{
    self.skill1 = NO;
}

- (void)skill2Action
{
    self.skill2 = YES;
    [self performSelector:@selector(cd2) withObject:nil afterDelay:8];
}

- (void)cd2{
    self.skill2 = NO;
}

- (void)skill3Action
{
    self.skill3 = YES;
    self.moveSpeed = _speed + 200;
    [self performSelector:@selector(cd3) withObject:nil afterDelay:5];

}

- (void)cd3{
    self.skill3 = NO;
    self.moveSpeed = _speed;
}

- (void)skill4Action
{
    self.skill4 = YES;
    [self performSelector:@selector(cd4) withObject:nil afterDelay:5];

}

- (void)cd4{
    self.skill4 = NO;
   
}
@end
