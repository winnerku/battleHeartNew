//
//  WDActionTool.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/16.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDActionTool : NSObject

+ (void)demageAnimation:(WDBaseNode *)node
                  point:(CGPoint)point
                  scale:(CGFloat)scale
              demagePic:(NSString *)imageName;


+ (void)reduceBloodLabelAnimation:(WDBaseNode *)node
                      reduceCount:(CGFloat)count;



@end

NS_ASSUME_NONNULL_END
