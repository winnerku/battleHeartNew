//
//  WDBaseScene+CreateMonster.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/15.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDBaseScene (CreateMonster)

- (void)setSmokeWithMonster:(WDBaseNode *)monsterNode
                       name:(NSString *)nameStr;

- (void)redBatWithPosition:(CGPoint)point;
- (void)boneSoliderWithPosition:(CGPoint)point;
- (void)boneKnightWithPosition:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
