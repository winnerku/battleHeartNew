//
//  RedBatScene.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/5.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "RedBatScene.h"
#import "WDBaseScene+CreateMonster.h"
#import "WDBoss1Node.h"

@implementation RedBatScene
{
    int _batNumber;
    int _bossNumber;
    WDRedBatNode *_boss;
    BOOL _bossDied;
    WDBoss1Node *_bossNode;
}



- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callAction:) name:kNotificationForCallMonster1 object:nil];
    
    self.textureManager.mapBigY_Up = 100;
    self.textureManager.mapBigY_down = 230;
    
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"RedBatScene.png"]];
    CGFloat scale = 2 * kScreenWidth / self.bgNode.size.width;
    self.bgNode.xScale = scale;
    self.bgNode.yScale = scale;
    
    [self.textureManager boss1Model];
    [self addChild:self.archerNode];
    [self addChild:self.kNightNode];
    [self addChild:self.iceWizardNode];
    
    self.archerNode.position = CGPointMake(0, 0);
    self.iceWizardNode.position = CGPointMake(-200, 0);
    self.kNightNode.position = CGPointMake(200, 0);
    
    self.selectNode = self.archerNode;
    self.selectNode.arrowNode.hidden = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:kArcher];
     [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForHiddenSkill object:@(1)];
    
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];

    [self createSnowEmitter];

    _batNumber = 4;
    _bossNumber = 15;
 //   [self createBoss2];
   
}

- (void)callAction:(NSNotification *)notification
{
    [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
}

- (void)diedAction:(NSNotification *)notification{
    
    [super diedAction:notification];
    
    for (WDBaseNode *node in self.userArr) {
        if (node.state & SpriteState_dead) {
            
            [self.userArr removeObject:node];
            [node releaseAction];
            
            if ([node.name isEqualToString:self.selectNode.name]) {
                self.selectNode = self.userArr.firstObject;
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:self.selectNode.name];
                [self.selectNode selectSpriteAction];
            }
            
            
            if (self.userArr.count == 0) {
                if (_boss) {
                    self.textureManager.goText = @"再接再厉吧\n记得多走位!";
                    //被boss杀干净
                    __weak typeof(self)weakSelf = self;
                    if (_boss.state & SpriteState_dead) {
                       
                        for (WDBaseNode *node in self.monsterArr) {
                            [node releaseAction];
                        }
                        [self.monsterArr removeAllObjects];
                        
                        [_bossNode removeAllActions];
                        _bossNode.colorBlendFactor = 0;
                        [NSObject cancelPreviousPerformRequestsWithTarget:_bossNode];
                        SKAction *moveAn = [SKAction animateWithTextures:_bossNode.boss1Model.walkArr timePerFrame:0.1];
                        SKAction *move = [SKAction moveTo:CGPointMake(0, 0) duration:_bossNode.boss1Model.walkArr.count * 0.1];
                        SKAction *gr = [SKAction group:@[moveAn,move]];
                        __weak typeof(self)weakSelf = self;
                        [_bossNode runAction:gr completion:^{
                            [weakSelf noPassForBoss2];
                        }];
                        
                    }else{
                        [_boss.talkNode setText:@"还差得远呢\nMADAMADA!" hiddenTime:2 completeBlock:^{
                            if (weakSelf.changeSceneWithNameBlock) {
                                weakSelf.changeSceneWithNameBlock(@"RealPubScene");
                            }
                        }];
                    }
                    
                }else{
                    //被小怪杀干净
                    self.textureManager.goText = @"再接再厉吧\n记得多走位!";
                    [self performSelector:@selector(changeActionForMonster:) withObject:@"RealPubScene" afterDelay:2];
                }
            }
            
            break;
        }
    }
    
    for (WDBaseNode *node in self.monsterArr) {
        if (node.state & SpriteState_dead) {
            
            if ([node.name isEqualToString:kBoss1]) {
                for (WDBaseNode *user in self.userArr) {
                    user.state = SpriteState_movie;
                }
                
                for (WDBaseNode *node in self.monsterArr) {
                    [node releaseAction];
                }
                [self.monsterArr removeAllObjects];
                
                __weak typeof(self)weakSelf = self;
                [_bossNode endAction:^(BOOL isComplete) {
                    if (isComplete) {
                        [weakSelf changeActionForMonster:@"RealPubScene"];
                    }
                }];
                return;
            }
            
            [node releaseAction];
            [self.monsterArr removeObject:node];
            
            if ([node.name isEqualToString:@"boss"]) {
                _bossDied = YES;
                [self createBoss2];
            }
            
            
            if (self.monsterArr.count == 0 && !_bossDied) {
                [self createBoss];
            }
            
            if (_boss) {
                break;
            }
            
            _batNumber ++;
            if (_batNumber <= _bossNumber) {
                [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
            }
            
            break;
        }
    }
    
}

- (void)noPassForBoss2{
    SKAction *animation = [SKAction animateWithTextures:_bossNode.boss1Model.winArr timePerFrame:0.15];
    [_bossNode.talkNode setText:@"你们还不够格哦"];
    __weak typeof(self)weakSelf = self;
    [_bossNode runAction:animation completion:^{
        [weakSelf changeActionForMonster:@"RealPubScene"];
    }];
}

- (void)changeActionForMonster:(NSString *)sceneName{
   
    if (self.changeSceneWithNameBlock) {
        self.changeSceneWithNameBlock(sceneName);
    }
}

- (void)createBoss2{
    
    for (WDBaseNode *node in self.userArr) {
        node.state = SpriteState_movie;
    }
    
    _bossNode = [WDBoss1Node initWithModel:self.textureManager.boss1Model];
    _bossNode.state = SpriteState_movie;
    [self addChild:_bossNode];
    [self.monsterArr addObject:_bossNode];
    
    __weak typeof(self)weakSelf = self;
    [_bossNode moveToTheMap:^(BOOL isComplete) {
        for (WDBaseNode *node in weakSelf.userArr) {
            node.state = SpriteState_stand;
        }
    }];
}

- (void)createBoss{
    _boss = [WDRedBatNode initWithModel:[WDTextureManager shareTextureManager].redBatModel];
    _boss.xScale = 0.8;
    _boss.yScale = 0.8;
    _boss.attackNumber = 50;
    _boss.alpha = 0;
    _boss.blood = 500;
    _boss.lastBlood = 500;
    _boss.name = @"boss";
    _boss.isBoss = YES;
    _boss.realSize = CGSizeMake(_boss.size.width - 80, _boss.size.height - 10);
    [self.monsterArr addObject:_boss];
    [self addChild:_boss];
    
    _boss.position = CGPointMake(kScreenWidth - 300, -100);
    
    
    [self setSmokeWithMonster:_boss name:kRedBat];
    [self performSelector:@selector(bossAppear) withObject:nil afterDelay:self.textureManager.smokeArr.count * 0.075 + 0.1];
}

- (void)bossAppear
{
    [_boss.talkNode setText:@"想要救你老大\n先弄死我再说!" hiddenTime:2 completeBlock:^{
    }];
}

- (void)releaseAction
{
    [super releaseAction];
     
    _boss = nil;
    _bossNode = nil;
    
    [self.textureManager releaseIceModel];
    [self.textureManager releaseKinghtModel];
    [self.textureManager releaseArcherModel];
    [self.textureManager releaseRedBatModel];
    [self.textureManager releaseBoss1Model];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)dealloc
{
    NSLog(@"111");
}

@end
