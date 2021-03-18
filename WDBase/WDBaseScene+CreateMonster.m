//
//  WDBaseScene+CreateMonster.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/15.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseScene+CreateMonster.h"

@implementation WDBaseScene (CreateMonster)


- (void)redBatWithPosition:(CGPoint)point
{
    
    if (point.x == 0) {
        
        int ax = 1;
        int ay = 1;
        if (arc4random() % 2 == 0) {
            ax = -1;
        }
        if (arc4random() % 2 == 0) {
            ay = -1;
        }
        
        CGFloat x = (arc4random() % (int)kScreenWidth);
        CGFloat y = (arc4random() % (int)kScreenHeight);
        
        point = CGPointMake(x * ax, y * ay);
    }
    
    WDRedBatNode *node = [WDRedBatNode initWithModel:[WDTextureManager shareTextureManager].redBatModel];
    node.position = point;


    ///追击最近的人
    WDBaseNode *nearNode = (WDBaseNode *)[self nodesAtPoint:point];
    if ([nearNode isKindOfClass:[WDBaseNode class]] && nearNode) {
        node.targetMonster = nearNode;
    }else{
        CGFloat distance = 100000;
        for (int i = 0; i < self.userArr.count; i++) {
            WDBaseNode *user = self.userArr[i];
            CGFloat dis = [WDCalculateTool distanceBetweenPoints:node.position seconde:user.position];
            if (dis < distance) {
                distance = dis;
                nearNode = user;
            }
        }
        //if ([nearNode isKindOfClass:[WDBaseNode class]]) {
            node.targetMonster = nearNode;
        //}
    }

    node.alpha = 0;
    [self addChild:node];
    
    
    [self setSmokeWithMonster:node name:kRedBat];
    [self.monsterArr addObject:node];
    [self.textureManager setMonsterMovePointWithName:kRedBat monster:node];
}

- (void)boneSoliderWithPosition:(CGPoint)point
{
    if (point.x == 0) {
        
        int ax = 1;
        int ay = 1;
        if (arc4random() % 2 == 0) {
            ax = -1;
        }
        if (arc4random() % 2 == 0) {
            ay = -1;
        }
        
        CGFloat x = (arc4random() % (int)kScreenWidth) ;
        CGFloat y = (arc4random() % (int)kScreenHeight) ;

        point = CGPointMake(x * ax, y * ay);
    }
    
    WDBoneSoliderNode *node = [WDBoneSoliderNode initWithModel:[WDTextureManager shareTextureManager].boneSoliderModel];
    node.position = point;


    ///追击最近的人
    WDBaseNode *nearNode = (WDBaseNode *)[self nodesAtPoint:point];
    if ([nearNode isKindOfClass:[WDBaseNode class]] && nearNode) {
        node.targetMonster = nearNode;
    }else{
        CGFloat distance = 100000;
        for (int i = 0; i < self.userArr.count; i++) {
            WDBaseNode *user = self.userArr[i];
            CGFloat dis = [WDCalculateTool distanceBetweenPoints:node.position seconde:user.position];
            if (dis < distance) {
                distance = dis;
                nearNode = user;
            }
        }
        //if ([nearNode isKindOfClass:[WDBaseNode class]]) {
            node.targetMonster = nearNode;
        //}
    }

    node.alpha = 0;
    [self addChild:node];
    
    
    [self setSmokeWithMonster:node name:kBoneSolider];
    [self.monsterArr addObject:node];
    [self.textureManager setMonsterMovePointWithName:kBoneSolider monster:node];
}

//烟雾出场
- (void)setSmokeWithMonster:(WDBaseNode *)monsterNode
                       name:(NSString *)nameStr
{
    
    WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:self.textureManager.smokeArr[0]];
    
    node.position = monsterNode.position;
    node.zPosition = 10000;
    node.name = @"smoke";
    node.xScale = 1.5;
    node.yScale = 1.5;
    [self addChild:node];
    SKAction *lightA = [SKAction animateWithTextures:self.textureManager.smokeArr timePerFrame:0.075];
    SKAction *alphaA = [SKAction fadeAlphaTo:0.2 duration:self.textureManager.smokeArr.count * 0.075];
    SKAction *r = [SKAction removeFromParent];
    SKAction *s = [SKAction sequence:@[[SKAction group:@[lightA,alphaA]],r]];
    
    [monsterNode runAction:[SKAction fadeAlphaTo:1 duration:self.textureManager.smokeArr.count * 0.075]];
    [node runAction:s completion:^{
    }];
}


//紫色灯光出场
- (void)setLightWithMonster:(WDBaseNode *)monsterNode name:(NSString *)nameStr
{
    
    WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:self.textureManager.lightArr[0]];
    
    node.position = monsterNode.position;
    node.zPosition = 10000;
    node.name = @"light";
    [self.bgNode addChild:node];
    SKAction *lightA = [SKAction animateWithTextures:self.textureManager.lightArr timePerFrame:0.05];
    SKAction *s = [SKAction sequence:@[lightA]];
    
    [monsterNode runAction:[SKAction fadeAlphaTo:1 duration:self.textureManager.lightArr.count * 0.05]];
   

    [node runAction:s completion:^{
        [node runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:0 duration:0.5],[SKAction removeFromParent]]]];
        
    }];
}

@end
