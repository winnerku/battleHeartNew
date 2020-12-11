//
//  WDBaseScene.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseScene.h"

@implementation WDBaseScene


- (void)didMoveToView:(SKView *)view
{
    self.physicsWorld.contactDelegate = self;
    
    _testAttackLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(testAttackAction:)];
    [_testAttackLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

    
    //屏幕适配
    CGFloat screenWidth = kScreenWidth * 2.0;
    CGFloat screenHeight = kScreenHeight * 2.0;
    
    _bgNode = (SKSpriteNode *)[self childNodeWithName:@"bgNode"];
    NSString *mapName = [NSString stringWithFormat:@"%@.jpg",NSStringFromClass([self class])];
    _bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:mapName]];
    
    //这里选取的背景图片都是长远远大于宽，所以只适配高度即可
    self.size = CGSizeMake(screenWidth, screenHeight);
    CGFloat scale = screenHeight / _bgNode.size.height;
    _bgNode.size = CGSizeMake(_bgNode.size.width * scale, screenHeight);
    
    WDTextureManager *manager = [WDTextureManager shareTextureManager];
    WDBaseNode *arrow  = manager.arrowNode;
    WDBaseNode *location = manager.locationNode;
    [self addChild:arrow];
    [self addChild:location];
}




#pragma mark - 物理检测 -
- (void)didBeginContact:(SKPhysicsContact *)contact{}
- (void)didEndContact:(SKPhysicsContact *)contact{}



- (void)testAttackAction:(CADisplayLink *)link
{
    NSLog(@"子类实现");
}

//移动标识
- (void)arrowAction:(CGPoint)pos{
    WDTextureManager *manager = [WDTextureManager shareTextureManager];
    WDBaseNode *arrow  = manager.arrowNode;
    WDBaseNode *location = manager.locationNode;
       
    [arrow removeAllActions];
    [location removeAllActions];

    CGFloat y = pos.y;
       
    arrow.alpha = 1;
    location.alpha = 1;
    arrow.position = CGPointMake(pos.x, y);
    location.position = CGPointMake(pos.x, y - 80);
       
    SKAction *move1 = [SKAction moveTo:CGPointMake(pos.x,y + 40) duration:0.3];
    SKAction *move2 = [SKAction moveTo:CGPointMake(pos.x, y ) duration:0.3];
    SKAction *seq = [SKAction sequence:@[move1,move2]];
    SKAction *rep = [SKAction repeatActionForever:seq];
    [arrow runAction:rep];
       
    SKAction *alpha1 = [SKAction fadeAlphaTo:0.6 duration:0.3];
    SKAction *alpha2 = [SKAction fadeAlphaTo:1 duration:0.3];
    SKAction *seq1 = [SKAction sequence:@[alpha1,alpha2]];
    SKAction *rep2 = [SKAction repeatActionForever:seq1];
    [location runAction:rep2];
}

- (void)hiddenArrowAction
{
    WDTextureManager *manager = [WDTextureManager shareTextureManager];
    WDBaseNode *arrow  = manager.arrowNode;
    WDBaseNode *location = manager.locationNode;
    
    [arrow removeAllActions];
    [location removeAllActions];
    
    arrow.alpha = 0;
    location.alpha = 0;
}


/// 治愈技能点击后，消除治愈图标
- (void)cureAction{
    for (WDBaseNode *user in self.userArr) {
        user.addBloodNode.hidden = YES;
    }
}

#pragma mark - 触碰 -
- (void)touchDownAtPoint:(CGPoint)pos {
    
    NSArray *nodes = [self nodesAtPoint:pos];
    WDBaseNode *node = (WDBaseNode *)[self nodeAtPoint:pos];
    
    ///避免重复选择一个
    if ([node.name isEqualToString:_selectNode.name]) {
        for (WDBaseNode *n in nodes) {
            if (![n.name isEqualToString:_selectNode.name] && ![n.name isEqualToString:@"bgNode"]) {
                node = n;
            }
        }
    }
    
    
    ///至于技能可以点击自己释放
    if ([node.name isEqualToString:kIceWizard] && [node.name isEqualToString:_selectNode.name]) {
        ///治愈技能
        if ([_selectNode.name isEqualToString:kIceWizard]) {
            [_selectNode attackAction1WithNode:node];
            [self cureAction];
        }
    }else if ([node.name isEqualToString:@"bgNode"] || [node.name isEqualToString:_selectNode.name]) {
        ///重复点击
        [self arrowAction:pos];
        if (_selectNode) {
            [_selectNode moveActionWithPoint:pos moveComplete:^{
            }];
        }
    }else{
        [self hiddenArrowAction];
    }
    
    
    ///是否选中了玩家
    if ([node isKindOfClass:[WDUserNode class]] && ![node.name isEqualToString:_selectNode.name]) {
        
        ///治愈技能
        if ([_selectNode.name isEqualToString:kIceWizard]) {
            [_selectNode attackAction1WithNode:node];
        }
        
        
        _selectNode.arrowNode.hidden = YES;
        _selectNode = node;
        _selectNode.arrowNode.hidden = NO;
        [_selectNode setSelectAction];
        
        if ([_selectNode.name isEqualToString:kIceWizard]) {
            for (WDBaseNode *user in self.userArr) {
                user.addBloodNode.hidden = NO;
            }
        }else{
            [self cureAction];
        }
        
    }
    
    
    
    ///点到怪物需要闪动一下
    if ([node isKindOfClass:[WDMonsterNode class]]) {
        [node setAttackArrow];
        ///点到怪物且之前有选中玩家的情况,直接走向怪物
        if (_selectNode) {
            CGPoint move = [WDCalculateTool selectMonsterWithUserNode:_selectNode monster:node];
            [_selectNode setTargetMonster:node];
            __weak typeof(self)weakSelf = self;
            [_selectNode moveActionWithPoint:move moveComplete:^{
                [weakSelf.selectNode attackAction1WithNode:node];
                [node attackAction1WithNode:weakSelf.selectNode];
            }];
        }
    }
    
    
    
 
    
   
    
    NSLog(@"%@",node.name);
    
}

- (void)touchMovedToPoint:(CGPoint)pos {
    
}

- (void)touchUpAtPoint:(CGPoint)pos {
    
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

- (void)releaseAction
{
    if (_testAttackLink) {
        [_testAttackLink invalidate];
        _testAttackLink = nil;
    }
}


#pragma mark - getter -
#pragma mark - 骑士 -
- (WDKinghtNode *)kNightNode
{
    if (!_kNightNode) {
        _kNightNode = [WDKinghtNode initWithModel:[WDTextureManager shareTextureManager].kinghtModel];
        [self.userArr addObject:_kNightNode];
    }
    
    return _kNightNode;
}

- (WDIceWizardNode *)iceWizardNode
{
    if (!_iceWizardNode) {
        _iceWizardNode = [WDIceWizardNode initWithModel:[WDTextureManager shareTextureManager].iceWizardModel];
        [self.userArr addObject:_iceWizardNode];
    }
    
    return _iceWizardNode;
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

@end
