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


/// 图片真实的显示区域
@property (nonatomic,assign)CGSize realSize;

@property (nonatomic,strong)WDBaseNodeModel *model;
/// 阴影
@property (nonatomic,strong)WDBaseNode *shadowNode;
/// 选中箭头
@property (nonatomic,strong)WDBaseNode *arrowNode;
/// 当前目标怪物
@property (nonatomic,strong)WDBaseNode *targetMonster;
/// 显示加血Node
@property (nonatomic,strong)WDBaseNode *addBloodNode;


@property (nonatomic,copy)void (^moveFinish)(void);
@property (nonatomic,assign)BOOL isAttack;
@property (nonatomic,assign)bool isMove;

/// 血量
@property (nonatomic,assign)int blood;
/// 剩余血量
@property (nonatomic,assign)int lastBlood;


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

/// 选中态，闪动一下
- (void)setSelectAction;


/// 设置攻击箭头
- (void)setAttackArrow;

/// 设置血条
/// @param attackNumber 敌人攻击力，初始化传0
- (void)setBloodNodeWithAttackNumber:(int)attackNumber;
                        

/// 移动
- (void)moveActionWithPoint:(CGPoint)point
               moveComplete:(void (^)(void))moveFinish;
/// 移动结束
- (void)moveFinishAction;
/// 站立
- (void)standAction;
/// 攻击1
- (void)attackAction1WithNode:(WDBaseNode *)enemyNode;

/// 目标怪物
- (void)setTragetMonster:(WDBaseNode *)enemNode;

@end


@interface WDUserNode : WDBaseNode

@end

@interface WDMonsterNode : WDBaseNode

@end

NS_ASSUME_NONNULL_END
