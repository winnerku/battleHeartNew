//
//  LearnSkillNode.h
//  BattleHeartNew
//
//  Created by Mac on 2021/1/6.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseNode.h"
#import "SkillModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LearnSkillNode : SKSpriteNode

@property (nonatomic,strong)SkillModel *model;
@property (nonatomic,assign)BOOL isStand;
- (void)standAction;
- (void)stayAction;
@end

NS_ASSUME_NONNULL_END
