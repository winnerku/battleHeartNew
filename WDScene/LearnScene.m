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
    BOOL _canTouch;
    BOOL _firstTouch;
    int  _monsterNumber;
    BOOL _first;
    BOOL _iceAppear;
    BOOL _cure;
    BOOL _canPlay;
    int  _diedNumber;
    
    WDBaseNode *_handNode;
    WDRedBatNode *_redNode;
    int _i;
    int _redNumber;
    
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moveFinish:) name:kNotificationForMoveFinish object:nil];
    
    [self addChild:self.kNightNode];
    
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"BattleScene_1.jpg"]];
    
    self.kNightNode.position = CGPointMake(0, 0);
    self.kNightNode.zPosition = 10;

    self.kNightNode.talkNode.hidden = NO;
    self.kNightNode.talkNode.xScale = 3;
    self.kNightNode.talkNode.yScale = 3;
    self.kNightNode.talkNode.position = CGPointMake(0, self.kNightNode.realSize.height + 40);
    [self.kNightNode.talkNode setText:@"嘿，请点击我！"];
  
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
    if (_iceAppear || _cure) {
        [super touchMovedToPoint:pos];
    }
}

- (void)touchUpAtPoint:(CGPoint)pos
{
    
    if (!self.selectNode) {
        WDBaseNode *node = (WDBaseNode *)[self nodeAtPoint:pos];
        if ([node isEqualToNode:self.kNightNode]) {
            self.selectNode = self.kNightNode;
            self.selectNode.arrowNode.hidden = NO;
            [self.textureManager arrowMoveActionWithPos:CGPointMake(self.kNightNode.position.x + 400, 0)];
            [self.selectNode.talkNode setText:@"点击绿色箭头\n移动到指定位置"];
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
        _redNode.isStagger = NO;
        [super touchUpAtPoint:pos];
        [self performSelector:@selector(createIceNode) withObject:nil afterDelay:3];
    
    }else if(_iceAppear){
        
        //点击蝙蝠怪物过后显示冰女
        WDBaseNode *node = (WDBaseNode *) [self nodeAtPoint:pos];
        if ([node isEqualToNode:self.iceWizardNode]) {
           
            self.selectNode.arrowNode.hidden = YES;
            self.iceWizardNode.arrowNode.hidden = NO;
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
                [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
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
    [self createMonsterWithName:kRedBat position:CGPointMake(-100, 0)];
    _redNode = self.monsterArr[0];
    _redNode.isStagger = YES;
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

    
    [self.iceWizardNode.talkNode setText:@"请选中我，勇士！"];
    
    _redNode.paused = YES;
    self.kNightNode.paused = YES;
    _first = NO;
    _iceAppear = YES;
    
    [self addChild:self.iceWizardNode];
    self.iceWizardNode.position = CGPointMake(-200, 0);
    [self.textureManager onlyArrowWithPos:CGPointMake(self.iceWizardNode.position.x, self.iceWizardNode.realSize.height / 2.0 + 20)];

}

/// 引导手势
- (void)createHandNode{
    
    [self.iceWizardNode.talkNode setText:@"拖动手指到骑士\n为伙伴疗伤"];

    
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
- (void)diedAction
{
    for (WDBaseNode *node in self.userArr) {
        if (node.isDead) {
            node.isDead = NO;
            [node setBloodNodeNumber:-100];
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
        if (node.isDead) {
            
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
            if (_redNumber <= 8) {
                [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
            }
            break;
        }
    }
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





- (void)moveFinish:(NSNotification *)notification
{
    if (_canTouch) {
        return;
    }
    _firstTouch = NO;
    _canTouch = YES;

}







@end
