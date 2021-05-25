//
//  Boss4Model.h
//  BattleHeartNew
//
//  Created by Mac on 2021/3/26.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseNodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Boss4Model : WDBaseNodeModel
@property (nonatomic,strong)SKTexture *cloudTexture;
@property (nonatomic,copy)NSArray <SKTexture *>*flashArr;
@property (nonatomic,copy)NSArray *defineArr;
@property (nonatomic,strong)SKTexture *aim;
@property (nonatomic,strong)SKTexture *aim2;
@property (nonatomic,strong)SKTexture *beAttack;

@end

NS_ASSUME_NONNULL_END
