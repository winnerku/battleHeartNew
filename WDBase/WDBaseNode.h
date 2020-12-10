//
//  WDBaseNode.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "WDBaseNodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDBaseNode : SKSpriteNode

@property (nonatomic,strong)WDBaseNodeModel *model;

@property (nonatomic,strong)WDBaseNode *shadowNode;
@property (nonatomic,strong)WDBaseNode *arrowNode;


/// 移动速度
@property (nonatomic,assign)CGFloat moveSpeed;


+ (instancetype)initWithModel:(WDBaseNodeModel *)model;
- (void)setChildNodeWithModel:(WDBaseNodeModel *)model;


- (void)setBodyCanUse;


/// 设置阴影
- (void)setShadowNodeWithPosition:(CGPoint)point
                            scale:(CGFloat)scale;

/// 设置绿色箭头
- (void)setArrowNodeWithPosition:(CGPoint)point
                           scale:(CGFloat)scale;




/// 移动
- (void)moveActionWithPoint:(CGPoint)point;
/// 站立
- (void)standAction;
/// 攻击
- (void)attackAction;

@end


@interface WDUserNode : WDBaseNode

@end

@interface WDMonsterNode : WDBaseNode

@end

NS_ASSUME_NONNULL_END
