//
//  WDBoss4Node.h
//  BattleHeartNew
//
//  Created by Mac on 2021/3/26.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseNode.h"
#import "Boss4Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDBoss4Node : WDMonsterNode
@property (nonatomic,strong)Boss4Model *bossModel;
@property (nonatomic,assign)BOOL flashAttack;
@property (nonatomic,assign)BOOL stopFlashAttack;
@property (nonatomic,strong)SKEmitterNode *flashFire;
- (void)stopAim2Action;

@end

NS_ASSUME_NONNULL_END
