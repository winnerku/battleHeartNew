
//
//  RealPubScene.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/5.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "RealPubScene.h"

@implementation RealPubScene
{
    NSArray *_xArr;
    NSArray *_yArr;
    CADisplayLink *_mapLink;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
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
    
    self.passDoorNode.position = CGPointMake(300, 200);
    self.passDoorNode.zPosition = 10;
    
    self.archerNode.physicsBody.categoryBitMask = 1;
    [self.archerNode.talkNode setText:self.textureManager.goText hiddenTime:3 completeBlock:^{
   }];
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
        self.clickNode.position = CGPointMake(nodeB.position.x, nodeB.position.y - 50);
        self.clickNode.hidden = NO;
//        self.userInteractionEnabled = NO;
//        [self performSelector:@selector(show) withObject:nil afterDelay:1];
    }
    
    NSLog(@"A: %@  b: %@",nodeA.name,nodeB.name);

}

- (void)show{
    self.userInteractionEnabled = YES;
    if (self.showMapSelectBlock) {
        self.showMapSelectBlock();
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    WDBaseNode *nodeA = (WDBaseNode *)contact.bodyA.node;
    WDBaseNode *nodeB = (WDBaseNode *)contact.bodyB.node;
    if ([nodeA isKindOfClass:[WDUserNode class]] && [nodeB.name isEqualToString:@"passDoor"]) {
        [nodeB removeAllActions];
        nodeB.texture = self.textureManager.passDoorArr[0];
        self.clickNode.hidden = YES;
    }
}

- (void)touchMovedToPoint:(CGPoint)pos
{
    
}

- (void)touchUpAtPoint:(CGPoint)pos
{
    CGFloat clickDistance = [WDCalculateTool distanceBetweenPoints:pos seconde:self.clickNode.position];
    
    if (self.clickNode.hidden == NO && clickDistance < 100) {
        [self show];
        return;
    }

    if (pos.y > kScreenHeight * 2.0 - 450) {
        pos = CGPointMake(pos.x, kScreenHeight * 2.0 - 450);
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
     
  
     
     ///首先判断是否选中的为monster
     if(userNode){
         
         //如果引导线没隐藏，添加buff效果
//         if(![self.selectNode.name isEqualToString:userNode.name] && ![userNode.name isEqualToString:kStone]){
//             //切换选中的玩家
//             canMove = [self changeSelectNode:userNode pos:pos];
//         }
         
     }
     

     
     /// 非切换目标可以移动
     if (canMove) {
         self.selectNode.targetMonster = nil;
         [self.selectNode moveActionWithPoint:pos moveComplete:^{
         }];
         [self arrowAction:pos];

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
        _passDoorNode.physicsBody.contactTestBitMask = 1;
        _passDoorNode.physicsBody.collisionBitMask = 0;
    }
    
    return _passDoorNode;
}

- (WDBaseNode *)clickNode{
    if (!_clickNode) {
        _clickNode = [WDBaseNode spriteNodeWithTexture:self.textureManager.clickArr[0]];
        _clickNode.hidden = YES;
        [self.bgNode addChild:_clickNode];
        _clickNode.zPosition = 10000;
        SKAction *an = [SKAction animateWithTextures:self.textureManager.clickArr timePerFrame:0.5];
        SKAction *re = [SKAction repeatActionForever:an];
        [_clickNode runAction:re];
    }
    
    return _clickNode;
}

@end
