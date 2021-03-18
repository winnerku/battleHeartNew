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
    SKEmitterNode *_doubleKill;
    
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
    
    self.talkNode.position = CGPointMake(0, self.realSize.height + 70);
    self.talkNode.xScale = 2.5;
    self.talkNode.yScale = 2.5;
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
    
    if (_doubleKill) {
        _doubleKill.position = CGPointMake(self.position.x, self.position.y - 75);
    }
    
    
    
    if (self.state & SpriteState_movie || self.state & SpriteState_init || self.state & SpriteState_stagger || self.state & SpriteState_attack || self.state & SpriteState_dead || self.state & SpriteState_move) {
        return;
    }
    
    
    if (!self.targetMonster) {
        WDBaseNode *target = [WDCalculateTool searchMonsterNearNode:self];
        if (target) {
            self.targetMonster = target;
        }
        return;
    }
    
   
    /// 玩家目标死亡
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


/// 双倍攻击，远距离瞬移
- (void)doubleAttack:(WDBaseNode *)enemyNode
{
    self.state = SpriteState_attack;
    
    WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:[WDTextureManager shareTextureManager].smokeArr[0]];
    
    node.position = self.position;
    node.zPosition = 10000;
    node.name = @"smoke";
    node.xScale = 1.5;
    node.yScale = 1.5;
    [self.parent addChild:node];
    SKAction *lightA = [SKAction animateWithTextures:[WDTextureManager shareTextureManager].smokeArr timePerFrame:0.075];
    SKAction *alphaA = [SKAction fadeAlphaTo:0.2 duration:[WDTextureManager shareTextureManager].smokeArr.count * 0.03];
    SKAction *r = [SKAction removeFromParent];
    SKAction *s = [SKAction sequence:@[[SKAction group:@[lightA,alphaA]],r]];
    
    SKAction *alpha = [SKAction fadeAlphaTo:0 duration:[WDTextureManager shareTextureManager].smokeArr.count * 0.03];
    __weak typeof(self)weakSelf = self;
    [self runAction:alpha completion:^{
        
        weakSelf.position = CGPointMake(enemyNode.position.x - enemyNode.directionNumber * 10, enemyNode.position.y - 20);
        CGFloat distance = enemyNode.position.x - weakSelf.position.x;
        if (distance < 0) {
            weakSelf.xScale = -fabs(self.xScale);
            weakSelf.direction = @"left";
            weakSelf.isRight = NO;
        }else{
            weakSelf.xScale = +fabs(self.xScale);
            weakSelf.direction = @"right";
            weakSelf.isRight = YES;
        }
        
        NSArray *attackArr1 = [weakSelf.model.attackArr1 subarrayWithRange:NSMakeRange(2,5)];
        SKAction *alpha2 = [SKAction fadeAlphaTo:1 duration:0.3];
       
        
        
        [weakSelf runAction:alpha2 completion:^{
            [weakSelf runAction:[SKAction animateWithTextures:attackArr1 timePerFrame:0.05] completion:^{
                
                BOOL isDead = NO;
                if ([self canAttack]) {
                   
                    int attackNumber = weakSelf.attackNumber * 2.0;
                    int targetLastBlood = weakSelf.targetMonster.lastBlood;
                    int targetAllBlood  = weakSelf.targetMonster.blood;
                       
                    if(targetAllBlood * 0.10 > targetLastBlood){
                        ///低于10%血量，直接斩杀
                        attackNumber = targetAllBlood;
                        isDead = [weakSelf.targetMonster setBloodNodeNumber:attackNumber reduceDefenseNumber:INT_MAX];
                        
                     }else if(targetAllBlood * 0.15 > targetLastBlood){
                        ///低于15%血量，百分之50几率斩杀
                        int index = arc4random() % 2;
                        if (index == 0) {
                            attackNumber = targetAllBlood;
                            isDead = [weakSelf.targetMonster setBloodNodeNumber:attackNumber reduceDefenseNumber:INT_MAX];
                        }else{
                            isDead = [weakSelf.targetMonster setBloodNodeNumber:attackNumber];
                        }
                        
                        
                     }else{
                         isDead = [weakSelf.targetMonster setBloodNodeNumber:attackNumber];
                     }
                    
                    ///攻击吸血
                    [weakSelf setBloodNodeNumber:-attackNumber];
                    if (isDead) {
                        weakSelf.targetMonster = nil;
                    }
                }
                
                weakSelf.state = SpriteState_stand;
                weakSelf.skill1 = NO;
                
            }];
        }];
    }];
    
    [_doubleKill runAction:alpha completion:^{
        [weakSelf removeDoubleKill];
    }];
    
    [node runAction:s completion:^{
        
    }];
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
        
        [weakSelf removeDoubleKill];

        BOOL isDead = NO;
        if ([self canAttack]) {
           
        
            int attackNumber = weakSelf.attackNumber;

           isDead = [weakSelf.targetMonster setBloodNodeNumber:attackNumber];
            if (isDead) {
                weakSelf.targetMonster = nil;
            }
        }
        
        [weakSelf runAction:attack2 completion:^{
            [weakSelf standAction];
        }];
    }];
    
}

- (void)removeDoubleKill
{
    [_doubleKill removeFromParent];
    _doubleKill = nil;
}

#pragma mark - 技能 -
//双倍伤害,持续%d秒
- (void)skill1Action
{
    if (_doubleKill) {
        return;
    }
    _doubleKill = [SKEmitterNode nodeWithFileNamed:@"doubleKill"];
    [self.parent addChild:_doubleKill];
    _doubleKill.targetNode = self.parent;
    _doubleKill.position = CGPointMake(self.position.x, self.position.y - 75);
    
    self.skill1 = YES;
   
}

- (void)skill2Action
{
    self.skill2 = YES;
    NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:kArcher_skill_2];
    [WDSkillManager endSkillActionWithTarget:self skillType:@"2" time:time];
}

- (void)skill3Action
{
    NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:kArcher_skill_3];
    self.skill3 = YES;
    self.moveSpeed = _speed + 200;
    [WDSkillManager endSkillActionWithTarget:self skillType:@"3" time:time];

}

- (void)skill4Action
{
    NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:kArcher_skill_3];
    self.skill4 = YES;
    [WDSkillManager endSkillActionWithTarget:self skillType:@"4" time:time];

}


- (void)dealloc
{
    NSLog(@"忍者销毁了");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _ninjaModel = nil;
}

@end
