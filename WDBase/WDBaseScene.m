//
//  WDBaseScene.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseScene.h"
#import "WDBaseScene+CreateMonster.h"
#import "WDTouchEndLogic.h"

@implementation WDBaseScene


#pragma mark - 通知方法 -
- (void)addObserveAction
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(diedAction) name:kNotificationForDied object:nil];
}

- (void)diedAction{
    
    for (WDBaseNode *node in self.userArr) {
        if (node.isDead) {
            [node releaseAction];
            [self.userArr removeObject:node];
            [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
            break;
        }
    }
    
    for (WDBaseNode *node in self.monsterArr) {
        if (node.isDead) {
            [node releaseAction];
            [self.monsterArr removeObject:node];
            [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
            break;
        }
    }
}

#pragma mark - 进入游戏界面 -
- (void)didMoveToView:(SKView *)view
{
    [self addObserveAction];
    
    self.physicsWorld.contactDelegate = self;
        
    //屏幕适配
    CGFloat screenWidth = kScreenWidth * 2.0;
    CGFloat screenHeight = kScreenHeight * 2.0;
    
    _bgNode = (SKSpriteNode *)[self childNodeWithName:@"bgNode"];
    NSString *mapName = [NSString stringWithFormat:@"%@.jpg",NSStringFromClass([self class])];
    _bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:mapName]];
    _bgNode.zPosition = -10;
    //这里选取的背景图片都是长远远大于宽，所以只适配高度即可
    self.size = CGSizeMake(screenWidth, screenHeight);
    CGFloat scale = screenHeight / _bgNode.size.height;
    _bgNode.size = CGSizeMake(_bgNode.size.width * scale, screenHeight);
    
    WDTextureManager *manager = [WDTextureManager shareTextureManager];
    WDBaseNode *arrow  = manager.arrowNode;
    WDBaseNode *location = manager.locationNode;
    [self addChild:arrow];
    [self addChild:location];
    
    _selectNode = self.archerNode;
    self.archerNode.arrowNode.hidden = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:self.selectNode.name];
}




#pragma mark - 物理检测 -
- (void)didBeginContact:(SKPhysicsContact *)contact{
    
    WDBaseNode *nodeA = (WDBaseNode *)contact.bodyA.node;
    WDBaseNode *nodeB = (WDBaseNode *)contact.bodyB.node;
       
    ///弓箭触碰
    if ([nodeA.name isEqualToString:@"user_arrow"]) {
        if ([nodeB isKindOfClass:[WDMonsterNode class]]) {
            [nodeB selectSpriteAction];
            [nodeB setBloodNodeNumber:nodeA.attackNumber];
        }
    }else if([nodeB.name isEqualToString:@"user_arrow"]){
        if ([nodeA isKindOfClass:[WDMonsterNode class]]) {
            [nodeA selectSpriteAction];
            [nodeA setBloodNodeNumber:nodeA.attackNumber];
        }
    }
       
    
    
    if ([nodeA isKindOfClass:[WDMonsterNode class]] && [nodeB.name isEqualToString:@"user_arrow"]) {
        //[nodeB removeFromParent];
        [nodeA selectSpriteAction];
        [nodeA setBloodNodeNumber:nodeB.attackNumber];
    }
       
    NSLog(@"A: %@  b: %@",nodeA.name,nodeB.name);
    
}
- (void)didEndContact:(SKPhysicsContact *)contact{
    
}



//移动标识
- (void)arrowAction:(CGPoint)pos{
    WDTextureManager *manager = [WDTextureManager shareTextureManager];
    [manager arrowMoveActionWithPos:pos];
    
    _selectNode.targetMonster = nil;
    _selectNode.isAttack = NO;

}







- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


#pragma mark - public -
/// 创建怪物
/// @param name 怪物名称
- (void)createMonsterWithName:(NSString *)name
                     position:(CGPoint)point
{
    
    if ([name isEqualToString:kRedBat]) {
        //红蝙蝠
        [self redBatWithPosition:point];
    }
    

}

- (void)skill1Action{
    [_selectNode skill1Action];
}
- (void)skill2Action{
    [_selectNode skill2Action];
}
- (void)skill3Action{
    [_selectNode skill3Action];
}
- (void)skill4Action{
    [_selectNode skill4Action];
}
- (void)skill5Action{
    [_selectNode skill5Action];
}



- (void)releaseAction
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    for (WDBaseNode *node in self.userArr) {
        [node releaseAction];
    }
    
    for (WDBaseNode *node in self.monsterArr) {
        [node releaseAction];
    }
    
    [self.textureManager.arrowNode removeFromParent];
    [self.textureManager.locationNode removeFromParent];
  
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotificationForDied object:nil];
}


#pragma mark - getter -
/// 操作线
- (WDBaseNode *)selectLine
{
    if (!_selectLine) {
        _selectLine = [WDBaseNode spriteNodeWithColor:UICOLOR_RGB(255, 227, 132, 1) size:CGSizeMake(50, 50)];
        _selectLine.anchorPoint = CGPointMake(0, 0);
        _selectLine.name = @"selectLine";
        [self addChild:_selectLine];
    }
    
    return _selectLine;
}

/// 骑士
- (WDKinghtNode *)kNightNode
{
    if (!_kNightNode) {
        _kNightNode = [WDKinghtNode initWithModel:[WDTextureManager shareTextureManager].kinghtModel];
        [self.userArr addObject:_kNightNode];
    }
    
    return _kNightNode;
}

/// 冰法师
- (WDIceWizardNode *)iceWizardNode
{
    if (!_iceWizardNode) {
        _iceWizardNode = [WDIceWizardNode initWithModel:[WDTextureManager shareTextureManager].iceWizardModel];
        [self.userArr addObject:_iceWizardNode];
    }
    
    return _iceWizardNode;
}


/// 弓箭手
- (WDArcherNode *)archerNode
{
    if (!_archerNode) {
        _archerNode = [WDArcherNode initWithModel:[WDTextureManager shareTextureManager].archerModel];
        [self.userArr addObject:_archerNode];
    }
    
    return _archerNode;
}


- (NSMutableArray *)monsterArr
{
    if (!_monsterArr) {
        _monsterArr = [NSMutableArray array];
    }
    return _monsterArr;
}

- (NSMutableArray *)userArr
{
    if (!_userArr) {
        _userArr = [NSMutableArray array];
    }
    return _userArr;
}

- (WDTextureManager *)textureManager
{
    if (!_textureManager) {
        _textureManager = [WDTextureManager shareTextureManager];
    }
    
    return _textureManager;
}

@end
