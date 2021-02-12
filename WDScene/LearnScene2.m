//
//  LearnScene2.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/18.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "LearnScene2.h"

@implementation LearnScene2
{
    ///是否还在教学状态
    BOOL _isLearn;
    BOOL _isOver;
    WDBaseNode *_clickNode;
    int _foot;
    WDRedBatNode *_redNode;
    int _diedNumber;
    int _batNumber;
    BOOL _foot3;
}

- (void)diedAction{
    
    for (WDBaseNode *node in self.userArr) {
        if (node.isDead) {
            node.isDead = NO;
            [node setBloodNodeNumber:-100];
            NSString *text = @"";
            if (_diedNumber == 0) {
                text = @"教学关卡的福利\n以后不要想啦~";
            }else if(_diedNumber == 1){
                text = @"怎么又死啦\n太不灵性了吧~";
            }else if(_diedNumber){
                text = @"可能有点难啊\n对于你来说~";
            }else{
                text = @"你可真太弱了\n无力吐槽了~";
            }
            _diedNumber ++;
            [node.talkNode setText:text hiddenTime:2];
            break;
        }
    }
    
    for (WDBaseNode *node in self.monsterArr) {
        if (node.isDead) {
            [node releaseAction];
            [self.monsterArr removeObject:node];
            _batNumber ++;
            if (_batNumber == 6) {
                [self.archerNode.talkNode setText:@"这破蝙蝠啊~\n是杀不完的嘛？"hiddenTime:3];
            }
            if (_batNumber <=8) {
                [self createMonsterWithName:kRedBat position:CGPointMake(0, 0)];
            }
            
            if (self.monsterArr.count == 0) {
                _isOver = YES;
                [self.archerNode.talkNode setText:@"终于杀干净，\n可以喘口气了" hiddenTime:2];
                __weak typeof(self)weakSelf = self;
                [self.archerNode moveActionWithPoint:CGPointMake(0, 0) moveComplete:^{
                    [weakSelf next];
                }];
            }
            
            break;
        }
    }
}

- (void)next{
    [self.archerNode.balloonNode setBalloonWithLine:1 hiddenTime:3];
    [self performSelector:@selector(next2) withObject:nil afterDelay:3];
}

- (void)next2{
    [self.archerNode.talkNode setText:@"啊！要赶紧回去\n不然要被骂死！" hiddenTime:5];
    __weak typeof(self)weakSelf = self;
    [self.archerNode moveActionWithPoint:CGPointMake(kScreenWidth + 200, 0) moveComplete:^{
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kPassLearn2];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForHiddenSkill object:@(0)];
        if (weakSelf.changeSceneWithNameBlock) {
            weakSelf.changeSceneWithNameBlock(@"PubScene");
        }
    }];
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    [self.textureManager arrowNode];
    [self.textureManager redBatModel];
    
    [self addChild:self.archerNode];
    _foot3 = YES;
    _isLearn = YES;
    _batNumber = 3;
    self.archerNode.position = CGPointMake(-kScreenWidth, 0);
    self.bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"LearnScene.jpg"]];
    [self performSelector:@selector(a) withObject:nil afterDelay:1];

}

- (void)a{
    [self.archerNode.talkNode setText:@"真是伤脑筋啊\n我是迷路了嘛？"];
    self.archerNode.isInit = YES;
    __weak typeof(self)weakSelf = self;
    [self.archerNode moveActionWithPoint:CGPointMake(-350, 0) moveComplete:^{
        [weakSelf clickNode].hidden = NO;
        [weakSelf clickNode].position = CGPointMake(weakSelf.archerNode.position.x, weakSelf.archerNode.position.y - 100);
    }];
}


- (void)touchDownAtPoint:(CGPoint)pos
{
    
    
    
}

- (void)touchMovedToPoint:(CGPoint)pos
{
    
}

- (void)touchUpAtPoint:(CGPoint)pos
{
    if (_isOver) {
        return;
    }
    if (_isLearn) {
        
       
            //第一步
            if (_foot == 0) {
                CGFloat distanceX = fabs(self.archerNode.position.x - pos.x);
                CGFloat distanceY = fabs(self.archerNode.position.y - pos.y);
                //创建的图片比实际显示图片要大
                if (distanceX < self.archerNode.realSize.width / 2.0 && distanceY < self.archerNode.realSize.height / 2.0) {
                    ///切换选中目标，不能移动
                    self.selectNode.arrowNode.hidden = YES;
                    self.archerNode.arrowNode.hidden    = NO;
                    self.selectNode = self.archerNode;
                    [self.selectNode selectSpriteAction];
                    [[WDTextureManager shareTextureManager] hiddenArrow];
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:self.selectNode.name];
                    [self.archerNode.talkNode setText:@"在不回去交差\n又要挨头儿骂！"];
                    [self createMonsterWithName:kRedBat position:CGPointMake(1, 0)];
                    [self createMonsterWithName:kRedBat position:CGPointMake(200, 0)];
                    [self createMonsterWithName:kRedBat position:CGPointMake(400, 0)];

                    for (WDMonsterNode *node in self.monsterArr) {
                        node.isLearn = YES;
                        _redNode = node;
                    }
                    
                    _foot ++;
                }
            }else if (_foot == 1) {
                [self.archerNode.talkNode setText:@"突然出现怪物\n先弄死再说！" hiddenTime:2];
                [self clickNode].hidden = YES;
                [self.textureManager onlyArrowWithPos:CGPointMake(400, _redNode.realSize.height / 2.0 + 80)];
                _foot ++;
            }else if(_foot == 2){
                CGFloat distanceX = fabs(_redNode.position.x - pos.x);
                CGFloat distanceY = fabs(_redNode.position.y - pos.y);
                if (distanceX < _redNode.realSize.width / 2.0 && distanceY < _redNode.realSize.height / 2.0) {
                    [_redNode selectSpriteAction];
                    _foot ++;
                    self.archerNode.targetMonster = _redNode;
                    [self.archerNode attackAction1WithNode:_redNode];
                    [self.textureManager hiddenArrow];
                    [self clickNode].hidden = NO;
                }
                
            }else if(_foot == 3 && _foot3){
                
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForHiddenSkill object:@(1)];
                [self.archerNode.talkNode setText:@"怪物有点多~\n可以释放技能!" hiddenTime:2];
                [self performSelector:@selector(talkAction) withObject:nil afterDelay:2];
                //[self clickNode].hidden = YES;

                _foot3 = NO;
            }else if(_foot > 3){
                [self talkAction];
            }
            
        
        
        
    }else{
        [super touchUpAtPoint:pos];
    }
}

- (void)talkAction{
    _foot ++;
    //[self clickNode].hidden = YES;
    NSNotificationCenter *po = [NSNotificationCenter defaultCenter];
    if (_foot == 4) {
        [self.archerNode.talkNode setText:@"第一个技能\n增加攻击速度"];
        //[self performSelector:@selector(talkAction) withObject:nil afterDelay:3];
        [po postNotificationName:kNotificationForShowSkill object:@(0)];
    }else if(_foot == 5){
        [self.archerNode.talkNode setText:@"想要其它技能\n要找小姐姐学"];
        //[self performSelector:@selector(talkAction) withObject:nil afterDelay:3];
        //[po postNotificationName:kNotificationForShowSkill object:@(1)];
    }else if(_foot == 6){
        [self.archerNode.talkNode setText:@"具体如何使用\n实战中体会吧~" hiddenTime:3];
        for (WDMonsterNode *node in self.monsterArr) {
            node.isLearn = NO;
        }
        _isLearn = NO;
        self.archerNode.isLearn = NO;
        self.archerNode.isInit = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForSkillCanUse object:nil];
        [po postNotificationName:kNotificationForShowSkill object:@(5)];
        [self clickNode].hidden = YES;
    }
}

- (WDBaseNode *)clickNode{
    if (!_clickNode) {
        _clickNode = [WDBaseNode spriteNodeWithTexture:self.textureManager.clickArr[0]];
        _clickNode.hidden = YES;
        [self addChild:_clickNode];
        _clickNode.zPosition = 10000;
        SKAction *an = [SKAction animateWithTextures:self.textureManager.clickArr timePerFrame:0.5];
        SKAction *re = [SKAction repeatActionForever:an];
        [_clickNode runAction:re];
    }
    
    return _clickNode;
}

- (void)releaseAction
{
    [super releaseAction];
    [self.textureManager releaseRedBatModel];
    [self.textureManager releaseArcherModel];
}

@end
