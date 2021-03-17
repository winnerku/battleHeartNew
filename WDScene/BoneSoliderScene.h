//
//  BoneSoliderScene.h
//  BattleHeartNew
//
//  Created by Mac on 2021/3/17.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface BoneSoliderScene : WDBaseScene
@property (nonatomic,strong)WDBaseNode *boneSolider;
@property (nonatomic,strong)WDBaseNode *clickNode;
@property (nonatomic,assign)BOOL canShowClickNode;
@end

NS_ASSUME_NONNULL_END
