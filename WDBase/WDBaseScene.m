//
//  WDBaseScene.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseScene.h"
#import "WDTouchEndLogic.h"
#import "WDBaseScene+CreateMonster.h"
#import "WDBaseScene+SkillLogic.h"
#import "WDBaseScene+ContactLogic.h"
@implementation WDBaseScene


#pragma mark - 通知方法 -
- (void)addObserveAction
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(diedAction:) name:kNotificationForDied object:nil];
}

- (void)diedAction:(NSNotification *)notification{
    NSString *name = notification.object;
    NSDictionary *dic = @{kKinght:@"releaseKnightNode",kArcher:@"releaseArcherNode",kIceWizard:@"releaseIceWizardNode"};
    NSString *selName = dic[name];
    SEL method = NSSelectorFromString(selName);
    if (method) {
        [self performSelector:method withObject:nil];
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
    
    //这里选取的背景图片都是长远远大于宽，所以只适配高度即可
    self.size = CGSizeMake(screenWidth, screenHeight);
   
    self.bgNode = (SKSpriteNode *)[self childNodeWithName:@"bgNode"];
    CGFloat yScale = self.size.height / self.bgNode.size.height;
    self.bgNode.yScale = yScale;
    self.bgNode.xScale = yScale;
//    
    
    WDTextureManager *manager = [WDTextureManager shareTextureManager];
    WDBaseNode *arrow  = manager.arrowNode;
    WDBaseNode *location = manager.locationNode;
    manager.mapBigY_Up = 350.f;
    manager.mapBigY_down = 100;
    [self addChild:arrow];
    [self addChild:location];
    
    //_selectNode = self.archerNode;
    //self.archerNode.arrowNode.hidden = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:self.selectNode.name];
}




#pragma mark - 物理检测 -
- (void)didBeginContact:(SKPhysicsContact *)contact{
    [self contactLogicAction:contact];
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

- (void)releaseKnightNode
{
    _kNightNode = nil;
}

- (void)releaseArcherNode
{
    _archerNode = nil;
}

- (void)releaseIceWizardNode
{
    _iceWizardNode = nil;
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
    
    [self.userArr removeAllObjects];
    [self.monsterArr removeAllObjects];
    
    [self.textureManager.arrowNode removeFromParent];
    [self.textureManager.locationNode removeFromParent];
   
    _selectNode    = nil;
    _kNightNode    = nil;
    _iceWizardNode = nil;
    _archerNode    = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotificationForDied object:nil];
}

- (void)dealloc
{
    NSLog(@"%@场景销毁了~",NSStringFromClass([self class]));
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
        
        __weak typeof(self)weakSelf = self;
        [_kNightNode setMockBlock:^{
            [weakSelf mockSkill];
        }];
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

/// 忍者
- (WDNinjaNode *)ninjaNode
{
    if (!_ninjaNode) {
        _ninjaNode = [WDNinjaNode initWithModel:[WDTextureManager shareTextureManager].ninjaModel];
        [self.userArr addObject:_ninjaNode];
    }
    
    return _ninjaNode;;
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
