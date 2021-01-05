//
//  WDKinghtNode.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/10.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDKinghtNode : WDUserNode


/// 嘲讽技能
@property (nonatomic,copy)void (^mockBlock)(void );

@end

NS_ASSUME_NONNULL_END
