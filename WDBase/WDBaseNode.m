//
//  WDBaseNode.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseNode.h"

@interface WDBaseNode ()

@property (nonatomic,strong)WDBaseNode *bloodNode;
@property (nonatomic,strong)WDBaseNode *bloodBgNode;

@end

@implementation WDBaseNode


+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    return [[WDBaseNode alloc] init];
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    
}


- (void)setBodyCanUse
{
    NSLog(@"1");
}


#pragma mark - 阴影 -
- (void)setShadowNodeWithPosition:(CGPoint)point
                            scale:(CGFloat)scale
{
    SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:@"shadow"]];
    _shadowNode = [WDBaseNode spriteNodeWithTexture:texture];
    _shadowNode.position = point;
    _shadowNode.xScale = scale;
    _shadowNode.yScale = scale;
    _shadowNode.zPosition = -1;
    [self addChild:_shadowNode];
}

#pragma mark - 金色选中箭头 -
- (void)setArrowNodeWithPosition:(CGPoint)point
                           scale:(CGFloat)scale
{
    SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:@"selectArrow"]];
    _arrowNode = [WDBaseNode spriteNodeWithTexture:texture];
    _arrowNode.position = point;
    _arrowNode.xScale = scale;
    _arrowNode.yScale = scale;
    _arrowNode.zPosition = 1;
    _arrowNode.hidden = YES;
    [self addChild:_arrowNode];
    
    SKAction *move1 = [SKAction moveTo:CGPointMake(point.x,point.y + 30) duration:0.5];
    SKAction *move2 = [SKAction moveTo:CGPointMake(point.x, point.y ) duration:0.5];
    SKAction *seq = [SKAction sequence:@[move1,move2]];
    SKAction *rep = [SKAction repeatActionForever:seq];
    [_arrowNode runAction:rep withKey:@"arrow"];
    
}

- (void)setSelectAction
{
    
    SKAction *a = [SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:0.7 duration:0.15];
    SKAction *b = [SKAction colorizeWithColorBlendFactor:0 duration:0.15];
    SKAction *seq = [SKAction sequence:@[a,b]];
    SKAction *rep = [SKAction repeatAction:seq count:1];
      
    [self runAction:rep];
}

- (void)setTragetMonster:(WDBaseNode *)enemNode
{
    _targetMonster = enemNode;
}

/// 减血
- (void)setBloodNodeWithAttackNumber:(int)attackNumber
{
    _lastBlood = _lastBlood - attackNumber;
    
    CGFloat percent = (float)_lastBlood / (float)_blood;
    if (_lastBlood <= 0) {
        percent = 0;
    }
    
    CGFloat width = self.realSize.width / self.xScale * percent;
    
    self.bloodNode.size = CGSizeMake(width, 40);
    self.bloodNode.position = CGPointMake(- (self.realSize.width / self.xScale  - width) / 2.0, 0);
}




#pragma mark - 行为 -
- (void)standAction
{
    self.isAttack = NO;
    self.isMove = NO;
    SKAction *stand = [SKAction animateWithTextures:self.model.standArr timePerFrame:0.1];
    SKAction *rep = [SKAction repeatActionForever:stand];
    [self runAction:rep withKey:@"stand"];
}

- (void)moveActionWithPoint:(CGPoint)point
               moveComplete:(void (^)(void))moveFinish
{
    _moveFinish = moveFinish;
    self.isMove = YES;
    
    if (![self.name isEqualToString:kIceWizard]) {
        self.isAttack = NO;
    }
    
    [self removeActionForKey:@"move"];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(moveFinishAction) object:nil];
    
    
    if (point.x > self.position.x) {
        self.xScale = fabs(self.xScale);
    }else{
        self.xScale = -fabs(self.xScale);
    }
    
    CGFloat distanceX = fabs(point.x - self.position.x);
    CGFloat distanceY = fabs(point.y - self.position.y);
    
    CGFloat distance = sqrt(distanceX * distanceX + distanceY * distanceY);
    
    SKAction *move = [SKAction moveTo:point duration:distance / self.moveSpeed];
    
    [self runAction:move withKey:@"move"];
    [self performSelector:@selector(moveFinishAction) withObject:nil afterDelay:distance / self.moveSpeed];
    
    SKAction *moveAnimation = [self actionForKey:@"moveAnimation"];
    if (!moveAnimation) {
        SKAction *texture = [SKAction animateWithTextures:self.model.walkArr timePerFrame:0.05];
        SKAction *rep = [SKAction repeatActionForever:texture];
        [self runAction:rep withKey:@"moveAnimation"];
    }
}

- (void)attackAction1WithNode:(WDBaseNode *)enemyNode
{
    [self hiddenLocationAndArrow];
    self.isAttack = YES;
    self.isMove = NO;
    [self removeAllActions];
   
}

- (void)hiddenLocationAndArrow{
    WDTextureManager *manager = [WDTextureManager shareTextureManager];
    WDBaseNode *arrow  = manager.arrowNode;
    WDBaseNode *location = manager.locationNode;
         
    [arrow removeAllActions];
    [location removeAllActions];
         
    arrow.alpha = 0;
    location.alpha = 0;
}

- (void)moveFinishAction{
    
    if (_moveFinish) {
        _moveFinish();
    }
    self.isMove = NO;
   
    [self hiddenLocationAndArrow];

    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForMoveFinish object:self.name];
    
    if (self.isAttack) {
        return;
    }
    
    [self standAction];
    [self removeActionForKey:@"moveAnimation"];
    
  
}


#pragma mark - getter -
- (WDBaseNode *)bloodNode
{
    if (!_bloodNode) {
        UIColor *color = UICOLOR_RGB(124, 42, 42, 1);
        _bloodBgNode = [WDBaseNode spriteNodeWithColor:color size:CGSizeMake(self.realSize.width / self.xScale, 40)];
        _bloodBgNode.zPosition = -1;
        _bloodBgNode.position = CGPointMake(0,self.realSize.height / self.yScale - self.realSize.height - 40);
        [self addChild:_bloodBgNode];
        
        UIColor *color2 = UICOLOR_RGB(127, 255, 0, 1);
        _bloodNode = [WDBaseNode spriteNodeWithColor:color2 size:CGSizeMake(self.realSize.width / self.xScale, 40)];
        _bloodNode.zPosition = 1;
        _bloodNode.position = CGPointMake(0, 0);
        [_bloodBgNode addChild:_bloodNode];
    }
    
    return _bloodNode;
}

- (WDBaseNode *)addBloodNode
{
    if (!_addBloodNode) {
        _addBloodNode = [WDBaseNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"addBlood"]]];
        _addBloodNode.hidden = YES;
        _addBloodNode.xScale = 2.0;
        _addBloodNode.yScale = 2.0;
        _addBloodNode.position = CGPointMake(0, self.size.height / 2.0 + 70);
        SKAction *alp = [SKAction fadeAlphaTo:0.3 duration:0.3];
        SKAction *alp2 = [SKAction fadeAlphaTo:0.7 duration:0.3];
        SKAction *rep = [SKAction repeatActionForever:[SKAction sequence:@[alp,alp2]]];
        [_addBloodNode runAction:rep withKey:@"alpha"];
        [self addChild:_addBloodNode];
    }
    
    return _addBloodNode;
}

@end



@implementation WDUserNode

- (void)setBodyCanUse
{
    self.physicsBody.categoryBitMask    = PLAYER_CATEGORY;
    self.physicsBody.collisionBitMask   = PLAYER_COLLISION;
    self.physicsBody.contactTestBitMask = PLAYER_CONTACT;
}

@end



@implementation WDMonsterNode

- (void)setAttackArrow
{
    if ([self childNodeWithName:@"attackArrow"]) {
        
        return;
    }
    

    SKAction *a = [SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:0.7 duration:0.15];
    SKAction *b = [SKAction colorizeWithColorBlendFactor:0 duration:0.15];
    SKAction *seq = [SKAction sequence:@[a,b]];
    SKAction *rep = [SKAction repeatAction:seq count:2];
    
    
   
    [self runAction:rep];
    
  
  
  //  [self runAction:actioo];
    
//    SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:@"attackArrow"]];
//    CGPoint point = CGPointMake(0, 0);
//    CGFloat scale = 2.0;
//    WDBaseNode *attackArrow = [WDBaseNode spriteNodeWithTexture:texture];
//    attackArrow.position = point;
//    attackArrow.name = @"attackArrow";
//    attackArrow.xScale = scale;
//    attackArrow.yScale = scale;
//    attackArrow.zPosition = 1;
//    [self addChild:attackArrow];
//
//    SKAction *move1 = [SKAction moveTo:CGPointMake(point.x,point.y + 30) duration:0.3];
//    SKAction *move2 = [SKAction moveTo:CGPointMake(point.x, point.y ) duration:0.3];
//    SKAction *seq = [SKAction sequence:@[move1,move2]];
//    SKAction *rep = [SKAction repeatAction:seq count:10];
//    SKAction *seqq = [SKAction sequence:@[rep,[SKAction removeFromParent]]];
//    [attackArrow runAction:seqq withKey:@"attackArrow"];
}

- (void)attackAction1WithNode:(WDBaseNode *)enemyNode
{
    CGPoint point = enemyNode.position;
    if (point.x > self.position.x) {
        self.xScale = fabs(self.xScale);
    }else{
        self.xScale = -fabs(self.xScale);
    }
    SKAction *texture = [SKAction animateWithTextures:self.model.attackArr1 timePerFrame:0.1];
    SKAction *rep = [SKAction repeatActionForever:texture];
    rep.timingMode = SKActionTimingEaseIn;
    [self runAction:rep withKey:@"attack1"];
}

- (void)setBodyCanUse
{
    self.physicsBody.categoryBitMask    = MONSTER_CATEGORY;
    self.physicsBody.collisionBitMask   = MONSTER_COLLISION;
    self.physicsBody.contactTestBitMask = MONSTER_CONTACT;
}

@end
