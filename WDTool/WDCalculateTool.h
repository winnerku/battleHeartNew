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


/// frame:按区域切分,其他同上
+ (NSArray *)arrWithLine:(NSInteger)line
                 arrange:(NSInteger)arrange
               imageSize:(CGSize)imageSize
           subImageCount:(NSInteger)count
                   image:(UIImage *)image
           curImageFrame:(CGRect)frame;



/// 玩家搜索最近的怪物
/// @param node 玩家
+ (WDBaseNode *)searchMonsterNearNode:(WDBaseNode *)node;


/// 怪物搜索最近的玩家
/// @param node 怪物
+ (WDBaseNode *)searchUserNearNode:(WDBaseNode *)node;

@end

NS_ASSUME_NONNULL_END
