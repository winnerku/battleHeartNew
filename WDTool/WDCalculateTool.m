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

+ (CGPoint)selectMonsterWithUserNode:(WDBaseNode *)user
                             monster:(WDBaseNode *)monster
{
    CGPoint userPoint = user.position;
    CGPoint monsterPoint = monster.position;
    
    CGFloat x = 0;
    CGFloat y = monsterPoint.y;
    if ([user.name isEqualToString:kKinght]) {
        y = monsterPoint.y + 20;
    }
    if (userPoint.x > monsterPoint.x) {
        x = monsterPoint.x + user.realSize.width / 2.0 + monster.realSize.width / 2.0;
        user.xScale = - fabs(user.xScale);
    }else{
        x = monsterPoint.x - user.realSize.width / 2.0 - monster.realSize.width / 2.0;
        user.xScale = fabs(user.xScale);
    }
    
    return CGPointMake(x, y);
    
}

@end
