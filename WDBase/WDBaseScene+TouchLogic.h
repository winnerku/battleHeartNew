//
//  WDBaseScene+TouchLogic.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/23.
//  Copyright © 2020 Macdddd. All rights reserved.
//



#import "WDBaseScene.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDBaseScene (TouchLogic)
- (BOOL)changeSelectNode:(WDBaseNode *)userNode
                     pos:(CGPoint)pos;
@end

NS_ASSUME_NONNULL_END
