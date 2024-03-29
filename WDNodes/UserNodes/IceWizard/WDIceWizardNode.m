//
//  WDIceWizardNode.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/11.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDIceWizardNode.h"
#import "WDIceWizardModel.h"
@implementation WDIceWizardNode
{
    WDIceWizardModel *_iceModel;

    BOOL _isCameBackToLife;
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDIceWizardNode *node = [WDIceWizardNode spriteNodeWithTexture:model.standArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{

    [super setChildNodeWithModel:model];
    
    self.xScale = 0.5;
    self.yScale = 0.5;

     _iceModel = (WDIceWizardModel *)model;
    [_iceModel changeArr];
     self.model = model;
     self.realSize = CGSizeMake(self.size.width - 150, self.size.height - 60);
     SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:self.realSize center:CGPointMake(0, 0)];
     self.physicsBody = body;
     self.physicsBody.affectedByGravity = NO;
     self.physicsBody.allowsRotation = NO;
     
     [self setBodyCanUse];
     
     [WDNumberManager initNodeValueWithName:kIceWizard node:self];
      
     
    
     [self setShadowNodeWithPosition:CGPointMake(0, -self.size.height / 2.0 - 30) scale:0.3];
     [self setArrowNodeWithPosition:CGPointMake(0, self.size.height / 2.0 + 110) scale:1.5];
     [self setBloodNodeNumber:0];
    
    
//    SKSpriteNode *coloc = [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:self.size];
//    [self addChild:coloc];
    
    [self standAction];
}

- (void)observedNode
{
    [super observedNode];
    
    if (self.state & SpriteState_move || self.state & SpriteState_movie || self.state & SpriteState_init || self.state & SpriteState_attack || self.state & SpriteState_stagger || self.state & SpriteState_dead) {
        return;
    }
    
    /// 治愈状态不能攻击
    if (self.isCure) {
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

- (void)beAttackActionWithTargetNode:(WDBaseNode *)targetNode
{
    [super beAttackActionWithTargetNode:targetNode];
}
/// 加血状态
- (void)addBuffActionWithNode:(WDBaseNode *)node
{
    //移动大于一切
    if (self.state & SpriteState_move || self.state & SpriteState_movie) {
        return;
    }
    
    if (self.state & SpriteState_dead) return;
  
         
    self.targetUser = node;
    
    if (![node.name isEqualToString:self.name]) {
        
        CGFloat distance = node.position.x - self.position.x;
        if (distance < 0) {
            self.xScale = -fabs(self.xScale);
            self.direction = @"left";
            self.isRight = NO;
         
            
        }else{
            self.xScale = +fabs(self.xScale);
            self.direction = @"right";
            self.isRight = YES;
         
        }
    }
    
    
    [self performSelector:@selector(addDeadFireWithNode:) withObject:node afterDelay:self.model.attackArr1.count * 0.1];
    
    
    [self removeAllActions];
    self.colorBlendFactor = 0;
    self.reduceBloodNow   = NO;
    
    SKAction *texture = [SKAction animateWithTextures:self.model.attackArr1 timePerFrame:0.1];
    SKAction *time = [SKAction waitForDuration:0.15];
    SKAction *seq = [SKAction sequence:@[texture,time]];
    seq.timingMode = SKActionTimingEaseIn;
    __weak typeof(self)weakSelf = self;
    [self runAction:seq completion:^{
        [weakSelf addBuffActionWithNode:node];
    }];
}

- (void)releaseAction
{
    [super releaseAction];
    self.state = SpriteState_dead;
}

/// 加血动画
/// @param node 被治愈者
- (void)addDeadFireWithNode:(WDBaseNode *)node{
    
    self.targetUser = node;
    
    if (self.state & SpriteState_move) {
        return;
    }
    
    SKEmitterNode *d = (SKEmitterNode *)[node.parent childNodeWithName:@"cureFire"];
    if (d) {
        [d removeFromParent];
    }
    
    SKEmitterNode *deadFire = [SKEmitterNode nodeWithFileNamed:@"cureFire"];
    deadFire.name = @"cureFire";
    deadFire.position = node.position;
    deadFire.zPosition = 100000;
    [node.parent addChild:deadFire];
    [node beCureActionWithCureNode:self];
}


/// 攻击动画
/// @param enemyNode 被攻击者
- (void)attackActionWithEnemyNode:(WDBaseNode *)enemyNode
{
    [super attackActionWithEnemyNode:enemyNode];
//        
    [self performSelector:@selector(iceFireAction:) withObject:enemyNode afterDelay:5 * 0.1];
//    
    SKAction *attackAnimation = [SKAction animateWithTextures:_iceModel.attackArr1 timePerFrame:0.1];
    __weak typeof(self)weakSelf = self;
    [self runAction:attackAnimation completion:^{
    
        weakSelf.state = SpriteState_stand;
    }];
    
}

- (void)iceFireAction:(WDBaseNode *)enemyNode
{
    if (self.state & SpriteState_move || self.state & SpriteState_dead) {
        return;
    }
        
    CGFloat x = 0;
    if (self.isRight) {
        x = 60;
    }else{
        x = -60;
    }
    
    SKEmitterNode *fireNode = [SKEmitterNode nodeWithFileNamed:@"IceFire"];
    fireNode.position = CGPointMake(self.position.x + x, self.position.y + 15);
    fireNode.zPosition = 10000;
    fireNode.name     = @"fffff";
    [self.parent addChild:fireNode];
    
    WDBaseNode *targetNode = [WDBaseNode new];
    targetNode.zPosition = 100000;
    targetNode.position = CGPointMake(0, 0);
    targetNode.size = CGSizeMake(500, 500);
    targetNode.name = @"target";
    [self.parent addChild:targetNode];
    
    fireNode.targetNode = targetNode;
   
    NSTimeInterval time = fabs(self.position.x - self.targetMonster.position.x) / 800;
    
    SKAction *moveAction = [SKAction moveTo:self.targetMonster.position duration:time];
    SKAction *seq2 = [SKAction sequence:@[moveAction,[SKAction removeFromParent]]];
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(10, 10) center:CGPointMake(0, 0)];
    fireNode.physicsBody = body;
    fireNode.physicsBody.affectedByGravity = NO;
    fireNode.physicsBody.allowsRotation = NO;
    fireNode.name = @"iceFire";
    //fireNode.attackNumber = weakSelf.attackNumber;
    body.categoryBitMask = ARROW_CATEGORY;
    body.collisionBitMask = 0;
    
    [fireNode runAction:seq2 completion:^{
        [targetNode removeFromParent];
    }];
}

- (void)moveFinishAction
{
    [super moveFinishAction];
    
    if (self.isCure) {
        [self addBuffActionWithNode:self.targetUser];
    }
}

- (void)skill1Action
{
    NSArray *nodes = self.parent.children;
    for (WDBaseNode *node in nodes) {
        if ([node isKindOfClass:[WDUserNode class]]) {
            [node setBloodNodeNumber:-self.cureNumber];
            [node createSkillEffectWithPosition:CGPointMake(0, 0) skillArr:[WDTextureManager shareTextureManager].archerModel.skill3Arr scale:1];
        }
    }
}

- (void)skill2Action
{
    self.skill2 = YES;
    self.cureNumber = self.trueCureNumber + self.trueCureNumber;
    NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:kIceWizard_skill_2];
    [WDSkillManager endSkillActionWithTarget:self skillType:@"2" time:time];
}

- (void)skill3Action
{
    self.skill3 = YES;
    self.iceWizardReduceAttack = YES;
    NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:kIceWizard_skill_3];
    [WDSkillManager endSkillActionWithTarget:self skillType:@"3" time:time];
    
    
    CGPoint point = CGPointMake(0, 0);
    CGFloat scale = 4;
    NSArray *skillArr = _iceModel.effect1Arr;
    WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:skillArr[0]];
    node.alpha = 1;
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

- (void)skill4Action
{
    self.skill4 = YES;
    self.iceWizardNotDead = YES;
    NSInteger time = [[NSUserDefaults standardUserDefaults]integerForKey:kIceWizard_skill_4];
    [WDSkillManager endSkillActionWithTarget:self skillType:@"4" time:time];
    
    CGPoint point = CGPointMake(0, 0);
    CGFloat scale = 3;
    NSArray *skillArr = _iceModel.effect4Arr;
    WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:skillArr[0]];
    node.alpha = 1;
    node.name = @"notDead";
    node.zPosition = -1;
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
    if (_isCameBackToLife) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForCameBackToLife object:nil];
}

- (void)dealloc
{
    NSLog(@"冰女销毁了");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _iceModel = nil;
}

@end
