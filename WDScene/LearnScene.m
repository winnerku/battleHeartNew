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
    int  _monsterNumber;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveFinish:) name:kNotificationForMoveFinish object:nil];
    
    [self addChild:self.kNightNode];
    [self addChild:self.iceWizardNode];
    
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"BattleScene_1.jpg"]];
    
    self.kNightNode.position = CGPointMake(0, 0);
    self.kNightNode.zPosition = 10;
    
    self.selectNode = self.kNightNode;
    self.selectNode.arrowNode.hidden = NO;
    
    self.iceWizardNode.position = CGPointMake(150, 0);
    self.iceWizardNode.zPosition = 10;
    
    
    [self createMonsterWithName:kRedBat position:CGPointMake(300, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(-300, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(-300, 0)];

}

- (void)createMonsterWithName:(NSString *)name position:(CGPoint)point
{
    if (_monsterNumber >= 10) {
        return;
    }
    
    [super createMonsterWithName:name position:point];
    _monsterNumber ++;
}

- (void)moveFinish:(NSNotification *)notification
{
    if (_canTouch) {
        return;
    }
    _firstTouch = NO;
    _canTouch = YES;

}



- (void)didBeginContact:(SKPhysicsContact *)contact
{
    WDBaseNode *nodeA = (WDBaseNode *)contact.bodyA.node;
    WDBaseNode *nodeB = (WDBaseNode *)contact.bodyB.node;
    
    
    
    
   // NSLog(@"A: %@  b: %@",nodeA.name,nodeB.name);
    
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
    WDBaseNode *nodeA = (WDBaseNode *)contact.bodyA.node;
    WDBaseNode *nodeB = (WDBaseNode *)contact.bodyB.node;
       
//    [nodeA standAction];
//    [nodeB standAction];
}




@end
