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
       
        CGFloat x = arc4random() % (int)kScreenWidth;
        CGFloat y = arc4random() % (int)kScreenHeight;

        point = CGPointMake(x, y);
    }
    
    WDRedBatNode *node = [WDRedBatNode initWithModel:[WDTextureManager shareTextureManager].redBatModel];
    node.isInit = YES;
   

    ///追击最近的人
    WDBaseNode *nearNode = (WDBaseNode *)[self nodesAtPoint:point];
    if (![nearNode isKindOfClass:[WDBaseNode class]]) {
        nearNode = self.kNightNode;;
    }

    node.position = point;
    node.alpha = 0;
    [self addChild:node];
    
    
    [self setSmokeWithMonster:node name:kRedBat];
    [self.monsterArr addObject:node];
    [self.textureManager setMonsterMovePointWithName:kRedBat monster:node];
    node.targetMonster = nearNode;
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
        monsterNode.isInit = NO;
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
