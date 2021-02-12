//
//  RedBatScene.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/5.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "RedBatScene.h"
#import "WDBaseScene+CreateMonster.h"

@implementation RedBatScene
{
    int _batNumber;
    WDRedBatNode *_boss;
    BOOL _bossDied;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.textureManager.mapBigY_Up = 100;
    self.textureManager.mapBigY_down = 230;
    
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"RedBatScene.png"]];
    CGFloat scale = 2 * kScreenWidth / self.bgNode.size.width;
    self.bgNode.xScale = scale;
    self.bgNode.yScale = scale;
    
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
    //[self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
    //[self createBoss];
    
    _batNumber = 3;
}

- (void)diedAction{
    
    for (WDBaseNode *node in self.userArr) {
        if (node.isDead) {
            [node releaseAction];
            [self.userArr removeObject:node];
           
            if (self.userArr.count == 0) {
                if (_boss) {
                    //被boss杀干净
                    __weak typeof(self)weakSelf = self;
                    __block WDRedBatNode *bo = _boss;
                    self.textureManager.goText = @"BOSS攻击挺高\n试试风筝!";
                    [_boss.talkNode setText:@"小菜鸡们\n在练练吧!" hiddenTime:2 completeBlock:^{
                        if (weakSelf.changeSceneWithNameBlock) {
                            weakSelf.changeSceneWithNameBlock(@"RealPubScene");
                        }
                        [bo releaseAction];
                        [weakSelf.monsterArr removeObject:bo];
                    }];
                }else{
                    //被小怪杀干净
                    self.textureManager.goText = @"小怪都打不过\n在练练吧!";
                    if (self.changeSceneWithNameBlock) {
                        self.changeSceneWithNameBlock(@"RealPubScene");
                    }
                    
                    for (WDBaseNode *node in self.monsterArr) {
                        [node releaseAction];
                    }
                    
                    [self.monsterArr removeAllObjects];
                }
            }
            
            break;
        }
    }
    
    for (WDBaseNode *node in self.monsterArr) {
        if (node.isDead) {
            [node releaseAction];
            [self.monsterArr removeObject:node];
            _batNumber ++;
            if (_batNumber <= 3) {
                [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
            }
            
            if ([node.name isEqualToString:@"boss"]) {
                _bossDied = YES;
                NSLog(@"结束咯~");
            }
            
            if (self.monsterArr.count == 0 && !_bossDied) {
                [self createBoss];
            }
            
            break;
        }
    }
    
}

- (void)createBoss{
    _boss = [WDRedBatNode initWithModel:[WDTextureManager shareTextureManager].redBatModel];
    _boss.xScale = 0.8;
    _boss.yScale = 0.8;
    _boss.attackNumber = 50;
    _boss.alpha = 0;
    _boss.blood = 1000;
    _boss.lastBlood = 1000;
    _boss.name = @"boss";
    _boss.isBoss = YES;
    _boss.realSize = CGSizeMake(_boss.size.width - 80, _boss.size.height - 10);
    [self.monsterArr addObject:_boss];
    [self addChild:_boss];
    
    _boss.isInit = YES;
    _boss.position = CGPointMake(kScreenWidth - 300, -100);
    
    
    self.archerNode.isInit = YES;
    self.kNightNode.isInit = YES;
    self.isPauseClick = YES;
    
    [self setSmokeWithMonster:_boss name:kRedBat];
    [self performSelector:@selector(bossAppear) withObject:nil afterDelay:self.textureManager.smokeArr.count * 0.075 + 0.1];
}

- (void)bossAppear
{
    _boss.isInit = YES;
    __block WDRedBatNode *node = _boss;
    __weak typeof(self)weakSelf = self;
    [_boss.talkNode setText:@"想要救你老大\n先弄死我再说!" hiddenTime:2 completeBlock:^{
        node.isInit = NO;
        weakSelf.kNightNode.isInit = NO;
        weakSelf.archerNode.isInit = NO;
        weakSelf.isPauseClick = NO;
    }];
}

- (void)releaseAction
{
    [super releaseAction];
    
    [self.textureManager releaseIceModel];
    [self.textureManager releaseKinghtModel];
    [self.textureManager releaseArcherModel];
    [self.textureManager releaseRedBatModel];
}

@end
