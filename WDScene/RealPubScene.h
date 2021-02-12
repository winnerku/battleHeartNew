//
//  RealPubScene.h
//  BattleHeartNew
//
//  Created by Mac on 2021/1/5.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface RealPubScene : WDBaseScene
@property (nonatomic,strong)WDBaseNode *passDoorNode;

/// 选择地图
@property (nonatomic,strong)WDBaseNode *clickMapNode;

/// 学习技能
@property (nonatomic,strong)WDBaseNode *clickLearnSkillNode;
@end

NS_ASSUME_NONNULL_END
