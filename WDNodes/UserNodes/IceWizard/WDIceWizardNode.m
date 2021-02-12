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
     self.realSize = CGSizeMake(self.size.width - 150, self.size.height - 20);
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

- (void)beAttackActionWithTargetNode:(WDBaseNode *)targetNode
{
    [super beAttackActionWithTargetNode:targetNode];
}
/// 加血状态
- (void)addBuffActionWithNode:(WDBaseNode *)node
{
    //移动大于一切
    if (self.isMove) {
        return;
    }
    
    if (self.isDead) return;
    
    if (self.lastBlood <= 0) {
        return;
    }
    
    if (!self.isCure) {
        [self standAction];
        return;
    }
    
    [super addBuffActionWithNode:node];
     
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
    self.isDead = YES;
}

/// 加血动画
/// @param node 被治愈者
- (void)addDeadFireWithNode:(WDBaseNode *)node{
    
    self.targetUser = node;
    
    if (self.isMove) {
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
- (void)attackAction1WithNode:(WDBaseNode *)enemyNode
{
     [super attackAction1WithNode:enemyNode];
     
}

- (void)moveFinishAction
{
    [super moveFinishAction];
    
    if (self.isAttack) {
        [self attackAction1WithNode:self.targetMonster];
    }
    
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
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _iceModel = nil;
}

@end
