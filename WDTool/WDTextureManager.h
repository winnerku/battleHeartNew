//
//  WDTextureManager.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDKinghtModel.h"
#import "WDRedBatModel.h"
#import "WDIceWizardModel.h"
#import "WDArcherModel.h"
#import "WDStoneModel.h"
#import "WDBaseNode.h"
#import "Boss1Model.h"
#import "WDNinjaModel.h"
#import "WDBoneSoliderModel.h"
#import "Boss2Model.h"
#import "Boss3Model.h"
#import "Boss4Model.h"
#import "Boss5Model.h"
#import "Boss6Model.h"
#import "Boss7Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDTextureManager : NSObject

+ (WDTextureManager *)shareTextureManager;
#pragma mark - 状态 -



#pragma mark - 玩家人物 -
/// 骑士
@property (nonatomic,strong)WDKinghtModel *kinghtModel;
/// 冰霜法师
@property (nonatomic,strong)WDIceWizardModel *iceWizardModel;
/// 弓箭手
@property (nonatomic,strong)WDArcherModel *archerModel;
/// 忍者
@property (nonatomic,strong)WDNinjaModel *ninjaModel;

///NPC 石头人
@property (nonatomic,strong)WDStoneModel *stoneModel;

#pragma mark - 怪物 -
/// 蝙蝠
@property (nonatomic,strong)WDRedBatModel *redBatModel;
/// boss1 学习技能NPC
@property (nonatomic,strong)Boss1Model *boss1Model;
/// boss2 骷髅骑士
@property (nonatomic,strong)Boss2Model *boss2Model;
/// boss3 僵尸男
@property (nonatomic,strong)Boss3Model *boss3Model;
/// boss4 牛
@property (nonatomic,strong)Boss4Model *boss4Model;
/// boss5 鬼魂
@property (nonatomic,strong)Boss5Model *boss5Model;
/// boss6 狗
@property (nonatomic,strong)Boss6Model *boss6Model;
/// boss7 墨鱼
@property (nonatomic,strong)Boss7Model *boss7Model;

/// 骷髅兵
@property (nonatomic,strong)WDBoneSoliderModel *boneSoliderModel;




/** 小怪出场光效 */
@property (nonatomic,copy)NSArray <SKTexture *>*lightArr;
/** 小怪出场光效 */
@property (nonatomic,copy)NSArray <SKTexture *>*smokeArr;
/// 受伤效果
@property (nonatomic,strong)SKTexture *demageTexture;
/// 群体治疗绿光
@property (nonatomic,copy)NSArray <SKTexture *>*greenArr;
/// 点击指示
@property (nonatomic,copy)NSArray <SKTexture *>*clickArr;
/// 传送门
@property (nonatomic,copy)NSArray <SKTexture *>*passDoorArr;


/// 出发宣言。。。
@property (nonatomic,copy)NSString *goText;

#pragma mark - 场景 -
/// 指示箭头
@property (nonatomic,strong)WDBaseNode *arrowNode;
@property (nonatomic,strong)WDBaseNode *locationNode;


/// 设置怪物可以移动到玩家的位置,只有玩家当前目标，设置的randomDistanceX和randomDistanceY为0
- (void)setMonsterMovePointWithName:(NSString *)name
                            monster:(WDBaseNode *)monster;


/// 全局Link
- (void)setLinker;

/// 通用纹理
- (void)loadCommonTexture;

/// 指示箭头
/// @param pos 位置
- (void)arrowMoveActionWithPos:(CGPoint)pos;
/// 隐藏指示箭头
- (void)hiddenArrow;
/// 只显示箭头
- (void)onlyArrowWithPos:(CGPoint)pos;
/// 人物头顶上的状态
/// @param line 哪一行，参考Balloon图片
- (NSArray *)balloonTexturesWithLine:(NSInteger)line;


- (NSMutableArray *)loadWithImageName:(NSString *)name
                                count:(NSInteger)count;


#pragma mark - 逻辑 -


/// 根据地图，设置人物最高可以移动的范围Y
@property (nonatomic,assign)CGFloat mapBigY_Up;
@property (nonatomic,assign)CGFloat mapBigY_down;

@property (nonatomic,assign)CGFloat mapBigX;
@property (nonatomic,assign)CGFloat mapBigY;

/// 根据左右控制小怪位置
@property (nonatomic,assign)CGFloat redBatX;
@property (nonatomic,assign)CGFloat redBatY;


/// 释放内存
//人物
- (void)releaseKinghtModel;
- (void)releaseIceModel;
- (void)releaseArcherModel;
- (void)releaseNinjaModel;
- (void)releaseStoneModel;
- (void)releasePassWordModel;


//怪物
- (void)releaseRedBatModel;

/// boss1
- (void)releaseBoss1Model;


/// 释放资源
- (void)releaseAllModel;

@end

NS_ASSUME_NONNULL_END
