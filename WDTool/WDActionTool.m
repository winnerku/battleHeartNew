//
//  WDActionTool.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/16.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDActionTool.h"

@implementation WDActionTool

+ (void)demageAnimation:(WDBaseNode *)node
                  point:(CGPoint)point
                  scale:(CGFloat)scale
              demagePic:(NSString *)imageName
{
    if (node.lastBlood <= 0) {
        return;
    }
    
    CGFloat rotation = M_PI / 180.0 * (arc4random() % 360);
    WDBaseNode *demageNode = [WDBaseNode spriteNodeWithTexture:[WDTextureManager shareTextureManager].demageTexture];
    demageNode.xScale = scale;
    demageNode.yScale = scale;
    demageNode.position = point;
    demageNode.zRotation = rotation;
    demageNode.name = imageName;
    demageNode.zPosition = 100;
    [node addChild:demageNode];
    
    SKAction *alphaAction = [SKAction fadeAlphaTo:0 duration:0.3];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *seqAction = [SKAction sequence:@[alphaAction,removeAction]];
    [demageNode runAction:seqAction];
}
@end
