//
//  WDBaseScene+ContactLogic.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/12.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseScene+ContactLogic.h"


@implementation WDBaseScene (ContactLogic)

- (void)contactLogicAction:(SKPhysicsContact *)contact
{
    WDBaseNode *nodeA = (WDBaseNode *)contact.bodyA.node;
    WDBaseNode *nodeB = (WDBaseNode *)contact.bodyB.node;
       
    //NSLog(@"A: %@  b: %@",nodeA.name,nodeB.name);

    
    ///弓箭触碰
    if ([nodeA.name isEqualToString:@"user_arrow"]) {
        CGFloat numer = [WDCalculateTool calculateReduceNumberWithAttack:nodeA.attackNumber floatNumber:2];
        if ([nodeB isKindOfClass:[WDMonsterNode class]]) {
            [nodeB setBloodNodeNumber:numer];
            WDArcherNode *node = (WDArcherNode *)[self childNodeWithName:kArcher];
            //弓箭手吸血技能
            if (node.skill4) {
                [node setBloodNodeNumber:-numer];
            }
        }
    }else if([nodeB.name isEqualToString:@"user_arrow"]){
        CGFloat numer = [WDCalculateTool calculateReduceNumberWithAttack:nodeB.attackNumber floatNumber:2];
        if ([nodeA isKindOfClass:[WDMonsterNode class]]) {
            [nodeA setBloodNodeNumber:numer];
            WDArcherNode *node = (WDArcherNode *)[self childNodeWithName:kArcher];
            //弓箭手吸血技能
            if (node.skill4) {
                [node setBloodNodeNumber:-numer];
            }
        }
    }
    
    ///冰火触碰
    if ([nodeA.name isEqualToString:@"iceFire"] && ![nodeB isKindOfClass:[WDUserNode class]]) {
        CGFloat numer = [WDCalculateTool calculateReduceNumberWithAttack:15 floatNumber:10];
        [nodeA removeFromParent];
        if ([nodeB isKindOfClass:[WDMonsterNode class]]) {
            [nodeB setBloodNodeNumber:numer];
        }
        
    }else if([nodeB.name isEqualToString:@"iceFire"] && ![nodeA isKindOfClass:[WDUserNode class]]){
        CGFloat numer = [WDCalculateTool calculateReduceNumberWithAttack:15 floatNumber:10];
        [nodeB removeFromParent];
        if ([nodeA isKindOfClass:[WDMonsterNode class]]) {
            [nodeA setBloodNodeNumber:numer];
        }
    }
    
    /// 毒气攻击
    if ([nodeA isKindOfClass:[WDUserNode class]] && [nodeB.name  isEqualToString:@"poison"]) {
        [self poisonContactAction:nodeA poison:nodeB];
    } else if([nodeB isKindOfClass:[WDUserNode class]] && [nodeA.name  isEqualToString:@"poison"]){
        [self poisonContactAction:nodeB poison:nodeA];
    }
    
    /// 僵尸爪子攻击
    if ([nodeA isKindOfClass:[WDUserNode class]] && [nodeB.name  isEqualToString:@"ZomClaw"]) {
        [self zombieClawContactAction:nodeA claw:nodeB];
    } else if([nodeB isKindOfClass:[WDUserNode class]] && [nodeA.name  isEqualToString:@"ZomClaw"]){
        [self zombieClawContactAction:nodeB claw:nodeA];
    }
    
    /// 骷髅骑士冰爪攻击
    if ([nodeA isKindOfClass:[WDUserNode class]] && [nodeB.name  isEqualToString:@"iceClaw"]) {
        [self iceClawContactAction:nodeA claw:nodeB];
    } else if([nodeB isKindOfClass:[WDUserNode class]] && [nodeA.name  isEqualToString:@"iceClaw"]){
        [self iceClawContactAction:nodeB claw:nodeA];
    }
    
    /// 风攻击导致瘫痪
    if ([nodeA isKindOfClass:[WDUserNode class]] && [nodeB.name isEqualToString:@"wind"]) {
        [self windContactAction:nodeB user:nodeA];
    }else if([nodeB isKindOfClass:[WDUserNode class]] && [nodeA.name isEqualToString:@"wind"]){
        [self windContactAction:nodeA user:nodeB];
    }
    
    /// 闪电球连续攻击
    if ([nodeA isKindOfClass:[WDUserNode class]] && [nodeB.name  isEqualToString:@"flashA"]) {
        [self flashAContactAction:nodeA flash:nodeB];
    } else if([nodeB isKindOfClass:[WDUserNode class]] && [nodeA.name  isEqualToString:@"flashA"]){
        [self flashAContactAction:nodeB flash:nodeA];
    }
    
    /// 闪电球连续攻击(自食其果)
    if ([nodeA.name isEqualToString:kOX] && [nodeB.name  isEqualToString:@"flashA"]) {
        [self flashAContactBossAction:nodeA flash:nodeB];
    } else if( [nodeB.name isEqualToString:kOX] && [nodeA.name  isEqualToString:@"flashA"]){
        [self flashAContactBossAction:nodeB flash:nodeA];
    }
       
    /// 怪物攻击击中玩家
    if ([nodeA isKindOfClass:[WDUserNode class]] && [nodeB isKindOfClass:[WDWeaponNode class]]) {
        CGFloat numer = [WDCalculateTool calculateReduceNumberWithAttack:nodeB.attackNumber floatNumber:nodeB.floatAttackNumber];
        [nodeA setBloodNodeNumber:numer];
        [self weaponAttackAction:nodeA weaponNode:nodeB];
    }else if([nodeB isKindOfClass:[WDUserNode class]] && [nodeA isKindOfClass:[WDWeaponNode class]]){
        CGFloat numer = [WDCalculateTool calculateReduceNumberWithAttack:nodeA.attackNumber floatNumber:nodeA.floatAttackNumber];
        [nodeB setBloodNodeNumber:numer];
        [self weaponAttackAction:nodeB weaponNode:nodeA];
    }
    
    
}


/// 怪物释放出的招式
- (void)weaponAttackAction:(WDBaseNode *)userNode
                weaponNode:(WDBaseNode *)weaponNode
{
    /// 鬼魂召唤的巨斧攻击
    if ([weaponNode.name isEqualToString:@"axe"]) {
        
        userNode.state = SpriteState_movie;
        userNode.isMoveAnimation = NO;
        [userNode removeAllActions];
        
        [userNode runAction:[SKAction moveTo:weaponNode.position duration:0.2] completion:^{
            userNode.state = SpriteState_stand;
        }];
    }
    
    
    /// 鬼魂召唤的鬼爪
    if ([weaponNode.name isEqualToString:@"hand"]) {
       
        userNode.affect = SpriteAffect_reduceSpeed;
        CGPoint point = CGPointMake(-60, userNode.realSize.height + 40);
        CGFloat scale = 3.0;
        if ([userNode.name isEqualToString:kArcher]) {
            point = CGPointMake(-60, userNode.realSize.height + 40);
            scale = 3.0;
        }
        
        [userNode setAffectWithArr:userNode.model.statusReduceArr point:point scale:scale count:3];
    }
    
}


/// 闪电连续攻击
- (void)flashAContactAction:(WDBaseNode *)userNode
                      flash:(WDBaseNode *)flash
{
    CGFloat numer = [WDCalculateTool calculateReduceNumberWithAttack:flash.attackNumber floatNumber:1];
    [userNode setBloodNodeNumber:numer];
}

/// 闪电球自己攻击到牛
- (void)flashAContactBossAction:(WDBaseNode *)boss
                          flash:(WDBaseNode *)flash
{
    if (!flash.isAttackSelf) {
        return;
    }
    
    WDBoss4Node *node = (WDBoss4Node *)boss;
    node.defense = 0;
    [node stopAim2Action];
}

/// 被丧尸爪子挠
- (void)zombieClawContactAction:(WDBaseNode *)userNode
                           claw:(WDBaseNode *)claw
{
    CGFloat numer = [WDCalculateTool calculateReduceNumberWithAttack:25 floatNumber:10];
    [userNode setBloodNodeNumber:numer];
}

/// 被BOSS毒气攻击
- (void)poisonContactAction:(WDBaseNode *)userNode
                     poison:(WDBaseNode *)poison
{
    CGFloat numer = [WDCalculateTool calculateReduceNumberWithAttack:poison.attackNumber floatNumber:5];
    [userNode setBloodNodeNumber:numer];
    [userNode setAffectWithType:SpriteAffect_poison];
}

/// 被BOSS的冰爪攻击了
- (void)iceClawContactAction:(WDBaseNode *)userNode
                        claw:(WDBaseNode *)iceClawNode
{
    CGFloat numer = [WDCalculateTool calculateReduceNumberWithAttack:iceClawNode.attackNumber floatNumber:5];
    [userNode setBloodNodeNumber:numer];
   
    CGPoint point = CGPointMake(-60, userNode.realSize.height + 40);
    CGFloat scale = 3.0;
    if ([userNode.name isEqualToString:kArcher]) {
        point = CGPointMake(-60, userNode.realSize.height + 40);
        scale = 3.0;
    }
    
    userNode.affect = SpriteAffect_reduceSpeed;
    [userNode setAffectWithArr:userNode.model.statusReduceArr point:point scale:scale count:3];
    
}

/// 被BOSS的吹风攻击
- (void)windContactAction:(WDBaseNode *)windNode
                     user:(WDBaseNode *)userNode
{
    userNode.state = SpriteState_wind | SpriteState_stagger;
    [userNode removeAllActions];
    userNode.reduceBloodNow = NO;
    userNode.colorBlendFactor = 0;
    [NSObject cancelPreviousPerformRequestsWithTarget:userNode];
    
    [windNode removeAllActions];
    windNode.physicsBody = nil;
    CGPoint point = CGPointZero;
    if (windNode.isRight) {
        point = CGPointMake(kScreenWidth - 100, windNode.position.y);
    }else{
        point = CGPointMake(-kScreenWidth + 100, windNode.position.y);
    }
    NSTimeInterval time = fabs(point.x - (windNode.directionNumber * 600)) / 1000;
    SKAction *moveAction = [SKAction moveTo:point duration:time];
    SKAction *alpha = [SKAction fadeAlphaTo:0 duration:0.2];
    SKAction *seq = [SKAction sequence:@[moveAction,alpha,[SKAction removeFromParent]]];
    [windNode runAction:seq completion:^{
                
    }];
    
    [userNode runAction:moveAction completion:^{
        userNode.state = SpriteState_stand;
    }];
}



@end
