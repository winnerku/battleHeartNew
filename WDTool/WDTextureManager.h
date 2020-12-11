//
//  WDTextureManager.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDKinghtModel.h"
#import "WDRedBatModel.h"
#import "WDIceWizardModel.h"
#import "WDBaseNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDTextureManager : NSObject

+ (WDTextureManager *)shareTextureManager;

#pragma mark - 玩家人物 -
/// 骑士
@property (nonatomic,strong)WDKinghtModel *kinghtModel;
/// 冰霜法师
@property (nonatomic,strong)WDIceWizardModel *iceWizardModel;

#pragma mark - 怪物 -
@property (nonatomic,strong)WDRedBatModel *redBatModel;



@property (nonatomic,strong)WDBaseNode *arrowNode;
@property (nonatomic,strong)WDBaseNode *locationNode;

@end

NS_ASSUME_NONNULL_END
