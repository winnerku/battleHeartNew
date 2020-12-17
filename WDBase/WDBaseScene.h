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




/// 选中的线
@property (nonatomic,strong)WDBaseNode *selectLine;

/// 背景
@property (nonatomic,strong)SKSpriteNode *bgNode;

/// 骑士
@property (nonatomic,strong)WDKinghtNode *kNightNode;

/// 冰法师
@property (nonatomic,strong)WDIceWizardNode *iceWizardNode;




- (void)touchDownAtPoint:(CGPoint)pos;
- (void)touchMovedToPoint:(CGPoint)pos;
- (void)touchUpAtPoint:(CGPoint)pos;

- (void)diedAction;

- (void)releaseAction;

- (void)createMonsterWithName:(NSString *)name
                     position:(CGPoint)point;


@end

NS_ASSUME_NONNULL_END
