//
//  WDBoss4Node.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/26.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBoss4Node.h"
#import "WDBaseScene.h"
@implementation WDBoss4Node
{
    Boss4Model *_bossModel;
    int         _attackNumber;
    WDBaseNode *_defineNode;
    SKEmitterNode *_flashFire;
    WDBaseNode    *_flashNode;
    BOOL           _flashAttack;
    NSMutableArray *_aimNodeArr;
    NSString   *_twoFlashName;  /// 闪电攻击轮番记名字
    BOOL           _stopFlashAttack; /// 被自己的球击中，停止连续攻击
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDBoss4Node *node = [WDBoss4Node spriteNodeWithTexture:model.walkArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    [super setChildNodeWithModel:model];
    
    self.xScale = 1.8;
    self.yScale = 1.8;
    
    _bossModel = (Boss4Model *)model;
    [_bossModel changeArr];
    self.model = _bossModel;
    self.realSize = CGSizeMake(self.size.width - 180, self.size.height - 300);
    self.realBodyX = -20;
    self.realBodyY = 0;
    self.realCenterY = 0;
    self.realCenterX = -20;
    self.anchorPoint = CGPointMake(0.5, 0.3);
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.realSize.width,self.realSize.height) center:CGPointMake(-20, 0)];
    self.physicsBody = body;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
        
    [self setBodyCanUse];
 
    self.bloodY = 80;
    self.bloodHeight = 10;
    self.bloodWidth = self.realSize.width / 2.0;
    self.bloodX_adapt_right = -13;
    self.bloodX_adapt_left = -13;

    [WDNumberManager initNodeValueWithName:kOX node:self];
    [self setShadowNodeWithPosition:CGPointMake(-30, -self.realSize.height / 2.0 + 30) scale:0.2];
    [self setBloodNodeNumber:0];
    
    [self createRealSizeNode];
  
    self.talkNode.xScale = 1;
    self.talkNode.yScale = 1;
    self.talkNode.position = CGPointMake(0, 120);
}

- (void)removeDefenseAction
{
    [_defineNode removeFromParent];
    _defineNode = nil;
    self.defense = 0;
    _attackNumber = 0;
}

- (void)attackActionWithEnemyNode:(WDBaseNode *)enemyNode
{
    [super attackActionWithEnemyNode:enemyNode];
    
    self.alpha = 1;
    
    if (!_flashFire) {
        _flashFire = [SKEmitterNode nodeWithFileNamed:@"flashFire"];
        [self.parent addChild:_flashFire];
        _flashFire.name = @"black";
        _flashFire.targetNode = self.parent;
        _flashFire.position = CGPointMake(self.position.x + 30 * self.directionNumber, self.position.y);
        //_flashFire.zPosition = 10;
        
        _flashNode = [WDBaseNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(20, 20)];
        _flashNode.name = @"flashA";
        [_flashFire addChild:_flashNode];
        [_flashNode createMonsterAttackPhysicBodyWithPoint:CGPointMake(0, 0) size:CGSizeMake(20, 20)];
    }
    
    
    _attackNumber ++;
    
    if (arc4random() % 2 == 0) {
        
        _flashNode.isAttackSelf = NO;

        WDBaseScene *scene = (WDBaseScene *)self.parent;
        if (arc4random() % 2 == 0 && scene.userArr.count > 1) {
            [self aimAttack2];
        }else{
            [self aimAttack1];
        }
        
    }else{
        
        SKAction *animation = [SKAction animateWithTextures:_bossModel.attackArr1 timePerFrame:0.1];
        animation.timingMode = SKActionTimingEaseIn;
        __weak typeof(self)weakSelf = self;
        [self runAction:animation completion:^{
            weakSelf.state = SpriteState_stand;
            [weakSelf createCloudNode];
        }];
    }
}


/// 随机选取倆名目标，直至其中一人死亡或者将电球引致BOSS身边
- (void)aimAttack2{
    if (!_defineNode) {
        _attackNumber = 0;
        _defineNode = [WDBaseNode spriteNodeWithTexture:_bossModel.defineArr[0]];
        _defineNode.zPosition = 10;
        _defineNode.xScale = 2.0;
        _defineNode.yScale = 2.0;
        _defineNode.name = @"add";
        _defineNode.alpha = 1;
        [self addChild:_defineNode];
        
        _defineNode.position = CGPointMake(10 * self.directionNumber, 0);
        
        SKAction *animation2 = [SKAction animateWithTextures:_bossModel.defineArr timePerFrame:0.1];
        animation2.timingMode = SKActionTimingEaseIn;
        SKAction *rep = [SKAction repeatActionForever:animation2];
        self.defense = 1000;
        //__weak typeof(self)weakSelf = self;
        [_defineNode runAction:rep completion:^{
            
        }];
    }
    
    SKAction *animation = [SKAction animateWithTextures:_bossModel.standArr timePerFrame:0.3];
    //__weak typeof(self)weakSelf = self;
    [self runAction:[SKAction repeatActionForever:animation] completion:^{
    }];
    
    _flashNode.name = @"flashA";
    _flashFire.hidden = NO;
    
    SKAction *alpha = [SKAction fadeAlphaTo:0 duration:0.3];
    __weak typeof(self)weakSelf = self;
    [self runAction:alpha completion:^{
        
        
        CGPoint point = [WDCalculateTool randomPositionWithNode:weakSelf];
        CGFloat distance = [WDCalculateTool distanceBetweenPoints:weakSelf.flashFire.position seconde:point];
        NSTimeInterval time = distance / 1600.0;
        if (time == 0) {
            time = 0.3;
        }
        SKAction *move = [SKAction moveTo:point duration:time];
        __weak typeof(self)weakSelf = self;
        
        [weakSelf.flashFire runAction:move completion:^{
            weakSelf.position = point;
            weakSelf.alpha = 1;
            [weakSelf aimAction2];
        }];
        
    }];
    
    //[self aimAction2];
    
}

- (void)aimAction2{
   
    WDBaseScene *scene = (WDBaseScene *)self.parent;
    int first = 0;
    int second = 0;
    first = arc4random() % scene.userArr.count;
    
    while (first == second) {
        second = arc4random() % scene.userArr.count;
    }
    
    WDBaseNode *node1 = scene.userArr[first];
    WDBaseNode *node2 = scene.userArr[second];
    
    [node1 createAimWithTexture:_bossModel.aim2];
    [node2 createAimWithTexture:_bossModel.aim2];

    _flashFire.position = CGPointMake(self.position.x + 130 * self.directionNumber, self.position.y - 37);
    _flashNode.attackNumber = 0;
    SKAction *wait = [SKAction waitForDuration:2];
    __weak typeof(self)weakSelf = self;
    [self runAction:wait completion:^{
        [weakSelf flashAttackTwoWithTarget1:node1 target2:node2];
    }];
}


/// 攻击到自己
- (void)stopAim2Action
{
    [self removeDefenseAction];
    [self removeAllActions];
    [_flashFire removeAllActions];
    self.state = SpriteState_movie;
    self.texture = _bossModel.beAttack;
    _flashFire.hidden = YES;
    
    
    WDBaseScene *scene = (WDBaseScene *)self.parent;
    for (WDBaseNode *node in scene.userArr) {
        [node removeAim];
    }
    
    CGPoint point = CGPointMake(self.position.x + 130 * self.directionNumber, self.position.y - 37);
    CGFloat distance = [WDCalculateTool distanceBetweenPoints:_flashFire.position seconde:point];
    NSTimeInterval time = distance / 600.0;
    if (time == 0) {
        time = 0.3;
    }
    SKAction *move = [SKAction moveTo:point duration:time];
    __weak typeof(self)weakSelf = self;
    
    [_flashFire runAction:move completion:^{
        [weakSelf removeAllActions];
        weakSelf.state = SpriteState_stand;
        weakSelf.flashAttack = NO;
        weakSelf.isMoveAnimation = NO;
    }];
}


/// 递归闪电攻击(2名)
- (void)flashAttackTwoWithTarget1:(WDBaseNode *)target1
                          target2:(WDBaseNode *)target2{
    
    if (target1.lastBlood <= 0 || target2.lastBlood <= 0) {
       
        [target1 removeAim];
        [target2 removeAim];
        
        CGPoint point = CGPointMake(self.position.x + 130 * self.directionNumber, self.position.y - 37);
        CGFloat distance = [WDCalculateTool distanceBetweenPoints:_flashFire.position seconde:point];
        NSTimeInterval time = distance / 600.0;
        if (time == 0) {
            time = 0.3;
        }
        SKAction *move = [SKAction moveTo:point duration:time];
        __weak typeof(self)weakSelf = self;
        self.flashAttack = YES;
        
        [_flashFire runAction:move completion:^{
            [weakSelf removeAllActions];
            weakSelf.state = SpriteState_stand;
        }];
       
        return;
    }
   
    WDBaseNode *target = nil;
    if ([_twoFlashName isEqualToString:target1.name]) {
        target = target2;
    }else{
        target = target1;
    }
    
    _twoFlashName = target.name;
    
    _flashNode.attackNumber = _flashNode.attackNumber + 1;

    /// 攻击到5时候可以反伤自己
    if (_flashNode.attackNumber >= 6) {
        _flashNode.isAttackSelf = YES;
    }else{
        _flashNode.isAttackSelf = NO;
    }

    CGFloat distance = [WDCalculateTool distanceBetweenPoints:_flashFire.position    seconde:target.position];
    NSTimeInterval time = distance / 1500.0;
    if (time == 0) {
        time = 0.3;
    }
    SKAction *move = [SKAction moveTo:target.position duration:time];
    __weak typeof(self)weakSelf = self;
    self.flashAttack = YES;
    [_flashFire runAction:move completion:^{
        [weakSelf flashAttackTwoWithTarget1:target1 target2:target2];
    }];
}


/// 选取4名目标攻击
- (void)aimAttack1{
    
    _flashFire.hidden = NO;

    if (!_flashAttack) {
        _flashNode.attackNumber = 40;
        _flashFire.position = CGPointMake(self.position.x + 130 * self.directionNumber, self.position.y - 37);
        [self aimAction];
    }
    
    
    SKAction *animation = [SKAction animateWithTextures:_bossModel.standArr timePerFrame:0.3];
    __weak typeof(self)weakSelf = self;
    [self runAction:animation completion:^{
        weakSelf.state = SpriteState_stand;
    }];
}

- (void)aimAction{
    
    _flashNode.name = @"flashA";
    
    WDBaseScene *scene = (WDBaseScene *)self.parent;
    if (_aimNodeArr) {
        [_aimNodeArr removeAllObjects];
    }else{
        _aimNodeArr = [NSMutableArray array];
    }
    for (int i = 0; i < scene.userArr.count; i ++) {
        WDBaseNode *node = scene.userArr[i];
        WDBaseNode *createNode = [WDBaseNode spriteNodeWithTexture:_bossModel.aim];
        createNode.position = node.position;
        createNode.zPosition = 10000;
        createNode.xScale = 1;
        createNode.yScale = 1;
        [scene addChild:createNode];
        
        SKAction *scale = [SKAction scaleTo:2.0 duration:2];
        SKAction *remove = [SKAction removeFromParent];
        
        __weak typeof(self)weakSelf = self;
        [createNode runAction:[SKAction sequence:@[scale,remove]] completion:^{
            if (i == scene.userArr.count - 1) {
                [weakSelf flashAttackAll:0];
            }
        }];
        
        [_aimNodeArr addObject:createNode];
    }
    
}

/// 递归闪电攻击
- (void)flashAttackAll:(NSInteger)index{
    
    WDBaseNode *target = nil;
    if (index < _aimNodeArr.count) {
        target = _aimNodeArr[index];
    }else{
        self.flashAttack = NO;
        return;
    }
    
    _flashNode.attackNumber = _flashNode.attackNumber - 5;
    if (_flashNode.attackNumber <= 0) {
        _flashNode.attackNumber = 5;
    }

    CGFloat distance = [WDCalculateTool distanceBetweenPoints:_flashFire.position    seconde:target.position];
    NSTimeInterval time = distance / 1500.0;
    SKAction *move = [SKAction moveTo:target.position duration:time];
    __weak typeof(self)weakSelf = self;
    self.flashAttack = YES;
    [_flashFire runAction:move completion:^{
        [weakSelf flashAttackAll:index + 1];
    }];
}

/** 创建云 */
- (void)createCloudNode
{
    WDWeaponNode *cloudNode = [WDWeaponNode spriteNodeWithTexture:_bossModel.cloudTexture];
    WDBaseNode *randomNode = [WDCalculateTool searchUserRandomNode:self];
    
    cloudNode.xScale = 0.5;
    cloudNode.yScale = 0.5;
    cloudNode.alpha = 0;
    cloudNode.position = CGPointMake(randomNode.position.x, randomNode.position.y + randomNode.realSize.height + cloudNode.size.height);
    cloudNode.zPosition = 1000;
    cloudNode.name = @"cloud";
    [self.parent addChild:cloudNode];
    
    SKAction *scaleAction = [SKAction scaleTo:0.7 duration:0.5];
    SKAction *alphaA = [SKAction fadeAlphaTo:1 duration:0.5];
    
    SKAction *blinkA = [SKAction fadeAlphaTo:0.9 duration:0.15];
    SKAction *blinkB = [SKAction fadeAlphaTo:1.0 duration:0.15];
    
    SKAction *bSeq = [SKAction sequence:@[blinkA,blinkB]];
    SKAction *gro = [SKAction group:@[scaleAction,alphaA]];
    
    SKAction *rep = [SKAction repeatAction:bSeq count:3];
    SKAction *alphaB = [SKAction fadeAlphaTo:0 duration:0.5];
    SKAction *remo = [SKAction removeFromParent];
    SKAction *seq2 = [SKAction sequence:@[rep,alphaB,remo]];
    
    __weak typeof(self)weakSelf = self;
    [cloudNode runAction:gro completion:^{
        
        [cloudNode runAction:seq2];
        [weakSelf flash:cloudNode.position];
    }];
    
}

/** 创建闪电攻击 */
- (void)flash:(CGPoint)point{
    WDWeaponNode *flashNode = [WDWeaponNode spriteNodeWithTexture:_bossModel.flashArr[0]];
    flashNode.position = CGPointMake(point.x, point.y - flashNode.size.height);
    flashNode.zPosition = 999;
    flashNode.xScale = 1.5;
    flashNode.yScale = 1.5;
    flashNode.alpha  = 0.8;
    flashNode.attackNumber = 20;
    flashNode.floatAttackNumber = 20;
    flashNode.name = @"flash";
    CGRect rect = CGRectMake(0, 0, flashNode.size.width / 2.0, flashNode.size.height);
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(rect.size.width, rect.size.height) center:CGPointMake(rect.origin.x, rect.origin.y)];
    body.allowsRotation = NO;
    body.affectedByGravity = NO;
    body.categoryBitMask = MONSTER_CATEGORY;
    body.contactTestBitMask = MONSTER_CONTACT;
    body.collisionBitMask = 0;
    flashNode.physicsBody = body;
    
    [self.parent addChild:flashNode];
    //3张图 0.1 * 3 * 3
    SKAction *flashAction = [SKAction animateWithTextures:_bossModel.flashArr timePerFrame:0.1];
    SKAction *repAction = [SKAction repeatAction:flashAction count:3];
    SKAction *seq2 = [SKAction sequence:@[repAction,REMOVE_ACTION]];
    
    [flashNode runAction:seq2 completion:^{
        
    }];
}

#pragma mark - 移动 -
- (void)observedNode
{
    [super observedNode];
    self.zPosition = [WDCalculateTool calculateZposition:self] + 30;
    
    if (!_flashAttack) {
        _flashFire.position = CGPointMake(self.position.x + 130 * self.directionNumber, self.position.y - 37);
    }
    
    if (self.state & SpriteState_attack || self.state & SpriteState_dead || self.state & SpriteState_movie) {
        return;
    }
    
    
    if (!self.targetMonster) {
        self.targetMonster = [WDCalculateTool searchUserRandomNode:self];
    }
    
    if (self.targetMonster.state & SpriteState_dead) {
        self.targetMonster = nil;
        return;
    }
    
    if (self.targetMonster == nil) {
        return;
    }
    
    CGFloat distance = self.targetMonster.position.x - self.position.x;
    if (distance < 0) {
        self.xScale = -fabs(self.xScale);
        self.direction = @"left";
        self.isRight = NO;
    }else{
        self.xScale = +fabs(self.xScale);
        self.direction = @"right";
        self.isRight = YES;
    }
    
    CGFloat personX = self.targetMonster.position.x;
    CGFloat personY = self.targetMonster.position.y;
    
    CGFloat monsterX = self.position.x;
    CGFloat monsterY = self.position.y;
    
    NSInteger distanceX = personX - monsterX;
    NSInteger distanceY = personY - monsterY;
    
    CGFloat moveX = monsterX;
    CGFloat moveY = monsterY;
    
    if (distanceX > 0) {
        
        self.xScale = 1 * fabs(self.xScale);
        if (fabs(distanceX) <= 400 && fabs(distanceX) >= 380) {
            moveX = monsterX;
        }else if (fabs(distanceX) >= 400) {
            moveX = monsterX + self.moveCADisplaySpeed;
        }else{
            moveX = monsterX - self.moveCADisplaySpeed;
        }

    }else if(distanceX < 0){
        
        self.xScale = -1 * fabs(self.xScale);
        if (fabs(distanceX) <= 400 && fabs(distanceX) >= 380) {
            moveX = monsterX;
        }else if (fabs(distanceX) >= 400) {
            moveX = monsterX - self.moveCADisplaySpeed;
        }else{
            moveX = monsterX + self.moveCADisplaySpeed;
        }
    }
    
    
    CGFloat farX = arc4random() % 500 + 400;
    CGFloat minX = arc4random() % 150 + 50;
    if (fabs(distanceY) < 10 && fabs(distanceX) > minX && fabs(distanceX) < farX) {
        [self attackActionWithEnemyNode:self.targetMonster];
        return;
    }else if(fabs(distanceY) < 10 && fabs(distanceY) > 0){
        moveY = monsterY;
    }else if(distanceY > 0){
        moveY = monsterY + self.moveCADisplaySpeed;
    }else if(distanceY < 0){
        moveY = monsterY - self.moveCADisplaySpeed;
    }
    
    if (moveX < -kScreenWidth + self.realSize.width || moveX > kScreenWidth - self.realSize.width) {
        [self removeAllActions];
        self.reduceBloodNow = NO;
        self.colorBlendFactor = 0;
        self.state = SpriteState_movie;
        
        SKAction *animation = [SKAction animateWithTextures:_bossModel.walkArr timePerFrame:0.1];
        SKAction *move = [SKAction moveTo:CGPointMake(0, 0) duration:_bossModel.walkArr.count * 0.1];
        __weak typeof(self)weakSelf = self;
        [self runAction:[SKAction group:@[animation,move]] completion:^{
            weakSelf.state = SpriteState_stand;
            weakSelf.isMoveAnimation = NO;
        }];
        
        return;
    }
    
    CGPoint calculatePoint = CGPointMake(moveX, moveY);
    
    self.position = calculatePoint;
    self.zPosition = 650 - self.position.y;
    if (!self.isMoveAnimation) {
        
        self.isMoveAnimation = YES;
        //5张
        SKAction *moveAction = [SKAction animateWithTextures:_bossModel.walkArr timePerFrame:0.1];
        SKAction *rep = [SKAction repeatActionForever:moveAction];
        [self runAction:rep completion:^{
        }];
    }
}

- (void)dealloc
{
    NSLog(@"boss4被销毁了");
    _bossModel = nil;
}

@end
