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
    SKAction         *_cureAction;
    CGFloat           _addNumber;
    BOOL              _isDead;
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
    
    
    _addNumber = self.cureNumber;
//    SKSpriteNode *coloc = [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:self.size];
//    [self addChild:coloc];
    
    [self standAction];
}

- (void)observedNode
{
    [super observedNode];
    
    if (self.state & SpriteState_move || self.state & SpriteState_movie || self.state & SpriteState_init || self.state & SpriteState_attack || self.state & SpriteState_stagger) {
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
    
    if (self.targetMonster) {
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
    if (self.state & SpriteState_move) {
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
     
    SKAction *texture = [SKAction animateWithTextures:self.model.attackArr1 timePerFrame:0.1];
    SKAction *time = [SKAction waitForDuration:0.15];
    SKAction *seq = [SKAction sequence:@[texture,time]];
    seq.timingMode = SKActionTimingEaseIn;
    _cureAction = seq;
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
        
    [self performSelector:@selector(iceFireAction:) withObject:enemyNode afterDelay:5 * 0.1];
    
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
    self.skill1 = YES;
    self.cureNumber = _addNumber + _addNumber;
    [self performSelector:@selector(cd1) withObject:nil afterDelay:10];
}


- (void)cd1{
    self.cureNumber = _addNumber;
    self.skill1 = NO;
}

- (void)skill2Action
{
    NSArray *nodes = self.parent.children;
    for (WDBaseNode *node in nodes) {
        if ([node isKindOfClass:[WDUserNode class]]) {
            [node skillCureAction];
        }
    }
    
}


- (void)dealloc
{
    NSLog(@"冰女销毁了");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _iceModel = nil;
}

@end
