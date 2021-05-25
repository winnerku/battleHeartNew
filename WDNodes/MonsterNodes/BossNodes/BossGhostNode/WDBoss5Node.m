//
//  WDBoss5Node.m
//  BattleHeartNew
//
//  Created by Mac on 2021/4/20.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBoss5Node.h"
#import "WDBaseScene.h"
@implementation WDBoss5Node
{
    Boss5Model *_bossModel;
    SKEmitterNode *_blackNode;
    SKEmitterNode *_selectNode;
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDBoss5Node *node = [WDBoss5Node spriteNodeWithTexture:model.walkArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    [super setChildNodeWithModel:model];
    
    self.xScale = 2.5;
    self.yScale = 2.5;
    
    _bossModel = (Boss5Model *)model;
    [_bossModel changeArr];
    self.model = _bossModel;
    self.realSize = CGSizeMake(self.size.width - 200, self.size.height - 200);
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.realSize.width,self.realSize.height) center:CGPointMake(0, 0)];
    self.physicsBody = body;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
        
    [self setBodyCanUse];
 
    self.bloodY = 60;
    self.bloodX = -55;
    self.bloodHeight = 10;
    self.bloodWidth = self.realSize.width / 2.0;
//    self.bloodX_adapt_right = 13;
//    self.bloodX_adapt_left = 13;

    [WDNumberManager initNodeValueWithName:kGhost node:self];
    [self setShadowNodeWithPosition:CGPointMake(0, -self.realSize.height / 2.0 + 50) scale:0.13];
    [self setBloodNodeNumber:0];
    
    [self createRealSizeNode];
  
    self.talkNode.xScale = 1;
    self.talkNode.yScale = 1;
    self.talkNode.position = CGPointMake(0, 120);
    
    _blackNode = [SKEmitterNode nodeWithFileNamed:@"GhostSmoke"];
    _blackNode.zPosition = -1;
    _blackNode.position = CGPointMake(0, -self.realSize.height / 2.0 + 60);
    [self addChild:_blackNode];
    
    self.bigBlowNumber = 15;
}


////////////
///爆炸攻击
- (void)blowUpAttackAction{
    
    __weak typeof(self)weakSelf = self;
//    [self runAction:[SKAction moveTo:CGPointMake(0, 0) duration:0.1] completion:^{
        [weakSelf removeAllActions];
        SKAction *an1 = [SKAction animateWithTextures:weakSelf.bossModel.diedArr timePerFrame:0.1];
        SKAction *seq = [SKAction sequence:@[an1]];
        [self runAction:seq completion:^{
            weakSelf.defense = 100000;
            for (int i = 0; i < weakSelf.bigBlowNumber; i ++) {
                [weakSelf blowUp];
            }
        }];
   // }];
}
///爆炸攻击
- (void)blowUp{
    
    SKEmitterNode *lineNode = [SKEmitterNode nodeWithFileNamed:@"GhostBlowUp"];
    lineNode.zPosition = 10000;
    lineNode.targetNode = self;
    lineNode.position = self.position;
    lineNode.xScale = 0.1;
    lineNode.yScale = 0.1;
    [self.parent addChild:lineNode];
    
    
    WDWeaponNode *node = [WDWeaponNode spriteNodeWithTexture:_bossModel.blowUpArr[0]];
    node.xScale = 2.0;
    node.yScale = 2.0;
    [node setShadowNodeWithPosition:CGPointMake(0, -50) scale:0.1];
    
    CGPoint randomPoint = [WDCalculateTool randomPositionWithNode:node];
    CGPoint blackMovePoint = CGPointMake(randomPoint.x, randomPoint.y - 100);
    node.position = randomPoint;
    node.realSize = node.size;
    node.attackNumber = 35;
    node.name = @"ghost_blow";
    node.zPosition = [WDCalculateTool calculateZposition:node];
    
    
    NSArray *ar1 = [_bossModel.blowUpArr subarrayWithRange:NSMakeRange(0, 6)];
    NSArray *ar2 = [_bossModel.blowUpArr subarrayWithRange:NSMakeRange(6, 3)];
    NSArray *ar3 = [_bossModel.blowUpArr subarrayWithRange:NSMakeRange(9, _bossModel.blowUpArr.count - 9)];
    
    SKAction *animation = [SKAction animateWithTextures:ar1 timePerFrame:0.1];
    SKAction *animation2 = [SKAction animateWithTextures:ar2 timePerFrame:0.1];
    SKAction *animation3 = [SKAction animateWithTextures:ar3 timePerFrame:0.1];
    
    CGFloat distance = [WDCalculateTool distanceBetweenPoints:self.position seconde:blackMovePoint];
    NSTimeInterval time = distance / 800;
    
    SKAction *black1 = [SKAction moveTo:blackMovePoint duration:time];
    SKAction *wait = [SKAction waitForDuration:1.5];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[black1,wait,remove]];
    
    __weak typeof(self)weakSelf = self;
    [lineNode runAction:seq completion:^{
        
        [weakSelf.parent addChild:node];
        [node runAction:animation completion:^{
            
            [node createMonsterAttackPhysicBodyWithPoint:CGPointMake(0, -10) size:CGSizeMake(130, 130)];
            
            [node runAction:animation2 completion:^{
                
                node.physicsBody = nil;
                node.shadowNode.hidden = YES;
                [node runAction:[SKAction sequence:@[animation3,[SKAction removeFromParent]]] completion:^{
                    weakSelf.blowNumber ++;
                    if (weakSelf.blowNumber >= weakSelf.bigBlowNumber) {
                        
                        /// 爆炸复原
                        NSMutableArray *diedArr = [NSMutableArray array];
                        for (NSInteger i = weakSelf.bossModel.diedArr.count - 1; i >= 0; i --) {
                            [diedArr addObject:weakSelf.bossModel.diedArr[i]];
                        }
                        
                        [weakSelf runAction:[SKAction animateWithTextures:diedArr timePerFrame:0.1] completion:^{
                            weakSelf.blowNumber = 0;
                            weakSelf.state = SpriteState_stand;
                            weakSelf.isMoveAnimation = NO;
                            weakSelf.defense = 0;
                            weakSelf.bigBlowNumber ++;
                            if (weakSelf.bigBlowNumber >= 20) {
                                weakSelf.bigBlowNumber = 20;
                            }
                        }];
                        
                    }
                }];
                
            }];
            
        }];
    }];
  
}


////////////
///巨斧攻击
- (void)axeAttackAction{
    
    __weak typeof(self)weakSelf = self;
    [self runAction:[SKAction animateWithTextures:_bossModel.attackArr2 timePerFrame:0.1] completion:^{
        WDWeaponNode *node = [WDWeaponNode spriteNodeWithTexture:weakSelf.bossModel.axeArr[0]];
        node.zPosition = [WDCalculateTool calculateZposition:node] + 30;
        node.attackNumber = 25;
        node.name = @"axe";
        [weakSelf.parent addChild:node];
        CGPoint randomPoint = [WDCalculateTool randomPositionWithNode:node];
        randomPoint = CGPointMake(randomPoint.x, 0);
        node.position = randomPoint;
        
        NSArray *arr1 = [weakSelf.bossModel.axeArr subarrayWithRange:NSMakeRange(0, 12)];
        NSArray *arr2 = [weakSelf.bossModel.axeArr subarrayWithRange:NSMakeRange(12, weakSelf.bossModel.axeArr.count - 12)];
        
        SKAction *animation1 = [SKAction animateWithTextures:arr1 timePerFrame:0.1];
        SKAction *animation2 = [SKAction animateWithTextures:arr2 timePerFrame:0.1];
        
        [node runAction:animation1 completion:^{
            [node createMonsterAttackPhysicBodyWithPoint:CGPointMake(0, -70) size:CGSizeMake(node.size.width, node.size.height / 2.0 - 20)];
            [node runAction:[SKAction sequence:@[animation2,[SKAction removeFromParent]]] completion:^{
                weakSelf.state = SpriteState_stand;
            }];
        }];
    }];
    
    
    
}


////////////
///鬼手攻击
- (void)handAttackAction
{
    __weak typeof(self)weakSelf = self;
    [self runAction:[SKAction animateWithTextures:_bossModel.attackArr3 timePerFrame:0.1] completion:^{
        WDWeaponNode *node = [WDWeaponNode spriteNodeWithTexture:weakSelf.bossModel.handArr[0]];
        node.zPosition = [WDCalculateTool calculateZposition:node] + 30;
        node.attackNumber = 10;
        node.name = @"hand";
        node.xScale = 0.7;
        node.yScale = 0.7;
        [weakSelf.parent addChild:node];
        CGPoint randomPoint = [WDCalculateTool randomPositionWithNode:node];
        randomPoint = CGPointMake(randomPoint.x, 0);
        node.position = randomPoint;
        
        NSArray *arr1 = [weakSelf.bossModel.handArr subarrayWithRange:NSMakeRange(0, 15)];
        NSArray *arr2 = [weakSelf.bossModel.handArr subarrayWithRange:NSMakeRange(15, weakSelf.bossModel.handArr.count - 15)];
        
        SKAction *animation1 = [SKAction animateWithTextures:arr1 timePerFrame:0.1];
        SKAction *animation2 = [SKAction animateWithTextures:arr2 timePerFrame:0.1];
        
        [node runAction:animation1 completion:^{
            [node createMonsterAttackPhysicBodyWithPoint:CGPointMake(0, -70) size:CGSizeMake(node.size.width, node.size.height / 2.0 - 20)];
            [node runAction:[SKAction sequence:@[animation2,[SKAction removeFromParent]]] completion:^{
                weakSelf.state = SpriteState_stand;
            }];
        }];
    }];
}


////////////
/// 闪电攻击
- (void)flashAttackAction{
    __weak typeof(self)weakSelf = self;
    [self runAction:[SKAction animateWithTextures:_bossModel.attackArr1 timePerFrame:0.1] completion:^{
        WDWeaponNode *node = [WDWeaponNode spriteNodeWithTexture:weakSelf.bossModel.flashArr[0]];
        node.zPosition = [WDCalculateTool calculateZposition:node] + 30;
        node.attackNumber = 20;
        node.name = @"flash";
        node.xScale = 2.0;
        node.yScale = 2.0;
        [weakSelf.parent addChild:node];
        CGPoint randomPoint = [WDCalculateTool randomPositionWithNode:node];
        randomPoint = CGPointMake(randomPoint.x, 0);
        node.position = randomPoint;
        
        NSArray *arr1 = [weakSelf.bossModel.flashArr subarrayWithRange:NSMakeRange(0, 7)];
        NSArray *arr2 = [weakSelf.bossModel.flashArr subarrayWithRange:NSMakeRange(7, 8)];
        NSArray *arr3 = [weakSelf.bossModel.flashArr subarrayWithRange:NSMakeRange(15, weakSelf.bossModel.flashArr.count - 15)];
        
        SKAction *animation1 = [SKAction animateWithTextures:arr1 timePerFrame:0.1];
        SKAction *animation2 = [SKAction animateWithTextures:arr2 timePerFrame:0.1];
        SKAction *animation3 = [SKAction animateWithTextures:arr3 timePerFrame:0.1];
        
        [node runAction:animation1 completion:^{
            [node createMonsterAttackPhysicBodyWithPoint:CGPointMake(0, -70) size:CGSizeMake(node.size.width, node.size.height / 2.0 - 20)];
            weakSelf.state = SpriteState_stand;
            
            [node runAction:animation2 completion:^{
                node.physicsBody = nil;
                [node runAction:[SKAction sequence:@[animation3,[SKAction removeFromParent]]] completion:^{
                                    
                }];
            }];
        }];
    }];
}


- (void)attackActionWithEnemyNode:(WDBaseNode *)enemyNode
{
    [super attackActionWithEnemyNode:enemyNode];
    
    
    int a = arc4random() % 3;
    
    if (a == 0) {
        // 巨斧攻击
        [self axeAttackAction];
    }else if(a == 1){
        // 分散爆炸攻击
        [self blowUpAttackAction];
    }else if(a == 2){
        // 减速爪
        [self handAttackAction];
    }else if(a == 3){
        // 闪电攻击
        [self flashAttackAction];
    }
    
    self.targetMonster = nil;
    
}

- (void)dealloc
{
    NSLog(@"boss5被销毁了");
}

#pragma mark - 移动 -
- (void)observedNode
{
    [super observedNode];
   
    self.zPosition = [WDCalculateTool calculateZposition:self] + 30;
    
  
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
        SKAction *moveAction = [SKAction animateWithTextures:_bossModel.walkArr timePerFrame:0.1];
        SKAction *rep = [SKAction repeatActionForever:moveAction];
        [self runAction:rep completion:^{
        }];
    }
}

@end
