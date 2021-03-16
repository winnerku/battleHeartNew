//
//  WDStoneNode.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/28.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDStoneNode : WDUserNode

@property (nonatomic,strong)WDStoneModel *stoneModel;

- (void)appearActionWithBlock:(void (^)(void))completeBlock;
- (void)openDoorActionWithBlock:(void (^)(void))completeBlock;

- (void)standAction;
@end

NS_ASSUME_NONNULL_END
