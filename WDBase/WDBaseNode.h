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

/// 效果：如减速、加速、双倍伤害等等
typedef NS_ENUM(NSInteger,SpriteAffect) {
    
    SpriteAffect_none     = 0,
    
    SpriteAffect_reduce   = 1 << 0,  ///0000 0000
};


typedef NS_ENUM(NSInteger,SpriteState) {
     
    /// 创建中
    SpriteState_init       = 0,      /// 0000 0000
    /// 教学or剧情状态
    SpriteState_movie      = 1 << 0, /// 0000 0001
    /// 攻击状态
    SpriteState_attack     = 1 << 1, /// 0000 0010
    /// 移动状态
    SpriteState_move       = 1 << 2, /// 0000 0100
    /// 死亡状态
    SpriteState_dead       = 1 << 3, /// 0000 1000
    /// 无敌状态
    SpriteState_invincible = 1 << 4, /// 0001 0000
    /// 站立状态
    SpriteState_stand      = 1 << 5, /// 0010 0000
    /// 硬直状态
    SpriteState_stagger    = 1 << 6, /// 0100 0000
    /// 操作中的状态
    SpriteState_operation  = 1 << 7, /// 1000 0000
    /// 风推攻击
    SpriteState_wind  = 1 << 8, /// 1000 0000

};


@interface WDBaseNode : SKSpriteNode


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
/// 正在减血，不用再放动画了
@property (nonatomic,assign)BOOL reduceBloodNow;



/// 血条
@property (nonatomic,assign)CGFloat bloodWidth;
@property (nonatomic,assign)CGFloat bloodHeight;
@property (nonatomic,assign)CGFloat bloodX; ///血条右侧的X
@property (nonatomic,assign)CGFloat bloodX_Left;
@property (nonatomic,assign)CGFloat bloodY;


/// 方向: 左 又
@property (nonatomic,strong)NSString *direction;
@property (nonatomic,assign)CGFloat directionNumber;

@property (nonatomic,copy)void (^moveFinish)(void);



/// 人物与怪物之间的最小距离增加一个横向随机数，避免怪物重叠问题
@property (nonatomic,assign)CGFloat randomDistanceX;
@property (nonatomic,assign)CGFloat randomDistanceY;

@property (nonatomic,assign)BOOL testRelease;

#pragma mark - 精灵状态
/// 精灵状态
@property (nonatomic,assign)SpriteState state;
@property (nonatomic,assign)SpriteAffect affect;
@property (nonatomic,assign)BOOL isMoveAnimation;
/// 正在治疗
@property (nonatomic,assign)BOOL isCure;
/// 朝向
@property (nonatomic,assign)BOOL isRight;
/// 初始地方Z坐标不一样
@property (nonatomic,assign)BOOL isPubScene;

#pragma mark - 精灵数值
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
/// 上下浮动的数据
@property (nonatomic,assign)int floatAttackNumber;
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

/// 动画过程中的移动速度(不会改变)
@property (nonatomic,assign)CGFloat trueMoveSpeed;
/// 动画过程中的移动速度(可能会改变)
@property (nonatomic,assign)CGFloat moveSpeed;
/// 实时的移动速度
@property (nonatomic,assign)CGFloat moveCADisplaySpeed;


+ (instancetype)initWithModel:(WDBaseNodeModel *)model;
- (void)setChildNodeWithModel:(WDBaseNodeModel *)model;


- (void)setBodyCanUse;

- (void)createLinePhyBody;

- (void)createRealSizeNode;

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


/// 同上，不过考虑破防状态
/// @param bloodNumber 攻击掉的血量
/// @param reduceDefenseNumber 破掉的防御力
- (BOOL)setBloodNodeNumber:(int)bloodNumber
       reduceDefenseNumber:(int)reduceDefenseNumber;

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
- (void)attackActionWithEnemyNode:(WDBaseNode *)enemyNode;

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


/// 创建怪物发出的攻击物体的物理尺寸
- (void)createMonsterAttackPhysicBodyWithPoint:(CGPoint)point
                                          size:(CGSize)size;



/// 设置状态
- (void)setAffectWithArr:(NSArray *)statusArr
                   point:(CGPoint)point
                   scale:(CGFloat)scale
                   count:(NSInteger)count;

@end


@interface WDUserNode : WDBaseNode

@end

@interface WDMonsterNode : WDBaseNode

@end

///这个类是用来弄一些怪物释放的招数，避免点击触碰到
@interface WDWeaponNode : WDBaseNode

@end

NS_ASSUME_NONNULL_END
