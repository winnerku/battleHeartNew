//
//  WDNumberManager.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/16.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDNumberManager : NSObject
/// 根据名称初始化怪物或玩家基础数值
+ (void)initNodeValueWithName:(NSString *)name
                         node:(WDBaseNode *)node;
@end

NS_ASSUME_NONNULL_END
