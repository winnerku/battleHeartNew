//
//  WDBaseScene.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "WDBaseNode.h"
#import "WDKinghtNode.h"
#import "WDIceWizardNode.h"


NS_ASSUME_NONNULL_BEGIN

@interface WDBaseScene : SKScene<SKPhysicsContactDelegate>

@property (nonatomic,strong)WDBaseNode *selectNode;

/// 怪物列表
@property (nonatomic,strong)NSMutableArray *monsterArr;
/// 玩家人物列表
@property (nonatomic,strong)NSMutableArray *userArr;

/// 检测周围时候有怪物需要攻击
@property (nonatomic,strong)CADisplayLink *testAttackLink;


/// 背景
@property (nonatomic,strong)SKSpriteNode *bgNode;

/// 骑士
@property (nonatomic,strong)WDKinghtNode *kNightNode;

/// 冰法师
@property (nonatomic,strong)WDIceWizardNode *iceWizardNode;




- (void)touchDownAtPoint:(CGPoint)pos;

- (void)testAttackAction:(CADisplayLink *)link;

- (void)releaseAction;


@end

NS_ASSUME_NONNULL_END
