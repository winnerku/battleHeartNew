//
//  WDBoss6Node.m
//  BattleHeartNew
//
//  Created by Mac on 2021/5/25.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBoss6Node.h"
#import "Boss6Model.h"
@implementation WDBoss6Node
{
    Boss6Model *_bossModel;
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDBoss6Node *node = [WDBoss6Node spriteNodeWithTexture:model.walkArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    [super setChildNodeWithModel:model];
    
    self.xScale = 2.5;
    self.yScale = 2.5;
    
    _bossModel = (Boss6Model *)model;
    [_bossModel changeArr];
    self.model = _bossModel;
    self.realSize = CGSizeMake(self.size.width - 200, self.size.height / 2.0);
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.realSize.width,self.realSize.height) center:CGPointMake(-30, -30)];
    self.physicsBody = body;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
        
    [self setBodyCanUse];
 
    self.realCenterX = -30;
    self.realCenterY = -30;
    self.bloodY = 30;
    self.bloodX_adapt_left = -25;
    self.bloodHeight = 10;
    self.bloodWidth = self.realSize.width / 2.0 - 20;
//    self.bloodX_adapt_right = 13;
//    self.bloodX_adapt_left = 13;

    [WDNumberManager initNodeValueWithName:kDog node:self];
    
    [self setShadowNodeWithPosition:CGPointMake(-25, -self.realSize.height / 2.0 + 30) scale:0.2];
    [self setBloodNodeNumber:0];
    
    [self createRealSizeNode];
    [self.balloonNode removeFromParent];
    self.talkNode.xScale = 0.8;
    self.talkNode.yScale = 0.8;
    self.talkNode.position = CGPointMake(0, 80);
    [self standAction];
}

#pragma mark - 攻击 -
- (void)attackActionWithEnemyNode:(WDBaseNode *)enemyNode
{
    [super attackActionWithEnemyNode:enemyNode];
    
    NSArray *arr1 = [_bossModel.attackArr1 subarrayWithRange:NSMakeRange(0, 7)];
    NSArray *arr2 = [_bossModel.attackArr1 subarrayWithRange:NSMakeRange(7, _bossModel.attackArr1.count - 7)];
    
    SKAction *attack = [SKAction animateWithTextures:arr1 timePerFrame:0.1];
    SKAction *attack2 = [SKAction animateWithTextures:arr2 timePerFrame:0.1];

    __weak typeof(self)weakSelf = self;
    [self runAction:attack completion:^{
        
        SKEmitterNode *fireNode = [SKEmitterNode nodeWithFileNamed:@"DogBlowUp"];
        fireNode.position = CGPointMake(weakSelf.position.x + 50 * weakSelf.directionNumber, weakSelf.position.y - 30);
        fireNode.zPosition = 10000;
        fireNode.name     = @"fffff";
        [weakSelf.parent addChild:fireNode];
        fireNode.targetNode = weakSelf;
        
        WDWeaponNode *weapon = [WDWeaponNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(20, 20)];
        weapon.name = @"dogBall";
        [fireNode addChild:weapon];
        weapon.attackNumber = 30;
        [weapon createMonsterAttackPhysicBodyWithPoint:CGPointMake(0, 0) size:CGSizeMake(20, 20)];
        
        CGFloat distance = [WDCalculateTool distanceBetweenPoints:fireNode.position seconde:weakSelf.targetMonster.position];
        NSTimeInterval time = distance / 1300;
        SKAction *fire1Action = [SKAction moveTo:weakSelf.targetMonster.position duration:time];
        SKAction *fire2Action = [SKAction removeFromParent];
        [fireNode runAction:[SKAction sequence:@[fire1Action,fire2Action]] completion:^{
                    
        }];
        
        [weakSelf runAction:attack2 completion:^{
            weakSelf.state = SpriteState_stand;
        }];
        
    }];
    
}

#pragma mark - 移动 -
- (void)observedNode
{
    [super observedNode];
    self.zPosition = [WDCalculateTool calculateZposition:self] + 60;

    
    if (self.state & SpriteState_attack || self.state & SpriteState_dead || self.state & SpriteState_movie) {
        return;
    }
    
    
    //if (!self.targetMonster) {
    self.targetMonster = [WDCalculateTool searchUserRandomNode:self];
    //}
    
    if (self.targetMonster.state & SpriteState_dead) {
        self.targetMonster = nil;
        return;
    }
    
    if (self.targetMonster == nil) {
        return;
    }
    
    [self attackActionWithEnemyNode:self.targetMonster];

    return;
    
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
        SKAction *moveAction = [SKAction animateWithTextures:_bossModel.walkArr timePerFrame:0.1];
        SKAction *rep = [SKAction repeatActionForever:moveAction];
        [self runAction:rep completion:^{
        }];
    }
}

@end
