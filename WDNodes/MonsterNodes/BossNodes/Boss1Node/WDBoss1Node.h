//
//  WDBoss1Node.h
//  BattleHeartNew
//
//  Created by Mac on 2021/3/10.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseNode.h"
#import "Boss1Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDBoss1Node : WDMonsterNode
@property (nonatomic,strong)Boss1Model *boss1Model;
@property (nonatomic,strong)WDBaseNode *clickNode;
@property (nonatomic,copy)void (^completeBlock)(BOOL isComplete);
- (void)moveToTheMap:(void (^)(BOOL isComplete))complete;
- (void)endAction:(void (^)(BOOL isComplete))complete;
@end

NS_ASSUME_NONNULL_END
