//
//  WDCalculateTool.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/11.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDCalculateTool.h"

@implementation WDCalculateTool

+ (CGFloat)nodeDistance:(WDBaseNode *)node1 seconde:(WDBaseNode *)node2
{
    CGFloat xDistance = fabs(node1.position.x - node2.position.x);
    CGFloat yDistance = fabs(node1.position.y - node2.position.y);
    
    CGFloat distance = sqrt(xDistance * xDistance + yDistance * yDistance);
    return distance;
    
}

+ (BOOL)nodeCanAttackWithNode:(WDBaseNode *)node1
                      seconde:(WDBaseNode *)node2
{
    
    CGFloat xDistance = fabs(node1.position.x - node2.position.x);
    CGFloat yDistance = fabs(node1.position.y - node2.position.y);
    
    CGFloat xR = node1.realSize.width / 2.0 + node2.realSize.width / 2.0 + 5;
    CGFloat yR = node1.realSize.height / 2.0 + node2.realSize.height / 2.0 + 5;
    
    if (xDistance < xR && yDistance < yR) {
        return YES;
    }else{
        return NO;
    }
    
}

+ (CGPoint)calculateUserMovePointWithUserNode:(WDBaseNode *)user
                                  monsterNode:(WDBaseNode *)monster
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGPoint userPoint = user.position;
    CGPoint monsterPoint = monster.position;
    
    CGFloat minDistance = user.realSize.width / 2.0 + monster.realSize.width / 2.0 + monster.randomDistanceX;
    CGFloat minY = monster.randomDistanceY;
    
    //近战
    if (user.attackDistance == 0) {
        
        //玩家在右边，怪物在左边
        if (userPoint.x < monsterPoint.x) {
        
            x = monsterPoint.x - minDistance;
            
            user.direction = @"right";
            user.isRight = YES;
            user.xScale =  fabs(user.xScale);
            
        }else{
            
            //玩家在左边，怪物在右边
            x = monsterPoint.x + minDistance;
            
            user.direction = @"left";
            user.isRight = NO;
            user.xScale = -fabs(user.xScale);
        }
    }
    
    
    y = monsterPoint.y;
    
    
    return CGPointMake(x, y);
}



+ (CGPoint)calculateMonsterMovePointWithMonsterNode:(WDBaseNode *)monster
                                           userNode:(WDBaseNode *)user
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGPoint userPoint = user.position;
    CGPoint monsterPoint = monster.position;
    
    CGFloat minDistance = user.realSize.width / 2.0 + monster.realSize.width / 2.0 + monster.randomDistanceX;

    //玩家在右边，怪物在左边，怪物要走在玩家靠左边边的位置
    if (userPoint.x > monsterPoint.x) {
    
        x = userPoint.x - minDistance;
        
        monster.direction = @"right";
        monster.isRight = YES;
        monster.xScale =  fabs(monster.xScale);
        
    }else{
        
        //玩家在左边，怪物在右边，怪物要走在玩家靠右边的位置
        x = userPoint.x + minDistance;
        
        monster.direction = @"left";
        monster.isRight = NO;
        monster.xScale = -fabs(monster.xScale);
    }
    
    y = userPoint.y + monster.randomDistanceY;
    
    
    return CGPointMake(x, y);
}


+ (CGFloat)calculateZposition:(WDBaseNode *)node
{
    CGFloat y = node.position.y;
    
    if (node.position.y < 0) {
        y = 2 * kScreenHeight - (kScreenHeight + node.position.y);
    }else{
        y = 2 * kScreenHeight - (kScreenHeight + node.position.y);
    }
    
    return y;
}

+ (CGFloat)distanceBetweenPoints:(CGPoint)first
                         seconde:(CGPoint)second
{
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
}

+ (CGFloat)angleForStartPoint:(CGPoint)startPoint
                     EndPoint:(CGPoint)endPoint{
    
    CGPoint Xpoint = CGPointMake(startPoint.x + 100, startPoint.y);
    
    CGFloat a = endPoint.x - startPoint.x;
    CGFloat b = endPoint.y - startPoint.y;
    CGFloat c = Xpoint.x - startPoint.x;
    CGFloat d = Xpoint.y - startPoint.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
    if (startPoint.y>endPoint.y) {
        rads = -rads;
    }
    return rads;
}

@end
