//
//  WDBaseScene+TouchLogic.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/23.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseScene+TouchLogic.h"



@implementation WDBaseScene (TouchLogic)

#pragma mark - 触碰 -
- (void)touchDownAtPoint:(CGPoint)pos {
   // NSLog(@"点中的坐标为: x = %lf  y = %lf",pos.x,pos.y);
    //self.selectNode.state = SpriteState_operation;
}

// 移动
- (void)touchMovedToPoint:(CGPoint)pos {
    
    if (self.isPauseClick) {
        return;
    }
    
    /// 玩家在移动状态，不显示指引线
    if (!self.selectNode.isMove) {
        self.selectLine.hidden = NO;
        self.selectLine.position = CGPointMake(self.selectNode.position.x, self.selectNode.position.y - self.selectNode.realSize.height / 2.0 + 35);
    }
    
    ///引导线
    //斜边
    CGFloat width = [WDCalculateTool distanceBetweenPoints:pos seconde:self.selectLine.position];
    self.selectLine.size = CGSizeMake(width, 10);
    //角度
    self.selectLine.zRotation = [WDCalculateTool angleForStartPoint:self.selectLine.position EndPoint:pos];
    //NSLog(@"%lf",self.selectLine.zRotation);
    [self.selectLine createLinePhyBody];

}

// 触碰结束
- (void)touchUpAtPoint:(CGPoint)pos {
    
    if (self.isPauseClick) {
        return;
    }
    
   
    NSArray *nodes = [self nodesAtPoint:pos];

    pos = [WDCalculateTool calculateBigPoint:pos];
    
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
            
        }else if ([n isKindOfClass:[WDMonsterNode class]]) {
           
            if (dis < distance) {
                monsterNode = (WDMonsterNode *)n;
                userNode = nil;
                distance = dis;
            }
        }
    }
    
    
    BOOL canMove = YES;
    
    ///首先判断是否选中的为monster
    if (monsterNode) {
        
        BOOL isMonster = [self selectRealMonster:monsterNode pos:pos];
        if (isMonster) {
            canMove = NO;
        }else{
            canMove = YES;
        }
        
       
    }else if(userNode){
        
        //如果引导线没隐藏，添加buff效果
        if (self.selectNode.addBuff && self.selectLine.hidden == NO) {
            [self addBuf:userNode];
            canMove = NO;
        }else if(![self.selectNode.name isEqualToString:userNode.name]){
            //切换选中的玩家
            canMove = [self changeSelectNode:userNode pos:pos];
        }
        
    }
    
    if (self.selectNode.state & SpriteState_stagger) {
        canMove = NO;
    }
    
    if (self.selectNode.state & SpriteState_dead) {
        canMove = NO;
    }

    /// 非切换目标可以移动
    if (canMove) {
        self.selectNode.targetMonster = nil;
        [self.selectNode moveActionWithPoint:pos moveComplete:^{
        }];
        [self arrowAction:pos];
    }

    
    self.selectLine.hidden = YES;
    self.selectLine.size = CGSizeMake(0, 0);
}





#pragma mark - 选中怪物的情况 -
/// 真是选中怪物，可能图片显示过大问题
- (BOOL)selectRealMonster:(WDBaseNode *)monster
                      pos:(CGPoint)pos
{
    ///蝙蝠特殊一下
    if ([monster.name isEqualToString:kRedBat]) {
        //选中动画
        [monster selectSpriteAction];
        [self selectMonster:monster];
        
        [self.selectNode removeAllActions];
        [self.selectNode standAction];
        
        /// 如果选中怪物，就取消之前的治疗状态(治疗职业专属)
        self.selectNode.isCure = NO;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self.selectNode selector:@selector(moveFinishAction) object:nil];
        
        return YES;
    }
    
    CGFloat distanceX = fabs(monster.position.x - pos.x);
    CGFloat distanceY = fabs(monster.position.y - pos.y);
    //创建的图片比实际显示图片要大
    if (distanceX < monster.realSize.width / 2.0 && distanceY < monster.realSize.height / 2.0) {
        
        //选中动画
        [monster selectSpriteAction];
        [self selectMonster:monster];
        
        [self.selectNode removeAllActions];
        [self.selectNode standAction];
        
        self.selectNode.isCure = NO;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self.selectNode selector:@selector(moveFinishAction) object:nil];
        
        return YES;
    }else{
        return NO;
    }
    
}


- (void)selectMonster:(WDBaseNode *)monsterNode
{
    //NSLog(@"当前%@怪物选中的人物是%@",monsterNode.name,self.selectNode.name);
    ///玩家当前选中人物和怪物选中的攻击人物相同
    if ([monsterNode.targetMonster.name isEqualToString:self.selectNode.name]) {
        
        monsterNode.randomDistanceY = 0;
        monsterNode.randomDistanceY = 0;
        
        //重置一下之前怪物的位置,这个位置是相当于玩家人物的随机攻击位置
        if (![self.selectNode.targetMonster isEqualToNode:monsterNode]) {
            [self.textureManager setMonsterMovePointWithName:self.selectNode.targetMonster.name monster:self.selectNode.targetMonster];
        }else{
            NSLog(@"同一个玩家点中我啦！");
        }
        
        ///玩家当前选中人物和怪物选中的攻击人物不同
    }else if(![monsterNode.targetMonster.name isEqualToString:self.selectNode.name]){
        
        //重置一下之前怪物的位置
        if (![self.selectNode.targetMonster isEqualToNode:monsterNode]) {
            [self.textureManager setMonsterMovePointWithName:self.selectNode.targetMonster.name monster:self.selectNode.targetMonster];
        }else{
            NSLog(@"同一个玩家点中我啦！");
        }
    }
    
    ///选中怪物的情况
    self.selectNode.targetMonster = monsterNode;
    [[WDTextureManager shareTextureManager] hiddenArrow];
        
    //NSLog(@"变换以后%@怪物选中的人物是%@",monsterNode.name,self.selectNode.name);
}

#pragma mark - 选中玩家，添加增益效果 -
- (void)addBuf:(WDBaseNode *)userNode
{
    [userNode selectSpriteAction];
    self.selectNode.isCure = YES;
    [self.selectNode addBuffActionWithNode:userNode];
}

#pragma mark - 切换选中玩家 -
- (BOOL)changeSelectNode:(WDBaseNode *)userNode
                     pos:(CGPoint)pos
{
    CGFloat distanceX = fabs(userNode.position.x - pos.x);
    CGFloat distanceY = fabs(userNode.position.y - pos.y);
    //创建的图片比实际显示图片要大
    if (distanceX < userNode.realSize.width / 2.0 && distanceY < userNode.realSize.height / 2.0) {
        ///切换选中目标，不能移动
        self.selectNode.arrowNode.hidden = YES;
        userNode.arrowNode.hidden    = NO;
        self.selectNode = userNode;
        [self.selectNode selectSpriteAction];
        [[WDTextureManager shareTextureManager] hiddenArrow];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForChangeUser object:self.selectNode.name];
        return NO;
    }else{
        return YES;
    }
}

@end
