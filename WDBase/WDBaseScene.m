//
//  WDBaseScene.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseScene.h"
#import "WDBaseScene+CreateMonster.h"
@implementation WDBaseScene


#pragma mark - 通知方法 -
- (void)addObserveAction
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(diedAction) name:kNotificationForDied object:nil];
}

- (void)diedAction{
    
    
    
    for (WDBaseNode *node in self.userArr) {
        if (node.isDead) {
            [self.userArr removeObject:node];
            [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
            break;
        }
    }
    
    for (WDBaseNode *node in self.monsterArr) {
        if (node.isDead) {
            [self.monsterArr removeObject:node];
            [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
            break;
        }
    }
}

#pragma mark - 进入游戏界面 -
- (void)didMoveToView:(SKView *)view
{
    
    SKSpriteNode *widthNode = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(100, 50)];
    
    widthNode.position = CGPointMake(-300, -100);
    
    [self addChild:widthNode];
    
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
    

    //self.anchorPoint = CGPointMake(0, 0);
}




#pragma mark - 物理检测 -
- (void)didBeginContact:(SKPhysicsContact *)contact{
    
    WDBaseNode *nodeA = (WDBaseNode *)contact.bodyA.node;
    WDBaseNode *nodeB = (WDBaseNode *)contact.bodyB.node;
       
       
       
       
    NSLog(@"A: %@  b: %@",nodeA.name,nodeB.name);
    
}
- (void)didEndContact:(SKPhysicsContact *)contact{}



//移动标识
- (void)arrowAction:(CGPoint)pos{
    WDTextureManager *manager = [WDTextureManager shareTextureManager];
    [manager arrowMoveActionWithPos:pos];
    
    _selectNode.targetMonster = nil;
    _selectNode.isAttack = NO;

}




#pragma mark - 触碰 -
- (void)touchDownAtPoint:(CGPoint)pos {
    NSLog(@"点中的坐标为: x = %lf  y = %lf",pos.x,pos.y);
}

// 移动
- (void)touchMovedToPoint:(CGPoint)pos {
    
    /// 玩家在移动状态，不显示指引线
    if (!_selectNode.isMove) {
        self.selectLine.hidden = NO;
        self.selectLine.position = CGPointMake(_selectNode.position.x, _selectNode.position.y - _selectNode.realSize.height / 2.0 + 35);
    }
    
    ///引导线
    //斜边
    CGFloat width = [WDCalculateTool distanceBetweenPoints:pos seconde:self.selectLine.position];
    self.selectLine.size = CGSizeMake(width, 10);
    //角度
    self.selectLine.zRotation = [WDCalculateTool angleForStartPoint:self.selectLine.position EndPoint:pos];
    
    [self.selectLine createLinePhyBody];

}

// 触碰结束
- (void)touchUpAtPoint:(CGPoint)pos {
    
    NSArray *nodes = [self nodesAtPoint:pos];

    
    WDUserNode *userNode = nil;
    WDMonsterNode *monsterNode = nil;
    CGFloat distance = 100000;
    ///点击区域角色
    for (WDBaseNode *n in nodes) {
           
        CGFloat dis = [WDCalculateTool distanceBetweenPoints:pos seconde:n.position];
        if ([n isKindOfClass:[WDUserNode class]]) {
           
            if (dis < distance) {
                userNode = (WDUserNode *)n;
                monsterNode = nil;
                distance = dis;
            }
            
        }else if ([n isKindOfClass:[WDMonsterNode class]]) {
            if (dis < distance) {
                monsterNode = (WDMonsterNode *)n;
                userNode = nil;
                distance = dis;
            }
        }
    }
    
    
    BOOL canMove = YES;
   
    if (_selectNode.addBuff  && userNode && _selectLine.hidden == NO) {
        ///增益buff状态~
        NSLog(@"我要加血啦~");
        canMove = NO;
        [userNode selectSpriteAction];
        [_selectNode addBuffActionWithNode:userNode];
         
    }else if (![_selectNode.name isEqualToString:userNode.name] && userNode) {
       
        ///切换选中目标，不能移动
        _selectNode.arrowNode.hidden = YES;
        userNode.arrowNode.hidden    = NO;
        canMove = NO;
        _selectNode = userNode;
        [_selectNode selectSpriteAction];
        [[WDTextureManager shareTextureManager] hiddenArrow];

        
    }else if(monsterNode){
        
        [monsterNode selectSpriteAction];
        
        ///玩家当前选中人物和怪物选中的攻击人物
        if ([monsterNode.targetMonster.name isEqualToString:_selectNode.name]) {
            
            monsterNode.randomDistanceY = 0;
            monsterNode.randomDistanceY = 0;
            
            //重置一下之前怪物的位置
            [self.textureManager setMonsterMovePointWithName:_selectNode.targetMonster.name monster:_selectNode.targetMonster];
        }
        
        ///选中怪物的情况
        _selectNode.targetMonster = monsterNode;
        [[WDTextureManager shareTextureManager] hiddenArrow];
        canMove = NO;
        
    }
    
    
    
    /// 非切换目标可以移动
    if (canMove) {
        _selectNode.targetMonster = nil;
        [_selectNode moveActionWithPoint:pos moveComplete:^{
        }];
        [self arrowAction:pos];

    }

    
    self.selectLine.hidden = YES;
    self.selectLine.size = CGSizeMake(0, 0);

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


- (void)releaseAction
{
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
