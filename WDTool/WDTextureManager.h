//
//  WDTextureManager.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDKinghtModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDTextureManager : NSObject

+ (WDTextureManager *)shareTextureManager;

@property (nonatomic,strong)WDKinghtModel *kinghtModel;

@end

NS_ASSUME_NONNULL_END
