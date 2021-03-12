//
//  WDBaseScene+ContactLogic.h
//  BattleHeartNew
//
//  Created by Mac on 2021/3/12.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDBaseScene (ContactLogic)

- (void)contactLogicAction:(SKPhysicsContact *)contact;

@end

NS_ASSUME_NONNULL_END
