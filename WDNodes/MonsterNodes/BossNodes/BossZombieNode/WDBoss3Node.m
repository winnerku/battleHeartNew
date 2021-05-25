//
//  WDBoss3Node.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/25.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBoss3Node.h"
#import "Boss3Model.h"
#import "WDBaseScene.h"
@implementation WDBoss3Node
{
    Boss3Model *_bossModel;
    int         _attackNumber;
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDBoss3Node *node = [WDBoss3Node spriteNodeWithTexture:model.walkArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    [super setChildNodeWithModel:model];
    
    self.xScale = 1.8;
    self.yScale = 1.8;
    
    _bossModel = (Boss3Model *)model;
    [_bossModel changeArr];
    self.model = _bossModel;
    self.realSize = CGSizeMake(self.size.width - 100, self.size.height - 50);
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.realSize.width,self.realSize.height) center:CGPointMake(-20, 0)];
    self.physicsBody = body;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
        
    [self setBodyCanUse];
 
    self.bloodY = 50;
    self.bloodHeight = 10;
    self.bloodWidth = self.realSize.width / 2.0;
    self.bloodX_adapt_right = -13;
    self.bloodX_adapt_left = -13;

    [WDNumberManager initNodeValueWithName:kZombie node:self];
    [self setShadowNodeWithPosition:CGPointMake(-23, -self.realSize.height / 2.0 + 40) scale:0.1];
    [self setBloodNodeNumber:0];
    
    [self createRealSizeNode];
  
    self.talkNode.xScale = 1;
    self.talkNode.yScale = 1;
    self.talkNode.position = CGPointMake(0, 120);

}


- (void)attackActionWithEnemyNode:(WDBaseNode *)enemyNode
{
    [super attackActionWithEnemyNode:enemyNode];
//    [self clawAttack];
//    return;
    if (_attackNumber % 15 == 0) {

        _attackNumber ++;
        [self posionAttack];

    }else{
        
        _attackNumber ++;
        [self clawAttack];
    }
}


/// 抓攻击
- (void)clawAttack
{
    NSArray *attack = [_bossModel.attackArr1 subarrayWithRange:NSMakeRange(12, 3)];
    SKAction *action = [SKAction animateWithTextures:attack timePerFrame:0.2];
    action.timingMode = SKActionTimingEaseIn;
    __weak typeof(self)weakSelf = self;
    [self runAction:action completion:^{
        //weakSelf.targetMonster = nil;
        weakSelf.state = SpriteState_stand;
    }];
    
    [self performSelector:@selector(claw) withObject:nil afterDelay:0.15];

}

- (void)claw{
    
   
    WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:_bossModel.clawArr[0]];
    node.xScale = 2.0;
    node.yScale = 2.0;
    node.name = @"ZomClaw";
    node.attackNumber = self.attackNumber;
    [self.parent addChild:node];
    [node createMonsterAttackPhysicBodyWithPoint:CGPointMake(0, 0) size:CGSizeMake(100, 100)];
    node.zPosition = 10000;
    node.position = self.targetMonster.position;
    SKAction *action = [SKAction animateWithTextures:_bossModel.clawArr timePerFrame:0.15];
    SKAction *remo = [SKAction removeFromParent];
    [node runAction:[SKAction sequence:@[action,remo]] completion:^{
            
    }];
    
}

/// 吐毒攻击
- (void)posionAttack{
    
   
    NSArray *attack = [_bossModel.attackArr1 subarrayWithRange:NSMakeRange(0, 12)];
    /// 吐毒攻击
    SKAction *action = [SKAction animateWithTextures:attack timePerFrame:0.15];
    action.timingMode = SKActionTimingEaseIn;
    __weak typeof(self)weakSelf = self;
    [self runAction:action completion:^{
        //weakSelf.targetMonster = nil;
        weakSelf.state = SpriteState_stand;
    }];
    
    [self performSelector:@selector(poisonSmokeAction) withObject:nil afterDelay:5 * 0.15];
}

- (void)poisonSmokeAction{
    
    WDBaseScene *scene = (WDBaseScene *)self.parent;
    for (WDUserNode *userNode in scene.userArr) {
        WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:_bossModel.poisonArr[0]];
        node.xScale = 3.0;
        node.yScale = 3.0;
        node.name = @"poison";
        node.attackNumber = self.attackNumber;
        [self.parent addChild:node];
        [node createMonsterAttackPhysicBodyWithPoint:CGPointMake(0, 0) size:CGSizeMake(100, 100)];
        node.zPosition = 10000;
        node.position = userNode.position;
        SKAction *action = [SKAction animateWithTextures:_bossModel.poisonArr timePerFrame:0.15];
        SKAction *remo = [SKAction removeFromParent];
        [node runAction:[SKAction sequence:@[action,remo]]];
    }
    
}

#pragma mark - 移动 -
- (void)observedNode
{
    [super observedNode];
    self.zPosition = [WDCalculateTool calculateZposition:self] - 10;

    
    if (self.state & SpriteState_attack || self.state & SpriteState_dead || self.state & SpriteState_movie) {
        return;
    }
    
    if (!self.targetMonster) {
        self.targetMonster = [WDCalculateTool searchUserRandomNode:self];
    }
    
    if (self.targetMonster.state & SpriteState_dead) {
        self.targetMonster = nil;
        return;
    }
    
    if (self.targetMonster == nil) {
        return;
    }
    
    CGFloat distance = self.targetMonster.position.x - self.position.x;
    if (distance < 0) {
        self.xScale = -fabs(self.xScale);
        self.direction = @"left";
        self.isRight = NO;
    }else{
        self.xScale = +fabs(self.xScale);
        self.direction = @"right";
        self.isRight = YES;
    }
    
    CGFloat personX = self.targetMonster.position.x;
    CGFloat personY = self.targetMonster.position.y;
    
    CGFloat monsterX = self.position.x;
    CGFloat monsterY = self.position.y;
    
    NSInteger distanceX = personX - monsterX;
    NSInteger distanceY = personY - monsterY;
    
    CGFloat moveX = monsterX;
    CGFloat moveY = monsterY;
    
    if (distanceX > 0) {
        
        self.xScale = 1 * fabs(self.xScale);
        if (fabs(distanceX) <= 400 && fabs(distanceX) >= 380) {
            moveX = monsterX;
        }else if (fabs(distanceX) >= 400) {
            moveX = monsterX + self.moveCADisplaySpeed;
        }else{
            moveX = monsterX - self.moveCADisplaySpeed;
        }

    }else if(distanceX < 0){
        
        self.xScale = -1 * fabs(self.xScale);
        if (fabs(distanceX) <= 400 && fabs(distanceX) >= 380) {
            moveX = monsterX;
        }else if (fabs(distanceX) >= 400) {
            moveX = monsterX - self.moveCADisplaySpeed;
        }else{
            moveX = monsterX + self.moveCADisplaySpeed;
        }
    }
    
    
    CGFloat farX = arc4random() % 500 + 400;
    CGFloat minX = arc4random() % 150 + 50;
    if (fabs(distanceY) < 10 && fabs(distanceX) > minX && fabs(distanceX) < farX) {
        [self attackActionWithEnemyNode:self.targetMonster];
        return;
    }else if(fabs(distanceY) < 10 && fabs(distanceY) > 0){
        moveY = monsterY;
    }else if(distanceY > 0){
        moveY = monsterY + self.moveCADisplaySpeed;
    }else if(distanceY < 0){
        moveY = monsterY - self.moveCADisplaySpeed;
    }
    
    if (moveX < -kScreenWidth + self.realSize.width || moveX > kScreenWidth - self.realSize.width) {
        [self removeAllActions];
        self.reduceBloodNow = NO;
        self.colorBlendFactor = 0;
        self.state = SpriteState_movie;
        
        SKAction *animation = [SKAction animateWithTextures:_bossModel.walkArr timePerFrame:0.1];
        SKAction *move = [SKAction moveTo:CGPointMake(0, 0) duration:_bossModel.walkArr.count * 0.1];
        __weak typeof(self)weakSelf = self;
        [self runAction:[SKAction group:@[animation,move]] completion:^{
            weakSelf.state = SpriteState_stand;
            weakSelf.isMoveAnimation = NO;
        }];
        
        return;
    }
    
    CGPoint calculatePoint = CGPointMake(moveX, moveY);
    
    self.position = calculatePoint;
    self.zPosition = 650 - self.position.y;
    if (!self.isMoveAnimation) {
        
        self.isMoveAnimation = YES;
        //5张
        SKAction *moveAction = [SKAction animateWithTextures:_bossModel.walkArr timePerFrame:0.15];
        SKAction *rep = [SKAction repeatActionForever:moveAction];
        [self runAction:rep completion:^{
        }];
    }
}

- (void)dealloc
{
    NSLog(@"boss3被销毁了");
    _bossModel = nil;
}

@end
