//
//  WDBalloonNode.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/18.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDBalloonNode : SKSpriteNode

@property (nonatomic,copy)void (^complete)(void);

/// 显示时间和样式
- (void)setBalloonWithLine:(NSInteger)line
                hiddenTime:(NSInteger)time;

- (void)setBalloonWithLine:(NSInteger)line
                hiddenTime:(NSInteger)time
             completeBlock:(void (^)(void))completeBlock;



/// 设置缩放和位置
- (void)setScaleAndPositionWithName:(NSString *)parentName;

@end

NS_ASSUME_NONNULL_END
