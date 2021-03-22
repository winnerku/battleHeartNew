//
//  WDKinghtNode.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/10.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDKinghtNode.h"
#import "WDKinghtModel.h"
#import "WDBaseScene.h"
@implementation WDKinghtNode
{
    WDKinghtModel *_knightModel;
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

     _knightModel = (WDKinghtModel *)model;
     self.model = model;
     self.realSize = CGSizeMake(self.size.width - 150, self.size.height - 60);
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
    
     [self createRealSizeNode];
}

- (void)observedNode
{
    [super observedNode];
    
    if (self.state & SpriteState_movie || self.state & SpriteState_init || self.state & SpriteState_stagger || self.state & SpriteState_attack || self.state & SpriteState_dead || self.state & SpriteState_move) {
        return;
    }
    
    if (!self.targetMonster) {
        WDBaseNode *target = [WDCalculateTool searchMonsterNearNode:self];
        if (target) {
            self.targetMonster = target;
        }
        [self standAction];
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
            if ([weakSelf.targetMonster.name isEqualToString:kBoss1]) {
                //不吃仇恨
            }else{
                [weakSelf.balloonNode setBalloonWithLine:7 hiddenTime:2];
                //吸引仇恨
                weakSelf.targetMonster.targetMonster = weakSelf;
                weakSelf.targetMonster.randomDistanceX = 0;
                weakSelf.targetMonster.randomDistanceY = 0;
                [weakSelf.targetMonster.balloonNode setBalloonWithLine:5 hiddenTime:2];
            }
            
        }
        
        [weakSelf runAction:[SKAction animateWithTextures:last timePerFrame:0.1] completion:^{
            if (weakSelf.state & SpriteState_movie) {
                weakSelf.state = SpriteState_movie | SpriteState_stand;
            }else{
                weakSelf.state = SpriteState_stand;
            }
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

- (void)moveActionWithPoint:(CGPoint)point
               moveComplete:(void (^)(void))moveFinish
{
    [super moveActionWithPoint:point moveComplete:moveFinish];
    self.targetMonster = nil;
}


#pragma mark - 技能 -
- (void)skill1Action
{
    if (self.mockBlock) {
        self.mockBlock();
    }
}

- (void)skill2Action
{
    self.iceWizardReduceAttack = YES;
    self.skill2 = YES;
    NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:kKinght_skill_2];
    [WDSkillManager endSkillActionWithTarget:self skillType:@"2" time:time];
    
    CGPoint point = CGPointMake(0, 0);
    CGFloat scale = 2;
    NSArray *skillArr = _knightModel.effect2Arr;
    WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:skillArr[0]];
    node.alpha = 0.8;
    node.name = @"define";
    [self addChild:node];
    node.position = point;
    node.xScale = scale;
    node.yScale = scale;
    SKAction *an = [SKAction animateWithTextures:skillArr timePerFrame:0.1];
    an.timingMode = SKActionTimingEaseIn;
    SKAction *rep = [SKAction repeatActionForever:an];
    //__weak typeof(self)weakSelf = self;
    [node runAction:rep completion:^{
    }];
}

- (void)skill3Action
{
    self.skill2 = YES;
    
    WDBaseScene *scene = (WDBaseScene *)self.parent;
    WDBaseNode *bloodMiniNode = nil;
    int blood = 10000;
    for (WDBaseNode *node in scene.userArr) {
        if (node.lastBlood < blood) {
            bloodMiniNode = node;
            blood = node.lastBlood;
        }
    }
    
    bloodMiniNode.iceWizardReduceAttack = YES;
    
    CGPoint point = CGPointMake(0, 120);
    CGFloat scale = 1;
    NSArray *skillArr = _knightModel.effect3Arr;
    WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:skillArr[0]];
    node.alpha = 0.8;
    node.name = @"define";
    [bloodMiniNode addChild:node];
    node.position = point;
    node.xScale = scale;
    node.yScale = scale;
    SKAction *an = [SKAction animateWithTextures:skillArr timePerFrame:0.1];
    an.timingMode = SKActionTimingEaseIn;
    SKAction *rep = [SKAction repeatActionForever:an];
    //__weak typeof(self)weakSelf = self;
    [node runAction:rep completion:^{
    }];
    
    NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:kKinght_skill_3];
    [WDSkillManager endSkillActionWithTarget:bloodMiniNode skillType:@"6" time:time];
}

- (void)skill4Action
{
    self.skill4 = YES;
    self.kinghtReboundAttack = YES;
    NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:kKinght_skill_4];
    [WDSkillManager endSkillActionWithTarget:self skillType:@"4" time:time];
    
    CGPoint point = CGPointMake(0, 0);
    CGFloat scale = 1;
    NSArray *skillArr = _knightModel.effect4Arr;
    WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:skillArr[0]];
    node.alpha = 0.5;
    node.name = @"rebound";
    [self addChild:node];
    node.position = point;
    node.xScale = scale;
    node.yScale = scale;
    SKAction *an = [SKAction animateWithTextures:skillArr timePerFrame:0.1];
    an.timingMode = SKActionTimingEaseIn;
    SKAction *rep = [SKAction repeatActionForever:an];
    //__weak typeof(self)weakSelf = self;
    [node runAction:rep completion:^{
    }];
}

- (void)skill5Action
{
    CGPoint point = CGPointMake(0, 250);
    CGFloat scale = 1.5;
    NSArray *skillArr = _knightModel.effect5Arr;
    WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:skillArr[0]];
    node.alpha = 1;
    node.name = @"rebound";
    [self addChild:node];
    node.position = point;
    node.xScale = scale;
    node.yScale = scale;
    NSArray *animationArr1 = [skillArr subarrayWithRange:NSMakeRange(0, 13)];
    NSArray *subArr = [skillArr subarrayWithRange:NSMakeRange(13, skillArr.count - 13)];
    SKAction *an = [SKAction animateWithTextures:animationArr1 timePerFrame:0.1];
    an.timingMode = SKActionTimingEaseIn;
    __weak typeof(self)weakSelf = self;
    [node runAction:an completion:^{
        [node runAction:[SKAction sequence:@[[SKAction animateWithTextures:subArr timePerFrame:0.1],[SKAction removeFromParent]]]];
        [weakSelf setBloodNodeNumber:-10000];
    }];
}


- (void)dealloc
{
    NSLog(@"骑士销毁了");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _knightModel = nil;
}

@end
