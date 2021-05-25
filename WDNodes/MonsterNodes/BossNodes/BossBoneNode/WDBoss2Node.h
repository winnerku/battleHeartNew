//
//  WDBoss2Node.h
//  BattleHeartNew
//
//  Created by Mac on 2021/3/19.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDBoss2Node : WDMonsterNode
@property (nonatomic,assign)BOOL isIceAttackIng;
@property (nonatomic,assign)BOOL isRush;
@property (nonatomic,strong)SKEmitterNode *doubleKill;
@property (nonatomic,assign)int iceAttackNumber;


@end

NS_ASSUME_NONNULL_END
