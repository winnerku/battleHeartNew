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
#import "WDNinjaNode.h"


//怪物单位
#import "WDRedBatNode.h"
#import "WDBoneSoliderNode.h"
#import "WDBoss2Node.h"
#import "WDBoss3Node.h"
#import "WDBoss4Node.h"
#import "WDBoss5Node.h"
#import "WDBoss6Node.h"
#import "WDBoss7Node.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDBaseScene : SKScene<SKPhysicsContactDelegate>

@property (nonatomic,strong)WDBaseNode *selectNode;

/// 关卡 kPassCheckPoint%d
@property (nonatomic,copy)NSString *passStr;

/// 停止一切互动
@property (nonatomic,assign)BOOL isPauseClick;

/// 纹理管理器
@property (nonatomic,strong)WDTextureManager *textureManager;

/// 怪物列表
@property (nonatomic,strong)NSMutableArray *monsterArr;
/// 玩家人物列表
@property (nonatomic,strong)NSMutableArray *userArr;
/// 跳转
@property (nonatomic,copy)void (^changeSceneWithNameBlock)(NSString *sceneName);

/// 显示地图选择
@property (nonatomic,copy)void (^showMapSelectBlock)(void);

/// 显示技能选择
@property (nonatomic,copy)void (^showSkillSelectBlock)(NSString *userName);

/// 挂了，外边选中按钮删除
@property (nonatomic,copy)void (^diedBlock)(NSString *userName);

/// 设置对话
@property (nonatomic,copy)void (^talkBlock)(NSString *text,NSString *name);

/// 选中的线
@property (nonatomic,strong)WDBaseNode *selectLine;

/// 背景
@property (nonatomic,strong)SKSpriteNode *bgNode;

@property (nonatomic,strong)WDBaseNode *clickNode;


/// 骑士
@property (nonatomic,strong)WDKinghtNode *kNightNode;
/// 冰法师
@property (nonatomic,strong)WDIceWizardNode *iceWizardNode;
/// 弓箭手
@property (nonatomic,strong)WDArcherNode *archerNode;
/// 忍者
@property (nonatomic,strong)WDNinjaNode *ninjaNode;


/// 奖励
@property (nonatomic,strong)WDBaseNode *rewardNode;



- (void)touchDownAtPoint:(CGPoint)pos;
- (void)touchMovedToPoint:(CGPoint)pos;
- (void)touchUpAtPoint:(CGPoint)pos;

- (void)diedAction:(NSNotification *)notification;

- (void)releaseAction;

/// 创建雪
- (void)createSnowEmitter;

- (void)createMonsterWithName:(NSString *)name
                     position:(CGPoint)point;

- (void)arrowAction:(CGPoint)pos;

/// 外部选择人物
- (void)selectUserWithName:(NSString *)name;

/// 返回主城
- (void)backToRealPubScene;

/// 技能
- (void)skill1Action;
- (void)skill2Action;
- (void)skill3Action;
- (void)skill4Action;
- (void)skill5Action;


/// 死亡直接删除
/// 骑士
- (void)releaseKnightNode;

/// 弓箭手
- (void)releaseArcherNode;

/// 冰妹妹~
- (void)releaseIceWizardNode;

@end

NS_ASSUME_NONNULL_END
