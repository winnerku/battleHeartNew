//
//  WDCalculateTool.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/11.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDCalculateTool : NSObject

+ (CGFloat)distanceBetweenPoints:(CGPoint)first
                         seconde:(CGPoint)second;

+ (CGFloat)angleForStartPoint:(CGPoint)startPoint
                     EndPoint:(CGPoint)endPoint;

+ (CGFloat)nodeDistance:(WDBaseNode *)node1
                seconde:(WDBaseNode *)node2;


+ (BOOL)nodeCanAttackWithNode:(WDBaseNode *)node1
                      seconde:(WDBaseNode *)node2;



/// 计算node的Z
+ (CGFloat)calculateZposition:(WDBaseNode *)node;


/// 计算玩家需要移动的位置
+ (CGPoint)calculateUserMovePointWithUserNode:(WDBaseNode *)user
                                  monsterNode:(WDBaseNode *)monster;

/// 计算怪物需要移动的位置
+ (CGPoint)calculateMonsterMovePointWithMonsterNode:(WDBaseNode *)monster
                                           userNode:(WDBaseNode *)user;

@end

NS_ASSUME_NONNULL_END
