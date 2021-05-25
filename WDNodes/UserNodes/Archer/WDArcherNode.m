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
     self.realSize = CGSizeMake(self.size.width - 150, self.size.height - 60);
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

- (void)attackActionWithEnemyNode:(WDBaseNode *)enemyNode
{
    
    [super attackActionWithEnemyNode:enemyNode];
   
    [self removeAllActions];
    
    NSArray *a = _archerModel.attackArr1;
    NSArray *laArr = [a subarrayWithRange:NSMakeRange(0, 6)];
    NSArray *attackArr = [a subarrayWithRange:NSMakeRange(6, _archerModel.attackArr1.count - 6)];
    
    NSTimeInterval time = 0.1;
    if (self.skill1) {
        time = 0.03;
    }
    
    if (self.skill5) {
        WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:_archerModel.effect5Arr[0]];
        node.xScale = 3.0;
        node.yScale = 3.0;
        node.zPosition = 10000;
        node.position = CGPointMake(100, 0);
        [self addChild:node];
        SKAction *animation = [SKAction animateWithTextures:_archerModel.effect5Arr timePerFrame:0.1];
        animation.timingMode = SKActionTimingEaseIn;
        SKAction *removeAction = [SKAction removeFromParent];
        [node runAction:[SKAction sequence:@[animation,removeAction]] completion:^{
          
        }];
        
        self.skill5 = NO;
        self.attackNumber = self.trueAttackNumber * 3.0;
    }
    
    SKAction *att = [SKAction animateWithTextures:laArr timePerFrame:time];
    att.timingMode = SKActionTimingEaseIn;
    __weak typeof(self)weakSelf = self;
    [self runAction:att completion:^{
        
        if (weakSelf.state & SpriteState_move) {
            return ;
        }
  
        if (!weakSelf.targetMonster) {
            return;
        }
        
        if (weakSelf.targetMonster.state & SpriteState_dead) {
            [weakSelf standAction];
            return;
        }
       
        
        if (weakSelf.skill2) {
            [weakSelf createThreeArrow];
        }else{
            [weakSelf createArrow];
        }
        
        SKAction *att2 = [SKAction animateWithTextures:attackArr timePerFrame:0.05];
        [weakSelf runAction:att2 completion:^{
            if (weakSelf.state & SpriteState_movie) {
                weakSelf.state = SpriteState_movie | SpriteState_stand;
            }else{
                weakSelf.state = SpriteState_stand;
            }
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
    
    self.attackNumber = self.trueAttackNumber;

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
    self.attackNumber = self.trueAttackNumber;
}


- (void)observedNode
{
    [super observedNode];
    
    if (self.state & SpriteState_move || self.state & SpriteState_movie || self.state & SpriteState_init || self.state & SpriteState_attack || self.state & SpriteState_stagger) {
        return;
    }
    
    if (self.state & SpriteState_operation) {
        return;
    }
    
    if (self.targetMonster.state & SpriteState_dead) {
        self.targetMonster = nil;
        [self standAction];
        return;
    }
    

    if (self.targetMonster && !(self.targetMonster.state & SpriteState_movie)) {
        [self attackActionWithEnemyNode:self.targetMonster];
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
//加速射击技能,持续%d秒
- (void)skill1Action
{
    
    NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:kArcher_skill_1];
    self.skill1 = YES;
    [WDSkillManager endSkillActionWithTarget:self skillType:@"1" time:time];
    
    [self createSkillEffectWithPosition:CGPointMake(0, 270) skillArr:_archerModel.skill1Arr scale:2];

}

- (void)skill2Action
{
    self.skill2 = YES;
    NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:kArcher_skill_2];
    [WDSkillManager endSkillActionWithTarget:self skillType:@"2" time:time];
    
    [self createSkillEffectWithPosition:CGPointMake(0, 270) skillArr:_archerModel.skill2Arr scale:2];
}

- (void)skill3Action
{
    NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:kArcher_skill_3];
    self.skill3 = YES;
    self.moveSpeed = _speed + 200;
    [WDSkillManager endSkillActionWithTarget:self skillType:@"3" time:time];

    [self createSkillEffectWithPosition:CGPointMake(0, 0) skillArr:_archerModel.skill3Arr scale:1];
}

- (void)skill4Action
{
    NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:kArcher_skill_4];
    self.skill4 = YES;
    [WDSkillManager endSkillActionWithTarget:self skillType:@"4" time:time];

    [self createSkillEffectWithPosition:CGPointMake(0, 270) skillArr:_archerModel.skill4Arr scale:2];
}

- (void)skill5Action
{
    self.skill5 = YES;
}


- (void)dealloc
{
    NSLog(@"弓箭手销毁了");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _archerModel = nil;
}

@end
