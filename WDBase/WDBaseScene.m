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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cameBackToLife:) name:kNotificationForCameBackToLife object:nil];
}

- (void)cameBackToLife:(NSNotification *)notification
{
    
    WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:self.textureManager.iceWizardModel.effect5Arr[0]];
    node.xScale = 2.0;
    node.yScale = 2.0;
    [self addChild:node];
    node.zPosition = 10000;
    
    SKAction *animation = [SKAction animateWithTextures:self.textureManager.iceWizardModel.effect5Arr timePerFrame:0.3];
    SKAction *remo = [SKAction removeFromParent];
    
    __weak typeof(self)weakSelf = self;
    [node runAction:[SKAction sequence:@[animation,remo]] completion:^{
        [weakSelf cameBack];
    }];
    
  
}

- (void)cameBack{
    if (!_archerNode || _archerNode.state & SpriteState_dead) {
        _archerNode = nil;
        [self archerNode];
        if (!_archerNode.parent) {
            [self addChild:self.archerNode];
            self.archerNode.position = CGPointMake(0, 0);
        }
    }else if(!_ninjaNode || _ninjaNode.state & SpriteState_dead){
        _ninjaNode = nil;
        [self ninjaNode];
        if (!_ninjaNode.parent) {
            [self addChild:self.ninjaNode];
            self.ninjaNode.position = CGPointMake(0, 0);
            self.ninjaNode.state = SpriteState_stand;
        }
    }else if(!_kNightNode || _kNightNode.state & SpriteState_dead){
        _kNightNode = nil;
        [self kNightNode];
        if (!_kNightNode.parent) {
            [self addChild:self.kNightNode];
            self.kNightNode.position = CGPointMake(0, 0);
        }
    }
}

- (void)diedAction:(NSNotification *)notification{
    NSString *name = notification.object;
    
    if (_diedBlock) {
        _diedBlock(name);
    }
    
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
    
    manager.mapBigX = 120;
    manager.mapBigY = 120;
    
    [self addChild:arrow];
    [self addChild:location];
    
    //_selectNode = self.archerNode;
    //self.archerNode.arrowNode.hidden = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:self.selectNode.name];

}

- (void)selectUserWithName:(NSString *)name
{
    _selectNode.arrowNode.hidden = YES;
    
    if ([name isEqualToString:kKinght]) {
        _selectNode = self.kNightNode;
    }else if([name isEqualToString:kIceWizard]){
        _selectNode = self.iceWizardNode;
    }else if([name isEqualToString:kArcher]){
        _selectNode = self.archerNode;
    }else if([name isEqualToString:kNinja]){
        _selectNode = self.ninjaNode;
    }
    
    [_selectNode selectSpriteAction];
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:_selectNode.name];
}

- (void)createSnowEmitter
{
    SKEmitterNode *snow = [SKEmitterNode nodeWithFileNamed:@"snow"];
    snow.zPosition = 100000;
    [self addChild:snow];
    
    snow.position = CGPointMake(0, kScreenHeight);
    snow.particlePositionRange = CGVectorMake(kScreenWidth * 2.0, 0);
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
}



/// 返回主城
- (void)backToRealPubScene{
    if (self.changeSceneWithNameBlock) {
        self.changeSceneWithNameBlock(@"RealPubScene");
    }
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
    }else if([name isEqualToString:kBoneSolider]){
        //骷髅
        [self boneSoliderWithPosition:point];
    }else if([name isEqualToString:kBoneKnight]){
        //骷髅骑士(boss2)
        [self boneKnightWithPosition:point];
    }else if([name isEqualToString:kZombie]){
        //僵尸男(boss3)
        [self zombieWithPosition:point];
    }else if([name isEqualToString:kOX]){
        //牛(boss4)
        [self oxWithPosition:point];
    }else if([name isEqualToString:kGhost]){
        //鬼魂(boss5)
        [self ghostWithPosition:point];
    }else if([name isEqualToString:kDog]){
        //狗(boss6)
        [self dogWithPosition:point];
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
    _ninjaNode     = nil;
    
    [self.textureManager releaseAllModel];
    
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
        _selectLine.zPosition = 10;
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

- (WDBaseNode *)clickNode{
    if (!_clickNode) {
        _clickNode = [WDBaseNode spriteNodeWithTexture:self.textureManager.clickArr[0]];
        _clickNode.hidden = YES;
        [self addChild:_clickNode];
        _clickNode.zPosition = 10000;
        SKAction *an = [SKAction animateWithTextures:self.textureManager.clickArr timePerFrame:0.5];
        SKAction *re = [SKAction repeatActionForever:an];
        [_clickNode runAction:re];
    }
    
    return _clickNode;
}

@end
