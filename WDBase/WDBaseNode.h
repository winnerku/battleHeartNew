//
//  WDBaseNode.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "WDBaseNodeModel.h"
#import "WDTalkNode.h"
#import "WDBalloonNode.h"
NS_ASSUME_NONNULL_BEGIN

@interface WDBaseNode : SKSpriteNode


/// link
@property (nonatomic,strong)CADisplayLink *nodeLink;

/// 图片真实的显示区域
@property (nonatomic,assign)CGSize realSize;

@property (nonatomic,strong)WDBaseNodeModel *model;
/// 阴影
@property (nonatomic,strong)WDBaseNode *shadowNode;
/// 选中箭头
@property (nonatomic,strong)WDBaseNode *arrowNode;
/// 当前目标怪物
@property (nonatomic,strong)WDBaseNode *__nullable targetMonster;
/// 当前目标玩家
@property (nonatomic,strong)WDBaseNode *__nullable targetUser;

/// 血条
@property (nonatomic,strong)WDBaseNode *bloodBgNode;
/// 对话框
@property (nonatomic,strong)WDTalkNode *talkNode;
/// 表情
@property (nonatomic,strong)WDBalloonNode *balloonNode;


/// 方向: 左 又
@property (nonatomic,strong)NSString *direction;
@property (nonatomic,assign)CGFloat directionNumber;

@property (nonatomic,copy)void (^moveFinish)(void);



/// 人物与怪物之间的最小距离增加一个横向随机数，避免怪物重叠问题
@property (nonatomic,assign)CGFloat randomDistanceX;
@property (nonatomic,assign)CGFloat randomDistanceY;


/// 教学状态
@property (nonatomic,assign)BOOL isLearn;
/// 初始化中(只有在创建时候有效)
@property (nonatomic,assign)BOOL isInit;
/// 正在攻击
@property (nonatomic,assign)BOOL isAttack;
/// 正在移动
@property (nonatomic,assign)BOOL isMove;
/// 正在治疗
@property (nonatomic,assign)BOOL isCure;
/// 死亡
@property (nonatomic,assign)BOOL isDead;
/// 朝向
@property (nonatomic,assign)BOOL isRight;
/// 硬直状态
@property (nonatomic,assign)BOOL isStagger;
/// 初始地方Z坐标不一样
@property (nonatomic,assign)BOOL isPubScene;

/// 治愈量
@property (nonatomic,assign)int cureNumber;
/// 血量
@property (nonatomic,assign)int blood;
/// 剩余血量
@property (nonatomic,assign)int lastBlood;
/// 攻击距离
@property (nonatomic,assign)CGFloat attackDistance;
/// 攻击力
@property (nonatomic,assign)int attackNumber;
/// 增益或者驱散BUFF的职业(区别选中态)
@property (nonatomic,assign)BOOL addBuff;
/// 防御力 
@property (nonatomic,assign)int defense;

- (void)skill1Action;
- (void)skill2Action;
- (void)skill3Action;
- (void)skill4Action;
- (void)skill5Action;

/// 技能是否在释放状态
@property (nonatomic,assign)BOOL skill1;
@property (nonatomic,assign)BOOL skill2;
@property (nonatomic,assign)BOOL skill3;
@property (nonatomic,assign)BOOL skill4;
@property (nonatomic,assign)BOOL skill5;


/// 动画过程中的移动速度
@property (nonatomic,assign)CGFloat moveSpeed;
/// 实时的移动速度
@property (nonatomic,assign)CGFloat moveCADisplaySpeed;





+ (instancetype)initWithModel:(WDBaseNodeModel *)model;
- (void)setChildNodeWithModel:(WDBaseNodeModel *)model;


- (void)setBodyCanUse;

- (void)createLinePhyBody;


/// Link监视Node
- (void)observedNode;

/// 设置阴影
- (void)setShadowNodeWithPosition:(CGPoint)point
                            scale:(CGFloat)scale;

/// 设置绿色箭头
- (void)setArrowNodeWithPosition:(CGPoint)point
                           scale:(CGFloat)scale;


/// 选中动画 怪物和玩家实现不一样，如果特殊人物，可以定制
- (void)selectSpriteAction;

- (void)selectSpriteActionWithSelectNode:(WDBaseNode *)userNode;



///  返回 YES 说明血量没了，返回NO说明还有血
/// @param bloodNumber  敌人攻击力,也可能是牧师加血量,初始化传0
- (BOOL)setBloodNodeNumber:(int)bloodNumber;

/// 被攻击
/// @param targetNode 攻击单位
- (void)beAttackActionWithTargetNode:(WDBaseNode *)targetNode;
                        


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

/// 玩家独有的增强BUFF方法
- (void)addBuffActionWithNode:(WDBaseNode *)node;

/// 被治愈状态
- (void)beCureActionWithCureNode:(WDBaseNode *)cureNode;


/// 牧师只能治愈，直接加当前最大血量的一半
- (void)skillCureAction;

/// 销毁
- (void)releaseAction;



@end


@interface WDUserNode : WDBaseNode

@end

@interface WDMonsterNode : WDBaseNode

@end

NS_ASSUME_NONNULL_END
