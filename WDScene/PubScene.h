//
//  PubScene.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/24.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseScene.h"
#import "WDStoneNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface PubScene : WDBaseScene
@property (nonatomic,strong)WDRedBatNode *red;
@property (nonatomic,assign)BOOL isLearn;
@property (nonatomic,strong)WDStoneNode *stoneNode;
@property (nonatomic,strong)WDBaseNode *passDoorNode;
@end

NS_ASSUME_NONNULL_END
