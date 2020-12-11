//
//  LearnScene.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/11.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "LearnScene.h"
#import "WDRedBatNode.h"

@implementation LearnScene
{
    BOOL _canTouch;
    BOOL _firstTouch;
    
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveFinish:) name:kNotificationForMoveFinish object:nil];
    
    [self addChild:self.kNightNode];
    
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"BattleScene_1.jpg"]];
    
    self.kNightNode.position = CGPointMake(0, 0);
    self.kNightNode.zPosition = self.size.height - self.kNightNode.position.y;
    
    [self createLocationArrow];

}

- (void)moveFinish:(NSNotification *)notification
{
    if (_canTouch) {
        return;
    }
    _firstTouch = NO;
    _canTouch = YES;
    [self createMonster];

}


/// 创建引导箭头
- (void)createLocationArrow{
    
    WDTextureManager *manager = [WDTextureManager shareTextureManager];
    WDBaseNode *location = manager.arrowNode;
    if (![self childNodeWithName:@"location"]) {
        [self addChild:location];
    }
    
    location.alpha = 1;
    [location removeAllActions];
    CGPoint pos = self.kNightNode.position;
    CGFloat y = self.kNightNode.position.y + self.kNightNode.size.height / 2.0 + 30;
    
    location.position = CGPointMake(self.kNightNode.position.x, y);
    SKAction *move1 = [SKAction moveTo:CGPointMake(pos.x,y + 40) duration:0.5];
    SKAction *move2 = [SKAction moveTo:CGPointMake(pos.x, y ) duration:0.5];
    SKAction *seq = [SKAction sequence:@[move1,move2]];
    SKAction *rep = [SKAction repeatActionForever:seq];
    [location runAction:rep completion:^{
        location.alpha = 0;
    }];
}


/// 创建引导箭头2
- (void)createLocationArrow2{
    
    CGPoint pos = CGPointMake(self.kNightNode.position.x + 400, self.kNightNode.position.y - 100);
    //移动标识
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
   
}



/// 创建怪物
- (void)createMonster{
    WDRedBatNode *node = [WDRedBatNode initWithModel:[WDTextureManager shareTextureManager].redBatModel];
    node.zPosition = 100;
    [self addChild:node];
    node.position = CGPointMake(-400, 0);
    [self.monsterArr addObject:node];
    
    [self addChild:self.iceWizardNode];

    self.iceWizardNode.position = CGPointMake(0, 0);
    self.iceWizardNode.zPosition = 1000;
}





- (void)didBeginContact:(SKPhysicsContact *)contact
{
    WDBaseNode *nodeA = (WDBaseNode *)contact.bodyA.node;
    WDBaseNode *nodeB = (WDBaseNode *)contact.bodyB.node;
    
    
    
    
    NSLog(@"A: %@  b: %@",nodeA.name,nodeB.name);
    
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    WDBaseNode *nodeA = (WDBaseNode *)contact.bodyA.node;
    WDBaseNode *nodeB = (WDBaseNode *)contact.bodyB.node;
       
//    [nodeA standAction];
    [nodeB standAction];
}

- (void)testAttackAction:(CADisplayLink *)link
{
    if (!self.selectNode.targetMonster && !self.selectNode.isMove && !self.selectNode.isAttack) {
        
        WDMonsterNode *nearNode = nil;
        CGFloat distance = 1000000;
        for (WDMonsterNode *node in self.monsterArr) {
            CGFloat d = [WDCalculateTool nodeDistance:self.selectNode seconde:node];
            if (distance > d) {
                distance = d;
                nearNode = node;
            }
        }
        
        BOOL canAttack = [WDCalculateTool nodeCanAttackWithNode:self.selectNode seconde:nearNode];
        if (canAttack && nearNode) {
            CGPoint movePoint = [WDCalculateTool selectMonsterWithUserNode:self.selectNode monster:nearNode];
            __weak typeof(self)waekSelf = self;
            [self.selectNode moveActionWithPoint:movePoint moveComplete:^{
                [waekSelf.selectNode attackAction1WithNode:nearNode];
                [nearNode attackAction1WithNode:waekSelf.selectNode];
            }];
            
        }
    }
}

/// 触摸
- (void)touchDownAtPoint:(CGPoint)pos
{
    if (_firstTouch) {
        return;
    }
    
    if (_canTouch) {
        [super touchDownAtPoint:pos];
    }else{
        
        WDBaseNode *node = (WDBaseNode *)[self nodeAtPoint:pos];
        if ([node isKindOfClass:[WDUserNode class]]) {
            
            WDTextureManager *manager = [WDTextureManager shareTextureManager];
            WDBaseNode *location = manager.arrowNode;
            location.alpha = 0;
            node.arrowNode.hidden = NO;
            self.selectNode = node;
            [self.selectNode setSelectAction];

            [self createLocationArrow2];
        }
        
        if ([node.name isEqualToString:@"location"]||[node.name isEqualToString:@"arrow"]) {
            [self.selectNode moveActionWithPoint:CGPointMake(self.kNightNode.position.x + 400, self.kNightNode.position.y - 100) moveComplete:^{
                
            }];
            _firstTouch = YES;
        }
        
        
    }
 
}



@end
