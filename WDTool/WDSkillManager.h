//
//  WDSkillManager.h
//  BattleHeartNew
//
//  Created by Mac on 2021/3/12.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface WDSkillManager : NSObject


/// 技能持续时间结束
+ (void)endSkillActionWithTarget:(WDBaseNode *)targetNode
                       skillType:(NSString *)skillType
                            time:(NSInteger)time;



@end

NS_ASSUME_NONNULL_END
