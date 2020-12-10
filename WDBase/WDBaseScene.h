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


NS_ASSUME_NONNULL_BEGIN

@interface WDBaseScene : SKScene

@property (nonatomic,strong)WDBaseNode *selectNode;


/// 背景
@property (nonatomic,strong)SKSpriteNode *bgNode;

/// 骑士
@property (nonatomic,strong)WDKinghtNode *kNightNode;





@end

NS_ASSUME_NONNULL_END
