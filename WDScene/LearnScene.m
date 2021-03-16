//
//  LearnScene.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/11.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "LearnScene.h"
#import "WDRedBatNode.h"

@implementation LearnScene
{
    int  _monsterNumber;
    BOOL _first;
    BOOL _iceAppear;
    BOOL _cure;
    BOOL _canPlay;
    int  _diedNumber;
    BOOL _learnOver; //剧情结束
    WDBaseNode *_handNode;
    WDRedBatNode *_redNode;
    int _i;
    int _redNumber;
    
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
        
    [self.textureManager kinghtModel];
    [self.textureManager iceWizardModel];
    [self.textureManager redBatModel];
    
    [self addChild:self.kNightNode];
    
    
    self.kNightNode.position = CGPointMake(0, 0);
    self.kNightNode.zPosition = 10;
    self.kNightNode.isLearn = YES;
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"LearnScene.jpg"]];
   
    [self.kNightNode.talkNode setText:@"嘿，请点击他！"];

    self.talkBlock(@"嘿，勇士！请点击我！", kKinght);
    
    /**
     教学关整体逻辑:
     先选中骑士
     走到指定位置
     创建蝙蝠怪物
     攻击蝙蝠怪物位置
     2秒后创建冰女角色
     选中冰女
     拖动给骑士加血
     
     接下来就是正常流程游戏
     打死8个蝙蝠，教学关结束~
     */
    
}



- (void)touchMovedToPoint:(CGPoint)pos
{
    if (_learnOver) {
           return;
       }
    
    if (_iceAppear || _cure) {
        [super touchMovedToPoint:pos];
    }
}

- (void)touchUpAtPoint:(CGPoint)pos
{
    if (_learnOver) {
        return;
    }
    
    if (!self.selectNode) {
        WDBaseNode *node = (WDBaseNode *)[self nodeAtPoint:pos];
        if ([node isEqualToNode:self.kNightNode]) {
            self.selectNode = self.kNightNode;
            self.selectNode.arrowNode.hidden = NO;
            [self.textureManager arrowMoveActionWithPos:CGPointMake(self.kNightNode.position.x + 400, 0)];
            self.selectNode.talkNode.hidden = YES;
            [self.selectNode.talkNode setText:@"点击绿色箭头\n移动到指定位置"];
            //self.talkBlock(@"点击绿色箭头，移动到指定位置", kKinght);
        }
        return;
    }
    
    if (_canPlay) {
        [super touchUpAtPoint:pos];
        return;
    }
    
    if (_first) {
        

        //点击蝙蝠怪物
        WDBaseNode *node = (WDBaseNode *) [self nodeAtPoint:pos];
        if (![node isEqualToNode:_redNode]) {
            return;
        }
        
        self.kNightNode.talkNode.hidden = YES;
        _redNode.state = SpriteState_stand;
        [super touchUpAtPoint:pos];
        [self performSelector:@selector(createIceNode) withObject:nil afterDelay:3];
    
    }else if(_iceAppear){
        
        //点击蝙蝠怪物过后显示冰女
        WDBaseNode *node = (WDBaseNode *) [self nodeAtPoint:pos];
        if ([node isEqualToNode:self.iceWizardNode]) {
           
            self.selectNode.arrowNode.hidden = YES;
            self.selectNode = self.iceWizardNode;
            [self.selectNode selectSpriteAction];
            [self.textureManager hiddenArrow];
            [self createHandNode];
        }
        
        
       
    }else if(_cure){
        ///冰女治愈
        WDBaseNode *node = (WDBaseNode *) [self nodeAtPoint:pos];
        if (self.selectLine.hidden == NO) {
            if ([node isEqualToNode:self.kNightNode]) {
                [super touchUpAtPoint:pos];
                self.kNightNode.paused = NO;
                _redNode.paused = NO;
                _canPlay = YES;
                [_handNode removeFromParent];
                [_handNode removeAllActions];
                _handNode = nil;
                self.iceWizardNode.talkNode.hidden = YES;
                self.talkBlock(@"", kIceWizard);

                
            }
        }
        
        
    }else{
        
        if (_redNode) {
            return;
        }
        
        WDBaseNode *node = (WDBaseNode *) [self nodeAtPoint:pos];
        if ([node isEqualToNode:self.textureManager.arrowNode] || [node isEqualToNode:self.textureManager.locationNode]) {
            __weak typeof(self)weakSelf = self;
            [self.kNightNode moveActionWithPoint:CGPointMake(400, 0) moveComplete:^{
                [weakSelf redNode];
            }];
        }
    }
    
    self.selectLine.hidden = YES;
}

- (void)redNode{
    
    [self.selectNode.talkNode setText:@"选中蝙蝠怪物\n进行普通攻击"];
//    self.talkBlock(@"选中蝙蝠怪物，进行普通攻击", kKinght);

    [self createMonsterWithName:kRedBat position:CGPointMake(-100, 0)];
    _redNode = self.monsterArr[0];
    _redNode.state = SpriteState_stagger;
    [self.textureManager onlyArrowWithPos:CGPointMake(-100, _redNode.realSize.height / 2.0 + 80)];
    _first = YES;
}


/// 冰女出场
- (void)createIceNode{
    
    if ([self childNodeWithName:kIceWizard]) {
        return;
    }
    
    self.iceWizardNode.talkNode.hidden = NO;
    self.iceWizardNode.talkNode.xScale = 3;
    self.iceWizardNode.talkNode.yScale = 3;
    self.iceWizardNode.talkNode.position = CGPointMake(0, self.iceWizardNode.realSize.height + 40);

    
    [self.iceWizardNode.talkNode setText:@"点击选中我！"];
    //self.talkBlock(@"点击选中我！", kIceWizard);

    _redNode.paused = YES;
    self.kNightNode.paused = YES;
    _first = NO;
    _iceAppear = YES;
    self.iceWizardNode.isCure = YES;

    [self addChild:self.iceWizardNode];
    self.iceWizardNode.position = CGPointMake(-200, 0);
    [self.textureManager onlyArrowWithPos:CGPointMake(self.iceWizardNode.position.x, self.iceWizardNode.realSize.height / 2.0 + 20)];

    
}

/// 引导手势
- (void)createHandNode{
    
    [self.iceWizardNode.talkNode setText:@"拖动手指到骑士\n为伙伴疗伤"];
    //self.talkBlock(@"拖动手指到骑士，为伙伴疗伤", kIceWizard);

    
    _handNode = [WDBaseNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"hand"]]];
    _handNode.zPosition = 10000;
 
    
    [self addChild:_handNode];
    
    [self moveAAA];
    _cure = YES;
    _iceAppear = NO;
}


/// 隐藏骑士的吐槽
- (void)hiddenTalk{
    self.kNightNode.talkNode.hidden = YES;
}


/// 死亡方法复写，教学关特殊
- (void)diedAction:(NSNotification *)notification
{
    for (WDBaseNode *node in self.userArr) {
        if (node.state & SpriteState_dead) {
            [node setBloodNodeNumber:-100];
            node.state = SpriteState_stand;
            NSString *text = @"";
            if (_diedNumber == 0) {
                text = @"教学关卡的福利\n以后不要想啦~";
            }else if(_diedNumber == 1){
                text = @"怎么又死啦\n太不灵性了吧~";
            }else{
                text = @"可能有点难啊\n对于你来说~";
            }
            _diedNumber ++;
            [node.talkNode setText:text];
            node.talkNode.hidden = NO;
            node.talkNode.position = CGPointMake(0, self.kNightNode.realSize.height + 200);
            [self performSelector:@selector(hiddenTalk) withObject:nil afterDelay:3.5];
            break;
        }
    }
    
    for (WDBaseNode *node in self.monsterArr) {
        if (node.state & SpriteState_dead) {
            
            [node removeAllActions];

            SKAction *diedAction = [SKAction animateWithTextures:node.model.diedArr timePerFrame:0.1];
            SKAction *alpha = [SKAction fadeAlphaTo:0 duration:node.model.diedArr.count * 0.1];
            SKAction *gr = [SKAction group:@[diedAction,alpha]];
            SKAction *remo = [SKAction removeFromParent];
            SKAction *seq = [SKAction sequence:@[gr,remo]];
            
            [node runAction:seq completion:^{
                
            }];
            
            [node releaseAction];
            [self.monsterArr removeObject:node];
            
            _redNumber ++;
            if (_redNumber <= 1) {
                [self createMonsterWithName:kRedBat position:CGPointMake(-500, arc4random() % 300)];
            }else{
                
                
                __weak typeof(self)weakSelf = self;
                [self.kNightNode moveActionWithPoint:CGPointMake(-50, 0) moveComplete:^{
                    weakSelf.kNightNode.xScale = fabs(weakSelf.iceWizardNode.xScale);
                     weakSelf.kNightNode.isRight = YES;
                    weakSelf.kNightNode.direction = @"right";
                }];
                
                [self.iceWizardNode moveActionWithPoint:CGPointMake(200, 0) moveComplete:^{
                    weakSelf.iceWizardNode.xScale = -fabs(weakSelf.iceWizardNode.xScale);
                     weakSelf.iceWizardNode.isRight = NO;
                    weakSelf.iceWizardNode.direction = @"left";
                }];
                
                _learnOver = YES;
                self.iceWizardNode.isCure = NO;
                [self.iceWizardNode.talkNode setText:@"你是雇佣兵嘛？\n是的话请跟我来"];
                [self performSelector:@selector(yaba) withObject:nil afterDelay:1.0];
                self.iceWizardNode.bloodBgNode.hidden = YES;
                self.kNightNode.bloodBgNode.hidden = YES;
            }
            break;
        }
    }
}

- (void)yaba{
    [self.kNightNode.balloonNode setBalloonWithLine:8 hiddenTime:4];
    [self performSelector:@selector(yaba2) withObject:nil afterDelay:2];
}

- (void)yaba2{
    [self.iceWizardNode.talkNode setText:@"嘛，无所谓啦\n跟着我来吧！" hiddenTime:4];
    [self performSelector:@selector(nextScene) withObject:nil afterDelay:2];
}

- (void)nextScene{
    
    [self.iceWizardNode moveActionWithPoint:CGPointMake(kScreenWidth + 100, 0) moveComplete:^{
        
    }];
    
    __weak typeof(self)weakSelf = self;
    [self.kNightNode moveActionWithPoint:CGPointMake(kScreenWidth + 100, 0) moveComplete:^{
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kPassLearn1];
        if (weakSelf.changeSceneWithNameBlock) {
            weakSelf.changeSceneWithNameBlock(@"LearnScene2");
        }
    }];
    [self.kNightNode.balloonNode setBalloonWithLine:6 hiddenTime:10];
}


/// 递归调用治疗手势
- (void)moveAAA{
    if (!_handNode) {
        return;
    }
    _handNode.position = CGPointMake(self.iceWizardNode.position.x + 15, self.iceWizardNode.position.y - 120);
    SKAction *move = [SKAction moveTo:CGPointMake(self.kNightNode.position.x + 15, self.kNightNode.position.y - 40) duration:1.0];
    __weak typeof(self)weakSelf = self;
    [_handNode runAction:move completion:^{
        [weakSelf moveAAA];
    }];

}


- (void)releaseAction
{
    [super releaseAction];
    [self.textureManager releaseKinghtModel];
    [self.textureManager releaseIceModel];
    [self.textureManager releaseRedBatModel];
}



@end
