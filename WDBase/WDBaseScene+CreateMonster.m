//
//  WDBaseScene+CreateMonster.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/15.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseScene+CreateMonster.h"

@implementation WDBaseScene (CreateMonster)

#pragma mark - 红蝙蝠 -
/// 红蝙蝠
- (void)redBatWithPosition:(CGPoint)point
{
    point = [self appearPoint:point];

    WDRedBatNode *node = [WDRedBatNode initWithModel:[WDTextureManager shareTextureManager].redBatModel];
    node.position = point;
    node.targetMonster = [self targetNode:point];
    node.alpha = 0;
    [self addChild:node];
    [self appearNodeWithName:kRedBat node:node];
}

#pragma mark - 骷髅士兵 -
///骷髅士兵
- (void)boneSoliderWithPosition:(CGPoint)point
{
    point = [self appearPoint:point];
    
    WDBoneSoliderNode *node = [WDBoneSoliderNode initWithModel:[WDTextureManager shareTextureManager].boneSoliderModel];
    node.position = point;
    node.targetMonster = [self targetNode:point];
    node.alpha = 0;
    [self addChild:node];
    [self appearNodeWithName:kBoneSolider node:node];
}

#pragma mark - 骷髅骑士 -
- (void)boneKnightWithPosition:(CGPoint)point{
   
    point = [self appearPoint:point];
    
    WDBoss2Node *node = [WDBoss2Node initWithModel:[WDTextureManager shareTextureManager].boss2Model];
    node.position = point;
    node.targetMonster = [self targetNode:point];

    node.alpha = 0;
    [self addChild:node];
    [self appearNodeWithName:kBoneKnight node:node];
}


/// 出场的位置
- (CGPoint)appearPoint:(CGPoint)point
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
        
        ///从屏幕外出现
        if (arc4random() % 2 == 0) {
            
            if (point.x > 0) {
                point.x = kScreenWidth;
            }else{
                point.x = -kScreenWidth;
            }
            
        }else{
            
            if (point.y > 0) {
                point.y = kScreenHeight;
            }else{
                point.y = -kScreenHeight;
            }
            
        }
        
    }
    
    return point;
}

/// 追击的目标
- (WDBaseNode *)targetNode:(CGPoint)point
{
    ///追击最近的人
    WDBaseNode *nearNode = (WDBaseNode *)[self nodeAtPoint:point];
    if ([nearNode isKindOfClass:[WDUserNode class]] && nearNode) {
        return nearNode;
    }else{
        CGFloat distance = 100000;
        for (int i = 0; i < self.userArr.count; i++) {
            WDUserNode *user = self.userArr[i];
            CGFloat dis = [WDCalculateTool distanceBetweenPoints:point seconde:user.position];
            if (dis < distance) {
                distance = dis;
                nearNode = user;
            }
        }
        
        if ([nearNode isKindOfClass:[WDUserNode class]]) {
            return nearNode;
        }else{
            return nil;
        }
    }
}


/// 设置出场动画
- (void)appearNodeWithName:(NSString *)name
                      node:(WDBaseNode *)node
{
    [self setSmokeWithMonster:node name:name];
    [self.monsterArr addObject:node];
    [self.textureManager setMonsterMovePointWithName:name monster:node];
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
