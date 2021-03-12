//
//  WDBaseNode.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseNode.h"

static CGFloat bloodPage = 0;
static CGFloat bloodHeight = 40;


@interface WDBaseNode ()

@property (nonatomic,strong)WDBaseNode *bloodNode;

@end

@implementation WDBaseNode

- (void)dealloc
{
//    NSLog(@"%@",self.kNightNode);
    //NSLog(@"%@销毁了~",self.name);
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    return [[WDBaseNode alloc] init];
}

- (void)createRealSizeNode{
//    SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[[UIColor orangeColor]colorWithAlphaComponent:0.7] size:self.realSize];
//    node.zPosition = 100;
//    [self addChild:node];
}
- (void)setChildNodeWithModel:(WDBaseNodeModel *)model{
    
    self.isRight = YES;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observedNode) name:kNotificationForDisplayLink object:nil];
    
    ///血条总是一个朝向
    [self addObserver:self forKeyPath:@"isRight" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
- (void)selectSpriteAction{}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //NSLog(@"%@ \n%@ \n%@",object,keyPath ,change);
   
    if ([keyPath isEqualToString:@"isRight"]) {
        BOOL isRight = [change[@"new"]boolValue];
        if (isRight) {
            self.directionNumber = 1;
           self.bloodBgNode.xScale = 1;
           self.bloodBgNode.position = CGPointMake(-self.bloodBgNode.size.width / 2.0, self.bloodBgNode.position.y);
            self.talkNode.xScale = fabs(self.talkNode.xScale);
        }else{
            if ([self.name isEqualToString:kRedBat]) {
                //NSLog(@"1");
            }
            self.directionNumber = -1;
            self.bloodBgNode.xScale = -1;
            self.bloodBgNode.position = CGPointMake(self.bloodBgNode.size.width / 2.0, self.bloodBgNode.position.y);
            self.talkNode.xScale = -fabs(self.talkNode.xScale);
        }
    }
    
}

/// 目前只监测zPosition,血条
- (void)observedNode{
    if (self.isPubScene) {
        int z = 2 * kScreenHeight - self.position.y;
        self.zPosition = z;
    }else{
        self.zPosition = [WDCalculateTool calculateZposition:self];
    }
}

- (void)setBodyCanUse
{
    self.physicsBody.categoryBitMask    = LINE_CATEGORY;
    self.physicsBody.collisionBitMask   = LINE_COLLISION;
    self.physicsBody.contactTestBitMask = LINE_CONTACT;
}

- (void)createLinePhyBody
{
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:self.size center:CGPointMake(self.size.width / 2.0, self.size.height / 2.0)];
    self.physicsBody = body;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
    
    [self setBodyCanUse];
}



- (void)beAttackActionWithTargetNode:(WDBaseNode *)targetNode
{
    //NSLog(@"%@被%@攻击了",self.name,targetNode.name);
}

- (void)noBlood{
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForDied object:self.name];
}

/// 加减血量
- (BOOL)setBloodNodeNumber:(int)bloodNumber
{
    if (self.state & SpriteState_dead && bloodNumber > 0) {
        [self noBlood];
        return YES;
    }
    
    [WDActionTool reduceBloodLabelAnimation:self reduceCount:bloodNumber];

    [self bloodNode];
    BOOL isAddBlood = NO;
    if (bloodNumber > 0) {
        isAddBlood = NO;
    }else{
        isAddBlood = YES;
    }
    
    /*
     attackNumber 为负数的时候说明是加血，为正数的
     */
    
    /// 满血状态
    if (isAddBlood && _lastBlood == _blood) {
        self.bloodBgNode.alpha = 0;
        return NO;
    }
    
    self.bloodBgNode.alpha = 1;

    CGFloat last = _lastBlood;
    if (bloodNumber >= _lastBlood) {
        bloodNumber = _lastBlood;
    }
    _lastBlood = _lastBlood - bloodNumber;
    if (_lastBlood > _blood) {
        
        //加满的份额
        bloodNumber = _blood - last;
        _lastBlood = _blood;
    }
    
    /// 没有血的状态
    if ( !isAddBlood && _lastBlood <= 0) {
        self.state = SpriteState_dead;
        [self reduceAnimation:bloodNumber];
        ///这里这样处理是因为先走了死亡的处理之后又走的通知
        [self performSelector:@selector(noBlood) withObject:nil afterDelay:0];
        return YES;
    }
    
    
    CGFloat percent = (float)_lastBlood / (float)_blood;
    if (_lastBlood <= 0) {
        percent = 0;
    }
    
    if(bloodNumber == 0){
        //开场设置血线
        CGFloat width = fabs(self.bloodBgNode.size.width * percent);
        self.bloodNode.size = CGSizeMake(width, self.bloodHeight - bloodPage * 2.0);
        self.bloodBgNode.alpha = 0;

    }else if (isAddBlood) {
        
        //加血动画
        [self addBloodAnimation:bloodNumber];
       
    }else{
        
        //减血动画
        [self reduceAnimation:bloodNumber];
        [self beAttackActionWithTargetNode:nil];
       
    }
    
    return NO;
}


/// 减血动画
- (void)reduceAnimation:(int)attackNumber
{
    UIColor *color = UICOLOR_RGB(124, 42, 42, 1);
    CGFloat percent = (float)_lastBlood / (float)_blood;
    if (_lastBlood <= 0) {
        percent = 0;
    }
    
    CGFloat width = fabs(self.bloodBgNode.size.width * percent);
       
    
    //攻击掉血百分比
    CGFloat attackPercent = (float)attackNumber / (float)_blood;
    CGFloat reduceWidth = fabs(self.bloodBgNode.size.width * attackPercent);
       
    self.bloodNode.size = CGSizeMake(width, self.bloodHeight - bloodPage * 2.0);
    
    WDBaseNode *reduce = [WDBaseNode spriteNodeWithColor:color size:CGSizeMake(reduceWidth, self.bloodHeight - bloodPage * 2.0)];
    reduce.zPosition = 1;
    reduce.position = CGPointMake(width,0);
    reduce.anchorPoint = CGPointMake(0, 0);
    [self.bloodNode addChild:reduce];
    
     
    SKAction *size = [SKAction scaleToSize:CGSizeMake(0, self.bloodHeight - bloodPage * 2.0) duration:0.15];
    SKAction *remo = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[size,remo]];
    [reduce runAction:seq];
    
    if (!self.reduceBloodNow) {
        self.reduceBloodNow = YES;
        //减血闪动
        SKAction *a = nil;
        if ([self.name isEqualToString:kRedBat]) {
           a = [SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:0.7 duration:0.15];
        }else{
           a = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:0.7 duration:0.15];
        }
        
        SKAction *b = [SKAction colorizeWithColorBlendFactor:0 duration:0.15];
        SKAction *seq2 = [SKAction sequence:@[a,b]];
        SKAction *rep = [SKAction repeatAction:seq2 count:1];
               
        __weak typeof(self)weakSelf = self;
        [self runAction:rep completion:^{
            weakSelf.reduceBloodNow = NO;
        }];
    }
    
    
}

/// 加血动画
- (void)addBloodAnimation:(int)attackNumber
{
    UIColor *color = UICOLOR_RGB(255, 215, 0, 1);
    CGFloat percent = (float)_lastBlood / (float)_blood;
    if (_lastBlood <= 0) {
        percent = 0;
    }
    
    CGFloat width = fabs(self.bloodBgNode.size.width * percent);
          
    //加血百分比
    CGFloat attackPercent = (float)attackNumber / (float)_blood;
    CGFloat reduceWidth = fabs(self.bloodBgNode.size.width * attackPercent);
    
    WDBaseNode *add = [WDBaseNode spriteNodeWithColor:color size:CGSizeMake(1, self.bloodHeight - bloodPage * 2.0)];
    add.zPosition = 1;
    add.position = CGPointMake(self.bloodNode.size.width,0);
    add.anchorPoint = CGPointMake(0, 0);
    [self.bloodNode addChild:add];
    
        
    SKAction *size = [SKAction scaleToSize:CGSizeMake(reduceWidth, self.bloodHeight - bloodPage * 2.0) duration:0.15];
    SKAction *remo = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[size,remo]];
    __weak typeof(self)weakSelf = self;
    [add runAction:seq completion:^{
        weakSelf.bloodNode.size = CGSizeMake(width, self.bloodHeight - bloodPage * 2.0);
        //weakSelf.bloodNode.position = CGPointMake(0, 0);
    }];
    
    
    
    //加血闪动
    SKAction *a = [SKAction colorizeWithColor:[UIColor greenColor] colorBlendFactor:0.7 duration:0.15];
    SKAction *b = [SKAction colorizeWithColorBlendFactor:0 duration:0.15];
    SKAction *seq2 = [SKAction sequence:@[a,b]];
    SKAction *rep = [SKAction repeatAction:seq2 count:1];
             
    [self runAction:rep];
    
}


#pragma mark - 行为 -
/// 站立
- (void)standAction
{
    if (self.lastBlood <= 0) {
        return;
    }
    if (self.state & SpriteState_movie) {
        self.state = SpriteState_stand | SpriteState_movie;
    }else{
        self.state = SpriteState_stand;
    }
    
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(moveFinishAction) object:nil];
    [self removeAllActions];
    self.reduceBloodNow = NO;
    self.colorBlendFactor = 0;
    SKAction *stand = [SKAction animateWithTextures:self.model.standArr timePerFrame:0.1];
    SKAction *rep = [SKAction repeatActionForever:stand];
    [self runAction:rep withKey:@"stand"];
    
}


/// 加血
- (void)addBuffActionWithNode:(WDBaseNode *)node
{
   
}


/// 攻击
- (void)attackActionWithEnemyNode:(WDBaseNode *)enemyNode
{
    self.colorBlendFactor = 0;
    self.state = SpriteState_attack | self.state;
  
    CGFloat distance = enemyNode.position.x - self.position.x;
    if (distance < 0) {
        self.xScale = -fabs(self.xScale);
        self.direction = @"left";
        self.isRight = NO;
    }else{
        self.xScale = +fabs(self.xScale);
        self.direction = @"right";
        self.isRight = YES;
    }
   
}


/// 牧师技能
- (void)skillCureAction
{
    [self setBloodNodeNumber:-self.blood / 2.0];
}

/// 被治愈
- (void)beCureActionWithCureNode:(WDBaseNode *)cureNode
{
    [self setBloodNodeNumber:-cureNode.cureNumber];
}

/// 移动
- (void)moveActionWithPoint:(CGPoint)point
               moveComplete:(void (^)(void))moveFinish
{
    if (self.lastBlood <= 0) {
        return;
    }
    
    if (self.state & SpriteState_stagger) {
        return;
    }
    
    SKAction *action = [self actionForKey:@"select"];

    if (self.state & SpriteState_move) {
        [self removeActionForKey:@"move"];
    }else{
        [self removeAllActions];
    }
    
    ///选中动画继续完成
    if (action) {
        [self runAction:action];
    }
    
    _moveFinish = moveFinish;
    if (self.state & SpriteState_movie) {
        self.state = SpriteState_move | SpriteState_movie;
    }else{
        self.state = SpriteState_move;
    }
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(moveFinishAction) object:nil];
    
    //血条翻转
    if (point.x > self.position.x) {
        self.xScale = fabs(self.xScale);
        self.direction = @"right";
        self.isRight = YES;
        
    }else{
        
        self.xScale = -fabs(self.xScale);
        self.direction = @"left";
        self.isRight = NO;

    }
    
   
    
    CGFloat distanceX = fabs(point.x - self.position.x);
    CGFloat distanceY = fabs(point.y - self.position.y);
    
    CGFloat distance = sqrt(distanceX * distanceX + distanceY * distanceY);
    NSTimeInterval time = distance / self.moveSpeed;
    SKAction *move = [SKAction moveTo:point duration:time];
    
    //NSLog(@"%f",time);
    
    [self runAction:move withKey:@"move"];
    [self performSelector:@selector(moveFinishAction) withObject:nil afterDelay:time];
    
    SKAction *moveAnimation = [self actionForKey:@"moveAnimation"];
    if (!moveAnimation) {
        SKAction *texture = [SKAction animateWithTextures:self.model.walkArr timePerFrame:0.05];
        SKAction *rep = [SKAction repeatActionForever:texture];
        [self runAction:rep withKey:@"moveAnimation"];
    }
}


/// 移动结束
- (void)moveFinishAction{
    
    [[WDTextureManager shareTextureManager] hiddenArrow];

    [self standAction];
    [self removeActionForKey:@"moveAnimation"];

    if (_moveFinish) {
        _moveFinish();
    }
}

- (void)skill1Action{
    self.skill1 = YES;
}
- (void)skill2Action{
    self.skill2 = YES;
}
- (void)skill3Action{
    self.skill3 = YES;
}
- (void)skill4Action{
    self.skill4 = YES;
}
- (void)skill5Action{
    self.skill5 = YES;
}


/// 死亡释放资源
- (void)releaseAction
{
    [self removeObserver:self forKeyPath:@"isRight"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self removeAllActions];
    self.targetMonster = nil;
    self.targetUser    = nil;
    self.state = SpriteState_dead;
    
    __weak typeof(self)weakSelf = self;
    if (self.model.diedArr.count > 0) {
        SKAction *diedAction = [SKAction animateWithTextures:self.model.diedArr timePerFrame:0.1];
        SKAction *alpha = [SKAction fadeAlphaTo:0 duration:self.model.diedArr.count * 0.1];
        SKAction *gr = [SKAction group:@[diedAction,alpha]];
        SKAction *remo = [SKAction removeFromParent];
        SKAction *seq = [SKAction sequence:@[gr,remo]];
        [self runAction:seq completion:^{
        }];
    }else{
        SKAction *alpha = [SKAction fadeAlphaTo:0 duration:0.5];
        SKAction *remo = [SKAction removeFromParent];
        SKAction *seq = [SKAction sequence:@[alpha,remo]];
        [self runAction:seq completion:^{
        }];
    }
    
}

#pragma mark - getter and setter-
#pragma mark - 阴影 -
- (void)setShadowNodeWithPosition:(CGPoint)point
                            scale:(CGFloat)scale
{
    SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:@"shadow"]];
    _shadowNode = [WDBaseNode spriteNodeWithTexture:texture];
    _shadowNode.position = point;
    _shadowNode.xScale = scale;
    _shadowNode.yScale = scale;
    _shadowNode.zPosition = -1;
    [self addChild:_shadowNode];
}

#pragma mark - 金色选中箭头 -
- (void)setArrowNodeWithPosition:(CGPoint)point
                           scale:(CGFloat)scale
{
    SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:@"selectArrow"]];
    _arrowNode = [WDBaseNode spriteNodeWithTexture:texture];
    _arrowNode.position = point;
    _arrowNode.xScale = scale;
    _arrowNode.yScale = scale;
    _arrowNode.zPosition = -100;
    _arrowNode.hidden = YES;
    [self addChild:_arrowNode];
    
    SKAction *move1 = [SKAction moveTo:CGPointMake(point.x,point.y + 30) duration:0.5];
    SKAction *move2 = [SKAction moveTo:CGPointMake(point.x, point.y ) duration:0.5];
    SKAction *seq = [SKAction sequence:@[move1,move2]];
    SKAction *rep = [SKAction repeatActionForever:seq];
    [_arrowNode runAction:rep withKey:@"arrow"];
    
}


/// 设置目标
- (void)setTragetMonster:(WDBaseNode *)enemNode
{
    _targetMonster = enemNode;
}


/// 血条背景
- (WDBaseNode *)bloodNode
{
    if (!_bloodNode) {
        
        //UIColor *color = UICOLOR_RGB(124, 42, 42, 1);
        UIColor *color = [UIColor blackColor];
        CGFloat width = fabs(self.realSize.width / self.xScale);
        
        if (self.bloodWidth != 0) {
            width = self.bloodWidth;
        }
        
        if (self.bloodHeight == 0) {
            self.bloodHeight = 40.f;
        }
        
        _bloodBgNode = [WDBaseNode spriteNodeWithColor:color size:CGSizeMake(width, self.bloodHeight)];
        _bloodBgNode.zPosition = -1;
        if (self.bloodY == 0) {
            _bloodBgNode.position = CGPointMake(- width / 2.0,self.realSize.height / self.yScale - self.realSize.height - 40);
        }else{
            _bloodBgNode.position = CGPointMake(self.bloodX, self.bloodY);
        }
        
        [self addChild:_bloodBgNode];
        
        
        UIColor *color2 = UICOLOR_RGB(127, 255, 0, 1);
        _bloodNode = [WDBaseNode spriteNodeWithColor:color2 size:CGSizeMake(self.realSize.width / self.xScale, self.bloodHeight - bloodPage * 2.0)];
        _bloodNode.zPosition = 1;
        _bloodNode.position = CGPointMake(0, bloodPage);
        [_bloodBgNode addChild:_bloodNode];
        
        _bloodBgNode.anchorPoint = CGPointMake(0, 0);
        _bloodNode.anchorPoint = CGPointMake(0, 0);
    }
    
    return _bloodNode;
}


- (WDTalkNode *)talkNode
{
    if (!_talkNode) {
        _talkNode = [WDTalkNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"talk"]]];
        _talkNode.zPosition = 1000;
        _talkNode.hidden = YES;
        _talkNode.xScale = 3;
        _talkNode.yScale = 3;
        _talkNode.position = CGPointMake(0, self.realSize.height + 40);
        [self addChild:_talkNode];
    }
    
    return _talkNode;
}

- (WDBalloonNode *)balloonNode
{
    if (!_balloonNode) {
        
        NSArray *balloonArr = [[WDTextureManager shareTextureManager]balloonTexturesWithLine:1];
        _balloonNode = [WDBalloonNode spriteNodeWithTexture:balloonArr[1]];
        _balloonNode.position = CGPointMake(_balloonNode.position.x, self.size.height / 2.0 + _balloonNode.size.height / 2.0);
        _balloonNode.xScale = 3.0;
        _balloonNode.yScale = 3.0;
        [_balloonNode setScaleAndPositionWithName:self.name];
        _balloonNode.zPosition = 10000;
        [self addChild:_balloonNode];
    }
    
    return _balloonNode;
}


@end




@implementation WDUserNode


- (void)selectSpriteAction
{
    SKAction *a = [SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:0.7 duration:0.15];
    SKAction *b = [SKAction colorizeWithColorBlendFactor:0 duration:0.15];
    SKAction *seq = [SKAction sequence:@[a,b]];
    SKAction *rep = [SKAction repeatAction:seq count:1];
      
    [self runAction:rep withKey:@"select"];
}

- (void)setBodyCanUse
{
    self.physicsBody.categoryBitMask    = PLAYER_CATEGORY;
    self.physicsBody.collisionBitMask   = PLAYER_COLLISION;
    self.physicsBody.contactTestBitMask = PLAYER_CONTACT;
}

@end



@implementation WDMonsterNode

- (void)selectSpriteAction
{
    SKAction *a = [SKAction colorizeWithColor:[UIColor blackColor] colorBlendFactor:0.7 duration:0.15];
    SKAction *b = [SKAction colorizeWithColorBlendFactor:0 duration:0.15];
    SKAction *seq = [SKAction sequence:@[a,b]];
    SKAction *rep = [SKAction repeatAction:seq count:2];
    
    [self runAction:rep];
    
}

- (void)selectSpriteActionWithSelectNode:(WDBaseNode *)userNode
{
    [self selectSpriteAction];
    
    
}


- (void)setBodyCanUse
{
    self.physicsBody.categoryBitMask    = MONSTER_CATEGORY;
    self.physicsBody.collisionBitMask   = MONSTER_COLLISION;
    self.physicsBody.contactTestBitMask = MONSTER_CONTACT;
}

@end


@implementation WDWeaponNode

@end
