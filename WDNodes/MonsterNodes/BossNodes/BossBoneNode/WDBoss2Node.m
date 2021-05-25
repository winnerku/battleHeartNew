//
//  WDBoss2Node.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/19.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBoss2Node.h"
#import "Boss2Model.h"
#import "WDBaseScene.h"
@implementation WDBoss2Node
{
    Boss2Model *_bossModel;
    SKEmitterNode *_doubleKill;
    BOOL _isRush;
    WDBaseNode *_rewardNode;

}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDBoss2Node *node = [WDBoss2Node spriteNodeWithTexture:model.standArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    [super setChildNodeWithModel:model];
    
    self.xScale = 1.8;
    self.yScale = 1.8;
    
    _bossModel = (Boss2Model *)model;
    [_bossModel changeArr];
    self.model = _bossModel;
    self.realSize = CGSizeMake(self.size.width - 100, self.size.height - 50);
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.realSize.width,self.realSize.height) center:CGPointMake(-20, 0)];
    self.physicsBody = body;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
        
    [self setBodyCanUse];
 
    self.bloodY = 80;
    self.bloodHeight = 10;
    self.bloodWidth = self.realSize.width / 2.0;
    
    [WDNumberManager initNodeValueWithName:kBoneKnight node:self];
    [self setShadowNodeWithPosition:CGPointMake(-35, -self.realSize.height / 2.0 + 60) scale:0.15];
    [self setBloodNodeNumber:0];
   
    [self standAction];
    
    [self createRealSizeNode];
  
}

- (void)attackActionWithEnemyNode:(WDBaseNode *)enemyNode
{
    [super attackActionWithEnemyNode:enemyNode];
   
    if (!_doubleKill) {
        _doubleKill = [SKEmitterNode nodeWithFileNamed:@"doubleKill"];
        [self.parent addChild:_doubleKill];
        _doubleKill.name = @"black";
        _doubleKill.targetNode = self.parent;
        _doubleKill.position = CGPointMake(self.position.x, self.position.y - 75);
    }
    
    _isRush = YES;
    
    if (_iceAttackNumber == 2) {
        
        _iceAttackNumber = 0;
        [self alphaMoveAction];
        
    }else if(_isIceAttackIng){
        
        [self alphaMoveAction];
        
    }else{
        
        _iceAttackNumber ++;
        _isIceAttackIng = YES;
        _isRush = NO;
        [self createIceNode];
        SKAction *animation = [SKAction animateWithTextures:_bossModel.attackArr1 timePerFrame:0.1];
        __weak typeof(self)weakSelf = self;
        [self runAction:animation completion:^{
            weakSelf.state = SpriteState_stand;
        }];
        
    }
    
    /// 冰冻攻击不能太频繁
    if (_isIceAttackIng) {
        
        
    }else{
        
    }
    
    
    
    
}


/// 冲刺前隐身移动
- (void)alphaMoveAction
{
    int ax = 1;
    int ay = 1;
    if (arc4random() % 2 == 0) {
        ax = -1;
    }
    if (arc4random() % 2 == 0) {
        ay = -1;
    }
    CGFloat x = kScreenWidth - self.realSize.width;
    CGFloat y = kScreenHeight - self.realSize.height;
    CGPoint movePoint = CGPointMake(x * ax, y * ay);
    CGPoint movePoint2 = CGPointMake(x * ax * -1, y * ay);
    
    __weak typeof(self)weakSelf = self;

    CGFloat distances = [WDCalculateTool distanceBetweenPoints:movePoint seconde:_doubleKill.position];
    NSTimeInterval times = distances / 1200;

    SKAction *alpha = [SKAction fadeAlphaTo:0 duration:0.3];
    [self runAction:alpha completion:^{
        SKAction *move22 = [SKAction moveTo:movePoint duration:times];
        weakSelf.position = movePoint;
        if (movePoint.x < 0) {
            weakSelf.isRight = YES;
        }else{
            weakSelf.isRight = NO;
        }
        
        weakSelf.isRush = NO;
        [weakSelf.doubleKill runAction:move22 completion:^{
            [weakSelf runAction:[SKAction fadeAlphaTo:1 duration:0.6]completion:^{
                [weakSelf rushAttackWithMovePoint:movePoint movePoint2:movePoint2];
            }];
        }];
        
    }];
}


/// 冲刺攻击
- (void)rushAttackWithMovePoint:(CGPoint)movePoint
                     movePoint2:(CGPoint)movePoint2
{
    self.targetMonster = nil;
    self.position = movePoint;
    
    
    WDWeaponNode *node = [WDWeaponNode spriteNodeWithTexture:_bossModel.rushAttackArr[0]];
    node.attackNumber = self.attackNumber * 3.0;
    [self addChild:node];
    
    SKAction *action = [SKAction animateWithTextures:_bossModel.rushAttackArr timePerFrame:0.1];
    SKAction *rep = [SKAction repeatActionForever:action];
    node.name = @"rush";
    [node runAction:rep];
    CGFloat distance = [WDCalculateTool distanceBetweenPoints:movePoint seconde:movePoint2];
    
    NSTimeInterval time = distance / 1200;
    
    SKAction *wait = [SKAction waitForDuration:1.5];
    SKAction *move = [SKAction moveTo:movePoint2 duration:time];
    move.timingMode = SKActionTimingEaseInEaseOut;
    __weak typeof(self)weakSelf = self;
    [self runAction:wait completion:^{
        
        [node createMonsterAttackPhysicBodyWithPoint:CGPointMake(100, -8) size:CGSizeMake(node.size.width / 4.0, node.size.height / 4.0)];
       
        [weakSelf runAction:move completion:^{
            weakSelf.state = SpriteState_stand;
            
            SKAction *alpha = [SKAction fadeAlphaTo:0 duration:0.15];
            SKAction *remo = [SKAction removeFromParent];
            [node runAction:[SKAction sequence:@[alpha,remo]]];
            
        }];
        
    }];
}


/// 冰爪攻击
- (void)createIceNode{
    
    WDBaseScene *scene = (WDBaseScene *)self.parent;
    for (WDBaseNode *userNode in scene.userArr) {
        WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:_bossModel.iceAttackArr[0]];
        node.xScale = 1.5;
        node.yScale = 1.5;
        node.name = @"iceClaw";
        node.attackNumber = self.attackNumber / 2.0;
        [node setShadowNodeWithPosition:CGPointMake(-5, -30) scale:0.13];
        
        [self.parent addChild:node];
        
        node.position = CGPointMake(userNode.position.x, userNode.position.y - 30);
        node.zPosition = userNode.zPosition + 10;
        
        NSArray *attack1 = [_bossModel.iceAttackArr subarrayWithRange:NSMakeRange(0, 10)];
        NSArray *attack2 = [_bossModel.iceAttackArr subarrayWithRange:NSMakeRange(10, _bossModel.iceAttackArr.count - 10)];
        
        SKAction *ani = [SKAction animateWithTextures:attack1 timePerFrame:0.13];
        __weak typeof(self)weakSelf = self;
        [node runAction:ani completion:^{
            [node createMonsterAttackPhysicBodyWithPoint:CGPointMake(0, -30) size:CGSizeMake(node.size.width / 2.0 - 30, node.size.height / 2.0 - 30)];
            SKAction *ani2 = [SKAction animateWithTextures:attack2 timePerFrame:0.1];
            SKAction *remo = [SKAction removeFromParent];
            SKAction *seq = [SKAction sequence:@[ani2,remo]];
            seq.timingMode = SKActionTimingEaseIn;
            
            [node runAction:seq completion:^{
                weakSelf.isIceAttackIng = NO;
            }];
        }];
    }
}

- (void)standAction
{
    if (self.lastBlood <= 0) {
        return;
    }
    if (self.state & SpriteState_movie) {
        self.state = SpriteState_stand | SpriteState_movie;
    }else{
        self.state = SpriteState_stand;
    }
    
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(moveFinishAction) object:nil];
    [self removeAllActions];
    self.reduceBloodNow = NO;
    self.colorBlendFactor = 0;
    SKAction *stand = [SKAction animateWithTextures:self.model.standArr timePerFrame:0.3];
    SKAction *rep = [SKAction repeatActionForever:stand];
    [self runAction:rep withKey:@"stand"];
}



#pragma mark - 移动逻辑 -
- (void)observedNode
{
    [super observedNode];
    self.zPosition = [WDCalculateTool calculateZposition:self] + 30;

    if (_doubleKill && !_isRush) {
        _doubleKill.position = CGPointMake(self.position.x - 20, self.position.y - 75);
    }
    
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

@end
