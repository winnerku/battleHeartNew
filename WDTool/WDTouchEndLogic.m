//
//  WDTouchEndLogic.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/21.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDTouchEndLogic.h"

@implementation WDTouchEndLogic

+ (void)touchEndWithPoint:(CGPoint)pos
                    scene:(WDBaseScene *)scene
               selectNode:(WDBaseNode *)selectNode
                 lineNode:(WDBaseNode *)lineNode
{
    NSArray *nodes = [scene nodesAtPoint:pos];

     WDUserNode *userNode = nil;
     WDMonsterNode *monsterNode = nil;
     CGFloat distance = 100000;
     ///点击区域角色
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
    
     if (selectNode.addBuff  && userNode && lineNode.hidden == NO) {
         ///增益buff状态~
         canMove = NO;
         [userNode selectSpriteAction];
         [selectNode addBuffActionWithNode:userNode];
          
     }else if (![selectNode.name isEqualToString:userNode.name] && userNode) {
        
         CGFloat distanceX = fabs(userNode.position.x - pos.x);
         CGFloat distanceY = fabs(userNode.position.y - pos.y);
         //实际显示图片比创建的图片要大
         if (distanceX < userNode.realSize.width / 2.0 && distanceY < userNode.realSize.height / 2.0) {
             ///切换选中目标，不能移动
             selectNode.arrowNode.hidden = YES;
             userNode.arrowNode.hidden    = NO;
             canMove = NO;
             selectNode = userNode;
             [selectNode selectSpriteAction];
             [[WDTextureManager shareTextureManager] hiddenArrow];
         }
         
         
     }else if(monsterNode){
         
         [monsterNode selectSpriteAction];
         
         NSLog(@"当前%@怪物选中的人物是%@",monsterNode.name,selectNode.name);
         
         
         ///玩家当前选中人物和怪物选中的攻击人物相同
         if ([monsterNode.targetMonster.name isEqualToString:selectNode.name]) {
             
             monsterNode.randomDistanceY = 0;
             monsterNode.randomDistanceY = 0;
             
             //重置一下之前怪物的位置
             if (![selectNode.targetMonster isEqualToNode:monsterNode]) {
                 [[WDTextureManager shareTextureManager] setMonsterMovePointWithName:selectNode.targetMonster.name monster:selectNode.targetMonster];
             }else{
                 NSLog(@"同一个玩家点中我啦！");
             }
             
             ///玩家当前选中人物和怪物选中的攻击人物不同
         }else if(![monsterNode.targetMonster.name isEqualToString:selectNode.name]){
             
             //重置一下之前怪物的位置
             if (![selectNode.targetMonster isEqualToNode:monsterNode]) {
                 [[WDTextureManager shareTextureManager] setMonsterMovePointWithName:selectNode.targetMonster.name monster:selectNode.targetMonster];
             }else{
                 NSLog(@"同一个玩家点中我啦！");
             }
         }
         
         
         ///选中怪物的情况
         selectNode.targetMonster = monsterNode;
         [[WDTextureManager shareTextureManager] hiddenArrow];
         canMove = NO;
         
         NSLog(@"变换以后%@怪物选中的人物是%@",monsterNode.name,selectNode.name);

         
     }
     
     
     
     /// 非切换目标可以移动
     if (canMove) {
         selectNode.targetMonster = nil;
         [selectNode moveActionWithPoint:pos moveComplete:^{
         }];
         [scene arrowAction:pos];

     }

     
     lineNode.hidden = YES;
     lineNode.size = CGSizeMake(0, 0);
}

@end
