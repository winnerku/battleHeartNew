
//
//  RealPubScene.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/5.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "RealPubScene.h"
#import "LearnSkillNode.h"
#import "WDBaseScene+TouchLogic.h"
#import "WDBaseScene+Moive.h"

@implementation RealPubScene
{
    NSArray *_xArr;
    NSArray *_yArr;
    CADisplayLink *_mapLink;
    LearnSkillNode *_skillNode;
    SKSpriteNode *_ballNode;
    SKLabelNode  *_ballLabel;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.textureManager.mapBigY_Up = 0;
    self.textureManager.mapBigY_down = 230;
    
    [self createMapPosArr];
    
    _mapLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(mapMove)];
    [_mapLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [self.textureManager.arrowNode removeFromParent];
    [self.textureManager.locationNode removeFromParent];
    self.textureManager.arrowNode.zPosition = 12;
    self.textureManager.locationNode.zPosition = 11;
    [self.bgNode addChild:self.textureManager.arrowNode];
    [self.bgNode addChild:self.textureManager.locationNode];

    
    [self.bgNode addChild:self.iceWizardNode];
    [self.bgNode addChild:self.kNightNode];
    [self.bgNode addChild:self.archerNode];
    
    
    self.iceWizardNode.position = CGPointMake(1000, 300);
    self.kNightNode.position    = CGPointMake(1200, 300);
    
    self.kNightNode.xScale = -fabs(self.kNightNode.xScale);
    self.kNightNode.isRight = NO;
    
    
    self.archerNode.position = CGPointMake(300, 300);
    self.selectNode = self.archerNode;
    self.archerNode.arrowNode.hidden = NO;
    
    
    
    self.archerNode.physicsBody.categoryBitMask = 1;
    self.kNightNode.physicsBody.categoryBitMask = 1;
    self.iceWizardNode.physicsBody.categoryBitMask = 1;
    
    [self.archerNode.talkNode setText:self.textureManager.goText hiddenTime:3 completeBlock:^{
   }];
    
    self.kNightNode.isPubScene = YES;
    self.iceWizardNode.isPubScene = YES;
    self.archerNode.isPubScene = YES;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForHiddenSkill object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createBallAction) name:kNotificationForLearnSkill object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    /// 忍者剧情
    if ([defaults boolForKey:kNinjaFirst]) {
        [self ninjaMoive];
    }else if([defaults boolForKey:kPassCheckPoint2]){
        [self.bgNode addChild:self.ninjaNode];
        self.ninjaNode.position = CGPointMake(1400, 300);
        self.ninjaNode.physicsBody.categoryBitMask = 1;
        self.ninjaNode.isPubScene = YES;
    }
    
    /// 有学习技能的NPC了，之后才有绿球
    if ([defaults boolForKey:kSkillNPC]) {
        [self createSkillNPC];
        [self createBallAction];
        [self.iceWizardNode.talkNode setText:@"发现新探索地点\n快去救老大吧" hiddenTime:4 completeBlock:^{
        }];
    }
    
    self.passDoorNode.position = CGPointMake(300, 200);
    self.passDoorNode.zPosition = 10;
}


- (void)createBallAction{
    
    NSInteger ballCount = [[NSUserDefaults standardUserDefaults]integerForKey:kSkillBall];
   
    _ballNode = (SKSpriteNode *)[self childNodeWithName:@"ballNode"];
    _ballNode.zPosition = 10000;
   
    
    [_ballNode runAction:[SKAction fadeAlphaTo:1 duration:0.4]];
    
    _ballLabel = (SKLabelNode *)[self childNodeWithName:@"ballLabel"];
    _ballLabel.text = [NSString stringWithFormat:@"x%ld",ballCount];
    _ballLabel.hidden = NO;
    _ballLabel.position = CGPointMake(kScreenWidth * 2.0 - _ballLabel.fontSize - 30, kScreenHeight * 2.0 - 100);
    
    _ballNode.position = CGPointMake(kScreenWidth * 2.0 - _ballLabel.fontSize - 30 - 90, kScreenHeight * 2.0 - 78);
    
}

#pragma mark - 学习技能的NPC（打过第一关BOSS激活）-
/// 学习技能的NPC
- (void)createSkillNPC
{
    SkillModel *model = [[SkillModel alloc] init];
    [model changeArr];
    
    _skillNode = [LearnSkillNode spriteNodeWithTexture:model.standArr[0]];
    _skillNode.model = model;
    _skillNode.isStand = YES;
    _skillNode.name = @"learnSkill";
    _skillNode.xScale = 1.8;
    _skillNode.yScale = 1.8;
    _skillNode.position = CGPointMake(600, 400);
    _skillNode.zPosition = 650 - _skillNode.position.y;
    [self.bgNode addChild:_skillNode];
       
    [_skillNode stayAction];
    
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:_skillNode.size center:CGPointMake(0, 0)];
    _skillNode.physicsBody = body;
    _skillNode.physicsBody.affectedByGravity = NO;
    _skillNode.physicsBody.allowsRotation = NO;
    _skillNode.physicsBody.contactTestBitMask = 1;
    _skillNode.physicsBody.collisionBitMask = 0;
    _skillNode.physicsBody.categoryBitMask = 0;

    
}

- (void)mapMove{
    if (self.selectNode.position.x < _xArr.count && self.selectNode.position.x > 0) {
        int index = self.selectNode.position.x;
        self.bgNode.position = CGPointMake([_xArr[index]floatValue], 0);
    }
    
   // NSLog(@"%lf",self.bgNode.position.x);
}

- (void)createMapPosArr{
    
    int bigX = self.bgNode.size.width;
    //int bigY = self.size.height;
    
    NSMutableArray *xArr = [NSMutableArray array];
    for (int i = 0; i < bigX; i ++) {
        int x = i;
        if (i < kScreenWidth) {
            x = 0;
        }else if(i > bigX - kScreenWidth){
            x = - (bigX - kScreenWidth * 2.0);
        }else{
            x = - (i - kScreenWidth);
        }
        
        [xArr addObject:@(x)];
    }
    
    _xArr = xArr;
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    WDBaseNode *nodeA = (WDBaseNode *)contact.bodyA.node;
    WDBaseNode *nodeB = (WDBaseNode *)contact.bodyB.node;
    
    if ([nodeA isKindOfClass:[WDUserNode class]] && [nodeB.name isEqualToString:@"passDoor"]) {
        NSArray *arr = [self.textureManager.passDoorArr subarrayWithRange:NSMakeRange(1, self.textureManager.passDoorArr.count - 1)];
        SKAction *an = [SKAction animateWithTextures:arr timePerFrame:0.1];
        SKAction *re = [SKAction repeatActionForever:an];
        [nodeB runAction:re];
        self.clickMapNode.position = CGPointMake(nodeB.position.x, nodeB.position.y - 50);
        self.clickMapNode.hidden = NO;
    }
    
    if ([nodeA isKindOfClass:[WDUserNode class]] && [nodeB.name isEqualToString:@"learnSkill"]) {
        CGFloat xScale = fabs(_skillNode.xScale);
        if (nodeA.position.x < nodeB.position.x) {
            xScale = -1 * xScale;
        }else{
            xScale = xScale;
        }
               
        _skillNode.xScale = xScale;
        [_skillNode standAction];
        self.clickLearnSkillNode.position = CGPointMake(nodeB.position.x, nodeB.position.y - 80);
        self.clickLearnSkillNode.hidden = NO;
    }
    
    NSLog(@"A: %@  b: %@",nodeA.name,nodeB.name);

}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    WDBaseNode *nodeA = (WDBaseNode *)contact.bodyA.node;
    WDBaseNode *nodeB = (WDBaseNode *)contact.bodyB.node;
    if ([nodeA isKindOfClass:[WDUserNode class]] && [nodeB.name isEqualToString:@"passDoor"]) {
        [nodeB removeAllActions];
        nodeB.texture = self.textureManager.passDoorArr[0];
        self.clickMapNode.hidden = YES;
    }
    
    if ([nodeA isKindOfClass:[WDUserNode class]] && [nodeB.name isEqualToString:@"learnSkill"]) {
        CGFloat xScale = fabs(_skillNode.xScale);
        if (nodeA.position.x < nodeB.position.x) {
            xScale = -1 * xScale;
        }else{
            xScale = xScale;
        }
               
        _skillNode.xScale = xScale;
        [_skillNode stayAction];
        self.clickLearnSkillNode.hidden = YES;
    }
    
    
}

- (void)touchMovedToPoint:(CGPoint)pos
{
    
}

- (void)touchUpAtPoint:(CGPoint)pos
{
    CGFloat clickDistance = 0;
    if (self.clickMapNode.hidden == NO) {
        ///地图选择
        clickDistance = [WDCalculateTool distanceBetweenPoints:pos seconde:self.clickMapNode.position];
        if (clickDistance < 100) {
            [self showMapSelectAction];
            return;
        }
    }else if(self.clickLearnSkillNode.hidden == NO){
        ///技能选择
        clickDistance = [WDCalculateTool distanceBetweenPoints:pos seconde:self.clickLearnSkillNode.position];
        if (clickDistance < 100) {
            [self learnSkillAction];
            return;
        }
    }
    
    
    
    
    

    if (pos.y > kScreenHeight * 2.0 - kScreenHeight) {
        pos = CGPointMake(pos.x, kScreenHeight * 2.0 - kScreenHeight);
    }else if(pos.y < 100){
        pos = CGPointMake(pos.x, 100);
    }
    if (pos.x < 100) {
        pos = CGPointMake(100, pos.y);
    }else if(pos.x > self.bgNode.size.width / self.bgNode.xScale - 100){
        pos = CGPointMake(self.bgNode.size.width / self.bgNode.xScale - 100, pos.y);
    }
    
     NSArray *nodes = [self.bgNode nodesAtPoint:pos];
    
     WDUserNode *userNode = nil;
     WDMonsterNode *monsterNode = nil;
     CGFloat distance = 100000;
    
     ///点击区域角色，筛选出角色坐标离选中坐标最近的点
     for (WDBaseNode *n in nodes) {
            
         CGFloat dis = [WDCalculateTool distanceBetweenPoints:pos seconde:n.position];
         if ([n isKindOfClass:[WDUserNode class]]) {
            
             if (dis < distance) {
                 userNode = (WDUserNode *)n;
                 monsterNode = nil;
                 distance = dis;
             }
             
         }
     }
     
    BOOL canMove = YES;

    /// 切换
    if (![userNode isEqualToNode:self.selectNode] && userNode) {
       canMove = [self changeSelectNode:userNode pos:pos];
        if (!canMove) {
            //如果换人了，切换下
            self.clickLearnSkillNode.hidden = YES;
            self.clickMapNode.hidden = YES;
            [_skillNode stayAction];
            [_passDoorNode removeAllActions];
            _passDoorNode.texture = self.textureManager.passDoorArr[0];
        }
    }
     
     
     /// 非切换目标可以移动
     if (canMove) {
         self.selectNode.targetMonster = nil;
         [self.selectNode moveActionWithPoint:pos moveComplete:^{
         }];
         [self arrowAction:pos];

     }
}


/// 选择地图
- (void)showMapSelectAction{
    if (self.showMapSelectBlock) {
        self.showMapSelectBlock();
    }
}

/// 学习技能
- (void)learnSkillAction{
    if (self.showSkillSelectBlock) {
        self.showSkillSelectBlock(self.selectNode.name);
    }
}

- (void)releaseAction
{
    [super releaseAction];
    if (_mapLink) {
        [_mapLink invalidate];
        _mapLink = nil;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self.bgNode]];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self.bgNode]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self.bgNode]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self.bgNode]];}
}

- (WDBaseNode *)passDoorNode
{
    if (!_passDoorNode) {
        _passDoorNode = [WDBaseNode spriteNodeWithTexture:self.textureManager.passDoorArr[0]];
        _passDoorNode.alpha = 1;
        [self.bgNode addChild:_passDoorNode];
        _passDoorNode.xScale = 1.0;
        _passDoorNode.yScale = 1.0;
        _passDoorNode.name = @"passDoor";
        SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:_passDoorNode.size center:CGPointMake(0, 0)];
        _passDoorNode.physicsBody = body;
        _passDoorNode.physicsBody.affectedByGravity = NO;
        _passDoorNode.physicsBody.allowsRotation = NO;
        _passDoorNode.physicsBody.categoryBitMask = 0;
        _passDoorNode.physicsBody.contactTestBitMask = 1;
        _passDoorNode.physicsBody.collisionBitMask = 0;
        
    }
    
    return _passDoorNode;
}

- (WDBaseNode *)clickMapNode{
    if (!_clickMapNode) {
        _clickMapNode = [WDBaseNode spriteNodeWithTexture:self.textureManager.clickArr[0]];
        _clickMapNode.hidden = YES;
        [self.bgNode addChild:_clickMapNode];
        _clickMapNode.zPosition = 10000;
        SKAction *an = [SKAction animateWithTextures:self.textureManager.clickArr timePerFrame:0.5];
        SKAction *re = [SKAction repeatActionForever:an];
        [_clickMapNode runAction:re];
    }
    
    return _clickMapNode;
}

- (WDBaseNode *)clickLearnSkillNode{
    if (!_clickLearnSkillNode) {
        _clickLearnSkillNode = [WDBaseNode spriteNodeWithTexture:self.textureManager.clickArr[0]];
        _clickLearnSkillNode.hidden = YES;
        [self.bgNode addChild:_clickLearnSkillNode];
        _clickLearnSkillNode.zPosition = 10000;
        SKAction *an = [SKAction animateWithTextures:self.textureManager.clickArr timePerFrame:0.5];
        SKAction *re = [SKAction repeatActionForever:an];
        [_clickLearnSkillNode runAction:re];
    }
    
    return _clickLearnSkillNode;
}

@end
