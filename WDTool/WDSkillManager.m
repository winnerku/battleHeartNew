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
    
    /// 弓箭手
    if ([node.name isEqualToString:kArcher]) {
        [self endSkillForArcherNode:node skillType:skillType];
    }
}

- (void)endSkillForArcherNode:(WDBaseNode *)node
                    skillType:(int)skillType
{
    if (skillType == 3) {
        node.moveSpeed = node.trueMoveSpeed;
    }
}

@end
