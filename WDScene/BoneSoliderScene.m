//
//  BoneSoliderScene.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/17.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "BoneSoliderScene.h"

@implementation BoneSoliderScene
{
    WDBaseNode *_boneSolider;
    WDBaseNode *_clickNode;
    BOOL _canShowClickNode;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showNinja) name:kNotificationForCallNinja object:nil];
    
    self.textureManager.mapBigY_Up = 100;
    self.textureManager.mapBigY_down = 230;
    
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"RedBatScene.png"]];
    CGFloat scale = 2 * kScreenWidth / self.bgNode.size.width;
    self.bgNode.xScale = scale;
    self.bgNode.yScale = scale;
    
    
    
    [self addChild:self.archerNode];
    [self addChild:self.kNightNode];
    [self addChild:self.iceWizardNode];
    
    self.ninjaNode.alpha = 0;
    self.ninjaNode.state = SpriteState_movie;

    self.archerNode.position = CGPointMake(0, 0);
    self.iceWizardNode.position = CGPointMake(-200, 0);
    self.kNightNode.position = CGPointMake(200, 0);
    
    self.selectNode = self.archerNode;
    self.selectNode.arrowNode.hidden = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:kArcher];
     [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForHiddenSkill object:@(1)];
//
    [self createMonsterWithName:kBoneSolider position:CGPointMake(-400, 0)];
    _boneSolider = self.monsterArr[0];
}


- (void)showNinja{
   
    self.isPauseClick = YES;
    
    NSArray *points = @[@(CGPointMake(100, 0)),@(CGPointMake(200, 0)),@(CGPointMake(300, 0)),@(CGPointMake(-100, 0))];
    int i = 0;
    for (WDUserNode *node in self.userArr) {
        [node removeAllActions];
        [NSObject cancelPreviousPerformRequestsWithTarget:node];
        node.state = SpriteState_movie;
        [node standAction];
        CGPoint point = [points[i] CGPointValue];
        [node moveActionWithPoint:point moveComplete:^{
            node.direction = @"left";
            node.isRight = NO;
            node.xScale = -fabs(node.xScale);
        }];
        
        i ++;
    }
    
    
 
    _boneSolider.state = SpriteState_movie;
    [_boneSolider removeAllActions];
    [NSObject cancelPreviousPerformRequestsWithTarget:_boneSolider];
   
    
  
        __weak typeof(self)weakSelf = self;
        [self.selectNode.talkNode setText:@"打不死的嘛？\n这破骷髅怪物" hiddenTime:3 completeBlock:^{
            
            SKAction *animation = [SKAction animateWithTextures:weakSelf.boneSolider.model.walkArr timePerFrame:0.1];
            SKAction *REP = [SKAction repeatAction:animation count:2];
            SKAction *move = [SKAction moveTo:CGPointMake(-400, 0) duration:0.8];
            [weakSelf.boneSolider runAction:[SKAction group:@[REP,move]] completion:^{
                            
            }];

            WDBaseNode *node = (WDBaseNode *)[weakSelf.boneSolider childNodeWithName:@"add"];
            [node removeAllActions];
            
            [weakSelf.boneSolider.balloonNode setBalloonWithLine:10 hiddenTime:3];
            
            [weakSelf.selectNode.talkNode setText:@"他在嘲笑我们！!" hiddenTime:2 completeBlock:^{
                [weakSelf setSmokeWithMonsterForThis:weakSelf.ninjaNode name:kNinja];
            }];
        }];
    
    
}

//烟雾出场
- (void)setSmokeWithMonsterForThis:(WDBaseNode *)monsterNode
                       name:(NSString *)nameStr
{
    
    monsterNode.state = SpriteState_movie;
    [self addChild:monsterNode];
    monsterNode.position = CGPointMake(-100, 0);
    WDBaseNode *node = [WDBaseNode spriteNodeWithTexture:self.textureManager.smokeArr[0]];
    
    node.position = monsterNode.position;
    node.zPosition = 10000;
    node.name = @"smoke";
    node.xScale = 1.5;
    node.yScale = 1.5;
    [self addChild:node];
    SKAction *lightA = [SKAction animateWithTextures:self.textureManager.smokeArr timePerFrame:0.075];
    SKAction *alphaA = [SKAction fadeAlphaTo:0.2 duration:self.textureManager.smokeArr.count * 0.075];
    SKAction *r = [SKAction removeFromParent];
    SKAction *s = [SKAction sequence:@[[SKAction group:@[lightA,alphaA]],r]];
    
    [monsterNode runAction:[SKAction fadeAlphaTo:1 duration:self.textureManager.smokeArr.count * 0.075]];
    __weak typeof(self)weakSelf = self;
    [node runAction:s completion:^{
        [weakSelf.ninjaNode.talkNode setText:@"交给在下处理\n在下拥有斩杀技" hiddenTime:3 completeBlock:^{
            
            weakSelf.boneSolider.lastBlood = 5.f;
            
            weakSelf.selectNode.arrowNode.hidden = YES;
            weakSelf.selectNode = weakSelf.ninjaNode;
            [weakSelf.selectNode selectSpriteAction];
            [[WDTextureManager shareTextureManager] hiddenArrow];
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:weakSelf.selectNode.name];
            weakSelf.selectNode.state = SpriteState_movie;
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForShowSkill object:@(0)];
            weakSelf.canShowClickNode = YES;
        }];
    }];
}

- (void)skill1Action
{
    [super skill1Action];
    if (self.canShowClickNode) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForShowSkill object:@(5)];
        self.clickNode.hidden = NO;
        self.clickNode.position = CGPointMake(self.boneSolider.position.x, self.boneSolider.position.y - 20);
        self.isPauseClick = NO;
        self.ninjaNode.attackNumber = 1000;
    }
    
}

- (void)releaseAction
{
    [super releaseAction];
    
    [self.textureManager releaseIceModel];
    [self.textureManager releaseKinghtModel];
    [self.textureManager releaseArcherModel];
    [self.textureManager releaseRedBatModel];
    [self.textureManager releaseNinjaModel];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)diedAction:(NSNotification *)notification{
    
    [super diedAction:notification];
    
    for (WDBaseNode *node in self.monsterArr) {
        if (node.state & SpriteState_dead){
            [node releaseAction];
        }
        [self.monsterArr removeObject:node];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kNinjaFirst];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kPassCheckPoint2];
        __weak typeof(self)weakSelf = self;
        [self.ninjaNode.talkNode setText:@"此地不宜久留\n先回去再说！" hiddenTime:2 completeBlock:^{
            [weakSelf backToRealPubScene];
        }];
        
        break;
    }
}

@end
