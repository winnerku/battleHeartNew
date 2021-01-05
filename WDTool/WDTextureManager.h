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


NS_ASSUME_NONNULL_BEGIN

@interface WDTextureManager : NSObject

+ (WDTextureManager *)shareTextureManager;

#pragma mark - 玩家人物 -
/// 骑士
@property (nonatomic,strong)WDKinghtModel *kinghtModel;
/// 冰霜法师
@property (nonatomic,strong)WDIceWizardModel *iceWizardModel;
/// 弓箭手
@property (nonatomic,strong)WDArcherModel *archerModel;
///NPC 石头人
@property (nonatomic,strong)WDStoneModel *stoneModel;

#pragma mark - 怪物 -

/// 蝙蝠
@property (nonatomic,strong)WDRedBatModel *redBatModel;



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


#pragma mark - 逻辑 -


/// 根据地图，设置人物最高可以移动的范围Y
@property (nonatomic,assign)CGFloat mapBigY_Up;
@property (nonatomic,assign)CGFloat mapBigY_down;


/// 根据左右控制小怪位置
@property (nonatomic,assign)CGFloat redBatX;
@property (nonatomic,assign)CGFloat redBatY;

@end

NS_ASSUME_NONNULL_END
