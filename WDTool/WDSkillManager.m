//
//  WDSkillManager.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/12.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDSkillManager.h"

@implementation WDSkillManager
static WDSkillManager *skillManager = nil;

+ (WDSkillManager *)shareSkillManager;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!skillManager) {
            skillManager = [[WDSkillManager alloc] init];
        }
    });
    
    return skillManager;
}

+ (void)endSkillActionWithTarget:(WDBaseNode *)targetNode
                       skillType:(NSString *)skillType
                            time:(NSInteger)time
{
    [[WDSkillManager shareSkillManager]performSelector:@selector(endSkillWithDic:) withObject:@{kSkillType:skillType,@"node":targetNode} afterDelay:time];
}

- (void)endSkillWithDic:(NSDictionary *)dic
{
    int skillType = [dic[kSkillType]intValue];
    WDBaseNode *node  = dic[@"node"];
    switch (skillType) {
        case 1:
            node.skill1 = NO;
            break;
        case 2:
            node.skill2 = NO;
            break;
        case 3:
            node.skill3 = NO;
            break;
        case 4:
            node.skill4 = NO;
            break;
        case 5:
            node.skill5 = NO;
            break;
            
        default:
            break;
    }
    
    
    if ([node.name isEqualToString:kArcher]) {
        /// 弓箭手
        [self endSkillForArcherNode:node skillType:skillType];
    }else if([node.name isEqualToString:kIceWizard]){
        /// 冰女巫
        [self endSkillForIceWizardNode:node skillType:skillType];
    }else if([node.name isEqualToString:kKinght]){
        /// 骑士
        [self endSkillForKnightNode:node skillType:skillType];
    }
    
    
    /// 减血
    if (skillType == SpriteSkill_reduceAttack) {
        WDBaseNode *nodeD = (WDBaseNode *)[node childNodeWithName:@"define"];
        [nodeD removeFromParent];
        node.iceWizardReduceAttack = NO;
    }
}


/// 骑士
- (void)endSkillForKnightNode:(WDBaseNode *)node
                    skillType:(int)skillType
{
    if (skillType == 2) {
        WDBaseNode *nodeD = (WDBaseNode *)[node childNodeWithName:@"define"];
        [nodeD removeFromParent];
        node.iceWizardReduceAttack = NO;
    }else if(skillType == 4){
        WDBaseNode *nodeD = (WDBaseNode *)[node childNodeWithName:@"rebound"];
        [nodeD removeFromParent];
        node.kinghtReboundAttack = NO;
    }
}

/// 冰女巫
- (void)endSkillForIceWizardNode:(WDBaseNode *)node
                       skillType:(int)skillType
{
    if (skillType == 1) {
        node.cureNumber = node.trueCureNumber;
    }else if(skillType == 3){
        WDBaseNode *nodeD = (WDBaseNode *)[node childNodeWithName:@"define"];
        [nodeD removeFromParent];
        node.iceWizardReduceAttack = NO;
    }else if(skillType == 4){
        WDBaseNode *nodeD = (WDBaseNode *)[node childNodeWithName:@"notDead"];
        [nodeD removeFromParent];
        node.iceWizardNotDead = NO;
    }
}


///弓箭手
- (void)endSkillForArcherNode:(WDBaseNode *)node
                    skillType:(int)skillType
{
    if (skillType == 3) {
        node.moveSpeed = node.trueMoveSpeed;
    }
}

@end
