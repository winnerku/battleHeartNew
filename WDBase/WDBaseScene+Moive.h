//
//  WDBaseScene+Moive.h
//  BattleHeartNew
//
//  Created by Mac on 2021/3/17.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDBaseScene (Moive)


/// 首次救回忍者的剧情
- (void)ninjaMoive;


/// 通过关卡的奖励动画
- (void)bossDeadActionMovie;

@end

NS_ASSUME_NONNULL_END
