//
//  WDTouchEndLogic.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/21.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDBaseScene.h"
NS_ASSUME_NONNULL_BEGIN

@interface WDTouchEndLogic : NSObject

+ (void)touchEndWithPoint:(CGPoint)pos
                    scene:(WDBaseScene *)scene
               selectNode:(WDBaseNode *)selectNode
                 lineNode:(WDBaseNode *)lineNode;

@end

NS_ASSUME_NONNULL_END
