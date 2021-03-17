//
//  WDNinjaNode.h
//  BattleHeartNew
//
//  Created by Mac on 2021/3/15.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDNinjaNode : WDUserNode



// 双倍攻击，远距离瞬移
- (void)doubleAttack:(WDBaseNode *)enemyNode;
@end

NS_ASSUME_NONNULL_END
