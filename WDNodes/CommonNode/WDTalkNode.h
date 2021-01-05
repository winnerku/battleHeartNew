//
//  WDTalkNode.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/17.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDTalkNode : SKSpriteNode

@property (nonatomic,copy)void (^complete)(void);


- (void)setText:(NSString *)text;

- (void)setText:(NSString *)text hiddenTime:(NSInteger)time;

- (void)setText:(NSString *)text
     hiddenTime:(NSInteger)time
  completeBlock:(void (^)(void))completeBlock;

@end

NS_ASSUME_NONNULL_END
