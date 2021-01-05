//
//  PubScene.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/24.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "PubScene.h"
#import "WDBaseScene+TouchLogic.h"
@implementation PubScene
{
    NSArray *_xArr;
    NSArray *_yArr;
    CADisplayLink *_mapLink;
    WDRedBatNode *_red;
    BOOL _isLearn;
    BOOL _isStoneLearn;
  
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    _isLearn = YES;

    self.bgNode.zPosition = 1;
    [self.bgNode addChild:self.iceWizardNode];
    [self.bgNode addChild:self.kNightNode];

    self.iceWizardNode.isPubScene = YES;
    
    [self createMapPosArr];
    _mapLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(mapMove)];
    [_mapLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForHiddenSkill object:nil];
    
    [self.textureManager.arrowNode removeFromParent];
    [self.textureManager.locationNode removeFromParent];
    
    [self.bgNode addChild:self.textureManager.arrowNode];
    [self.bgNode addChild:self.textureManager.locationNode];
    [self.bgNode addChild:self.archerNode];
    
    self.iceWizardNode.position = CGPointMake(1000, 300);
    self.kNightNode.position    = CGPointMake(1200, 300);
    self.kNightNode.xScale = -fabs(self.kNightNode.xScale);
    self.kNightNode.isRight = NO;
    
    [self.iceWizardNode.balloonNode setBalloonWithLine:8 hiddenTime:0];
    [self.kNightNode.balloonNode setBalloonWithLine:8 hiddenTime:0];
    
    self.archerNode.position = CGPointMake(-100, 300);
    //self.archerNode.position = CGPointMake(1000, 300);

    self.selectNode = self.archerNode;
    [self performSelector:@selector(move) withObject:nil afterDelay:1];
    
    self.iceWizardNode.isLearn = YES;
    self.kNightNode.isLearn = YES;
    self.archerNode.isLearn = YES;

    self.iceWizardNode.isPubScene = YES;
    self.kNightNode.isPubScene = YES;
    self.archerNode.isPubScene = YES;
    self.stoneNode.isPubScene = YES;
   
    self.stoneNode.shadowNode.hidden = YES;
    
    [self createStoneNode];
    
}

- (void)createStoneNode{
    self.stoneNode.position = CGPointMake(self.bgNode.size.width - 600, 400);
    NSArray *sub = [self.stoneNode.stoneModel.appearArr subarrayWithRange:NSMakeRange(3, 4)];
    SKAction *a = [SKAction animateWithTextures:sub timePerFrame:0.2];
    SKAction *r = [SKAction repeatActionForever:a];
    [self.stoneNode runAction:r];
}

- (void)move{
    __weak typeof(self)weakSelf = self;
    [self.archerNode moveActionWithPoint:CGPointMake(800, 300) moveComplete:^{
        [weakSelf.selectNode.talkNode setText:@"呦!冰妹妹~\n老大去哪里啦?" hiddenTime:2 completeBlock:^{
            
            [weakSelf.iceWizardNode.balloonNode setBalloonWithLine:5 hiddenTime:1 completeBlock:^{
                weakSelf.iceWizardNode.isRight = NO;
                weakSelf.iceWizardNode.xScale = - fabs(weakSelf.iceWizardNode.xScale);
                [weakSelf.iceWizardNode.talkNode setText:@"呸!迷路侠!\n谁是你冰妹妹!!!" hiddenTime:2 completeBlock:^{
                    [weakSelf.archerNode.balloonNode setBalloonWithLine:2 hiddenTime:1 completeBlock:^{
                        [weakSelf.archerNode.balloonNode setBalloonWithLine:5 hiddenTime:1 completeBlock:^{
                            [weakSelf.archerNode.talkNode setText:@"喂！冰妹妹！\n他是谁？" hiddenTime:2 completeBlock:^{
                                    [weakSelf.iceWizardNode.talkNode setText:@"她?是个新伙伴~\n营地里的人呢？" hiddenTime:2 completeBlock:^{
                                        [weakSelf.archerNode.talkNode setText:@"她?是妹子嘛!\n请多关照!!!" hiddenTime:2 completeBlock:^{
                                            [weakSelf createRedMonster];
                                            
                                        }];
                                    }];
                            }];
                        }];
                    }];
                }];
                
            }];
        }];
    }];
}

- (void)createRedMonster
{
   
    [self.iceWizardNode.balloonNode setBalloonWithLine:5 hiddenTime:3];
    [self.archerNode.balloonNode setBalloonWithLine:4 hiddenTime:3];
    
    self.iceWizardNode.balloonNode.complete = nil;
    self.archerNode.balloonNode.complete = nil;
    
    _red = [WDRedBatNode initWithModel:self.textureManager.redBatModel];
    _red.zPosition = 10000;
    _red.isLearn = YES;
    _red.isPubScene = YES;
    _red.xScale = 0.4;
    _red.yScale = 0.4;
    _red.talkNode.position = CGPointMake(0, _red.realSize.height + 150);
    [self.bgNode addChild:_red];
    _red.position = CGPointMake(-100, kScreenHeight * 2.0 + 100);
    __weak typeof(self)weakSelf = self;
    [_red moveActionWithPoint:CGPointMake(500, 500) moveComplete:^{
        [weakSelf.red.talkNode setText:@"你们老大啊?\n被我老大抓走了" hiddenTime:3 completeBlock:^{
            
            weakSelf.archerNode.isRight = NO;
            weakSelf.archerNode.xScale = -fabs(weakSelf.archerNode.xScale);
            
            [weakSelf.iceWizardNode.balloonNode setBalloonWithLine:1 hiddenTime:2 completeBlock:^{
                
            }];
            
            [weakSelf.archerNode.balloonNode setBalloonWithLine:1 hiddenTime:2 completeBlock:^{
                [weakSelf.archerNode.talkNode setText:@"太好了!\n不用挨骂了~" hiddenTime:1 completeBlock:^{
                    [weakSelf.iceWizardNode.talkNode setText:@"太好了!\n不用被使唤了~" hiddenTime:1 completeBlock:^{
                        [weakSelf.kNightNode.talkNode setText:@"??????\n??????" hiddenTime:1 completeBlock:^{
                            [weakSelf.red.balloonNode setBalloonWithLine:6 hiddenTime:3 completeBlock:^{
                                [weakSelf.red.talkNode setText:@"总之想要救他\n来蝙蝠领地吧!" hiddenTime:2 completeBlock:^{
                                    [weakSelf.red moveActionWithPoint:CGPointMake(-300, 2 * kScreenHeight + 100) moveComplete:^{
                                        weakSelf.archerNode.xScale = fabs(weakSelf.archerNode.xScale);
                                        weakSelf.archerNode.isRight = YES;
                                        [weakSelf.archerNode.talkNode setText:@"吐槽归吐槽~\n人还是要救的!" hiddenTime:2 completeBlock:^{
                                            [weakSelf.archerNode.talkNode setText:@"先熟悉一下营地\n随便逛一逛" hiddenTime:2 completeBlock:^{
                                                 weakSelf.selectNode = weakSelf.archerNode;
                                                     weakSelf.isLearn = NO;
                                                weakSelf.selectNode.arrowNode.hidden = NO;
                                            }];
                                        }];
                                    }];
                                }];
                                
                            }];
                        }];
                    }];
                }];
            }];
            
            [weakSelf.kNightNode.balloonNode setBalloonWithLine:1 hiddenTime:2 completeBlock:^{
                
            }];
            
        }];
    }];
}


- (void)mapMove{
    if (self.selectNode.position.x < _xArr.count && self.selectNode.position.x > 0) {
        int index = self.selectNode.position.x;
        self.bgNode.position = CGPointMake([_xArr[index]floatValue], 0);
    }
    
   // NSLog(@"%lf",self.bgNode.position.x);
}

- (void)createMapPosArr{
    
    int bigX = self.bgNode.size.width;
    //int bigY = self.size.height;
    
    NSMutableArray *xArr = [NSMutableArray array];
    for (int i = 0; i < bigX; i ++) {
        int x = i;
        if (i < kScreenWidth) {
            x = 0;
        }else if(i > bigX - kScreenWidth){
            x = - (bigX - kScreenWidth * 2.0);
        }else{
            x = - (i - kScreenWidth);
        }
        
        [xArr addObject:@(x)];
    }
    
    _xArr = xArr;
    
}


- (void)touchMovedToPoint:(CGPoint)pos
{
    
}

- (void)touchUpAtPoint:(CGPoint)pos
{
    if (_isLearn) {
        return;
    }

    if (pos.y > kScreenHeight * 2.0 - 450) {
        pos = CGPointMake(pos.x, kScreenHeight * 2.0 - 450);
    }else if(pos.y < 100){
        pos = CGPointMake(pos.x, 100);
    }
    NSLog(@"%lf",self.bgNode.size.width);
    if (pos.x < 100) {
        pos = CGPointMake(100, pos.y);
    }else if(pos.x > self.bgNode.size.width / self.bgNode.xScale - 100){
        pos = CGPointMake(self.bgNode.size.width / self.bgNode.xScale - 100, pos.y);
    }
    
     NSArray *nodes = [self.bgNode nodesAtPoint:pos];
    
     WDUserNode *userNode = nil;
     WDMonsterNode *monsterNode = nil;
     CGFloat distance = 100000;
    
     ///点击区域角色，筛选出角色坐标离选中坐标最近的点
     for (WDBaseNode *n in nodes) {
            
         CGFloat dis = [WDCalculateTool distanceBetweenPoints:pos seconde:n.position];
         if ([n isKindOfClass:[WDUserNode class]]) {
            
             if (dis < distance) {
                 userNode = (WDUserNode *)n;
                 monsterNode = nil;
                 distance = dis;
             }
             
         }
     }
     
     
    BOOL canMove = YES;
     
    if ([userNode.name isEqualToString:kStone] && !_isStoneLearn) {
        
        [self stoneClickLogic];
        _isLearn = YES;
        _isStoneLearn = YES;
        return;
    }
     
     ///首先判断是否选中的为monster
     if(userNode){
         
         //如果引导线没隐藏，添加buff效果
//         if(![self.selectNode.name isEqualToString:userNode.name] && ![userNode.name isEqualToString:kStone]){
//             //切换选中的玩家
//             canMove = [self changeSelectNode:userNode pos:pos];
//         }
         
     }
     

     
     /// 非切换目标可以移动
     if (canMove) {
         self.selectNode.targetMonster = nil;
         [self.selectNode moveActionWithPoint:pos moveComplete:^{
         }];
         [self arrowAction:pos];

     }
    
   
}


/// 选中石头人的逻辑
- (void)stoneClickLogic{
    [self.textureManager hiddenArrow];
    self.stoneNode.shadowNode.hidden = NO;
    __weak typeof(self)weakSelf = self;
    
    [self.archerNode moveActionWithPoint:CGPointMake(self.stoneNode.position.x - 300, 400) moveComplete:^{
        weakSelf.archerNode.xScale = fabs(weakSelf.selectNode.xScale);
        weakSelf.archerNode.isRight = YES;
    }];
    
    
    [self.iceWizardNode moveActionWithPoint:CGPointMake(self.stoneNode.position.x - 400, 400) moveComplete:^{
           [weakSelf stoneTalkAction];
    }];
    
    [self.kNightNode moveActionWithPoint:CGPointMake(self.stoneNode.position.x - 500, 400) moveComplete:^{
    }];
    
    [self.stoneNode removeAllActions];
    
    [self.stoneNode appearActionWithBlock:^{
        [weakSelf.stoneNode standAction];
    }];
}


- (void)stoneTalkAction{
    __weak typeof(self)weakSelf = self;
    [self.archerNode.talkNode setText:@"喂,阿石\n其他人呢?" hiddenTime:1 completeBlock:^{
        [weakSelf.stoneNode.talkNode setText:@"其他人被抓走了!\n阿石害怕!" hiddenTime:2 completeBlock:^{
            [weakSelf.iceWizardNode.talkNode setText:@"阿石不怕~\n我们保护你!" hiddenTime:1 completeBlock:^{
                [weakSelf.stoneNode.balloonNode setBalloonWithLine:3 hiddenTime:1 completeBlock:^{
                    [weakSelf.stoneNode.talkNode setText:@"阿石打开传送门\n帮助你们出发!" hiddenTime:2 completeBlock:^{
                        [weakSelf.stoneNode openDoorActionWithBlock:^{
                            [weakSelf openDoorAction];
                        }];
                    }];
                }];
            }];
        }];
    }];
}


/// 打开传送门
- (void)openDoorAction
{
   
    
    _passDoorNode.zPosition = kScreenHeight * 2.0 - _passDoorNode.position.y - 100;
//    NSArray *arr = [self.stoneNode.stoneModel.appearArr ];
    
    NSMutableArray *amaa = [NSMutableArray array];
    for (NSInteger i = self.stoneNode.stoneModel.appearArr.count - 1; i >= 0; i --) {
        [amaa addObject:self.stoneNode.stoneModel.appearArr[i]];
    }
    
    __weak typeof(self)weakSelf = self;
    [self.stoneNode.talkNode setText:@"阿石藏起来了!" hiddenTime:2 completeBlock:^{
        SKAction *apear = [SKAction animateWithTextures:amaa timePerFrame:0.1];
        SKAction *remo = [SKAction removeFromParent];
        SKAction *seq = [SKAction sequence:@[apear,remo]];
        [weakSelf.stoneNode runAction:seq completion:^{
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kPassLearn3];
            if (weakSelf.changeSceneWithNameBlock) {
                weakSelf.changeSceneWithNameBlock(@"RealPubScene");
            }
        }];
        
    }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self.bgNode]];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self.bgNode]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self.bgNode]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self.bgNode]];}
}


#pragma mark - getter -
- (WDStoneNode *)stoneNode
{
    if (!_stoneNode) {
        _stoneNode = [WDStoneNode initWithModel:self.textureManager.stoneModel];
        [self.bgNode addChild:_stoneNode];
        _stoneNode.talkNode.xScale = 1.5;
        _stoneNode.talkNode.yScale = 1.5;
        _stoneNode.talkNode.position = CGPointMake(0, _stoneNode.realSize.height - 80);
    }
    
    return _stoneNode;
}

- (WDBaseNode *)passDoorNode
{
    if (!_passDoorNode) {
        _passDoorNode = [WDBaseNode spriteNodeWithTexture:self.textureManager.passDoorArr[0]];
        _passDoorNode.alpha = 0;
        [self.bgNode addChild:_passDoorNode];
        _passDoorNode.xScale = 1.2;
        _passDoorNode.yScale = 1.2;
    }
    
    return _passDoorNode;
}

@end
