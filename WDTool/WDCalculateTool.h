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


/// 最大可移动范围，不能出地图
+ (CGPoint)randomPositionWithNode:(WDBaseNode *)node;
+ (CGPoint)calculateBigPoint:(CGPoint)pos;

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

+ (NSArray *)curImageWithImage:(UIImage *)image
                          line:(NSInteger)line
                       arrange:(NSInteger)arrange
                      itemSize:(CGSize)imageSize
                         count:(NSInteger)count;


/// 计算最终减血量
/// @param attack 攻击力
/// @param floatNumber 浮动数据
+ (CGFloat)calculateReduceNumberWithAttack:(int)attack
                               floatNumber:(int)floatNumber;

/// 玩家搜索最近的怪物
/// @param node 玩家
+ (WDBaseNode *)searchMonsterNearNode:(WDBaseNode *)node;


/// 怪物搜索最近的玩家
/// @param node 怪物
+ (WDBaseNode *)searchUserNearNode:(WDBaseNode *)node;

/// 怪物搜索随机的玩家
/// @param node 怪物
+ (WDBaseNode *)searchUserRandomNode:(WDBaseNode *)node;


+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

@end

NS_ASSUME_NONNULL_END
