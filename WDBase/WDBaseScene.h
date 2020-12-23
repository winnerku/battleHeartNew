//
//  WDBaseScene.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "WDBaseNode.h"


//玩家单位
#import "WDKinghtNode.h"
#import "WDIceWizardNode.h"
#import "WDArcherNode.h"


//怪物单位
#import "WDRedBatNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDBaseScene : SKScene<SKPhysicsContactDelegate>

@property (nonatomic,strong)WDBaseNode *selectNode;


/// 纹理管理器
@property (nonatomic,strong)WDTextureManager *textureManager;

/// 怪物列表
@property (nonatomic,strong)NSMutableArray *monsterArr;
/// 玩家人物列表
@property (nonatomic,strong)NSMutableArray *userArr;
/// 跳转
@property (nonatomic,copy)void (^changeSceneWithNameBlock)(NSString *sceneName);



/// 选中的线
@property (nonatomic,strong)WDBaseNode *selectLine;

/// 背景
@property (nonatomic,strong)SKSpriteNode *bgNode;


/// 骑士
@property (nonatomic,strong)WDKinghtNode *kNightNode;
/// 冰法师
@property (nonatomic,strong)WDIceWizardNode *iceWizardNode;
/// 弓箭手
@property (nonatomic,strong)WDArcherNode *archerNode;



- (void)touchDownAtPoint:(CGPoint)pos;
- (void)touchMovedToPoint:(CGPoint)pos;
- (void)touchUpAtPoint:(CGPoint)pos;

- (void)diedAction;

- (void)releaseAction;

- (void)createMonsterWithName:(NSString *)name
                     position:(CGPoint)point;

- (void)arrowAction:(CGPoint)pos;



/// 技能
- (void)skill1Action;
- (void)skill2Action;
- (void)skill3Action;
- (void)skill4Action;
- (void)skill5Action;


@end

NS_ASSUME_NONNULL_END
