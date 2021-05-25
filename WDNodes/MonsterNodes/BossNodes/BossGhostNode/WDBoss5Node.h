//
//  WDBoss5Node.h
//  BattleHeartNew
//
//  Created by Mac on 2021/4/20.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseNode.h"
#import "Boss5Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDBoss5Node : WDMonsterNode


@property (nonatomic,assign)int blowNumber;
@property (nonatomic,assign)int bigBlowNumber;
@property (nonatomic,copy)Boss5Model *bossModel;

@end

NS_ASSUME_NONNULL_END
