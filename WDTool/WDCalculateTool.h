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

+ (CGFloat)nodeDistance:(WDBaseNode *)node1
                seconde:(WDBaseNode *)node2;

+ (BOOL)nodeCanAttackWithNode:(WDBaseNode *)node1
                      seconde:(WDBaseNode *)node2;



/// 点中怪物，返回人物直接走的位置
+ (CGPoint)selectMonsterWithUserNode:(WDBaseNode *)user
                             monster:(WDBaseNode *)monster;

@end

NS_ASSUME_NONNULL_END
