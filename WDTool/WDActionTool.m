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
    demageNode.name = @"demage";
    demageNode.zPosition = 100;
    [node addChild:demageNode];
    
    SKAction *alphaAction = [SKAction fadeAlphaTo:0 duration:0.3];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *seqAction = [SKAction sequence:@[alphaAction,removeAction]];
    [demageNode runAction:seqAction];
}

+ (void)reduceBloodLabelAnimation:(WDBaseNode *)node
                      reduceCount:(CGFloat)count
{
   
   
    
    //27 36
    
//    NSArray *fontArr = [UIFont familyNames];
//    NSString *fontName = fontArr[27];
    NSString *fontName = @"Noteworthy";

    //VCR OSD Mono
    NSString *str = [NSString stringWithFormat:@"%0.0lf",-count];
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:fontName];
    label.zPosition = 5000;
    label.text = str;
    label.name = [NSString stringWithFormat:@"%lf_%@",count,node.name];
    
    CGFloat aaa = 1;
    if (arc4random() % 2 == 0) {
        aaa = -1;
    }
    CGPoint point = CGPointMake(node.position.x + arc4random() % 100 * aaa, node.position.y);
    if (count > 0) {
        label.fontColor = [UIColor redColor];
    }else{
        label.fontColor = [UIColor greenColor];
        point = node.position;
    }
    
    if ([node isKindOfClass:[WDUserNode class]] && count > 0) {
        label.fontColor = [UIColor redColor];
    }
    
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    label.horizontalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    int size = arc4random() % 5 + 20;
    label.fontSize = size;
    label.xScale = 2;
    label.yScale = 2;
    
    
    label.position = point;
    
    SKAction *alphaAction = [SKAction fadeAlphaTo:0 duration:1.5];
    SKAction *moveAction  = [SKAction moveToY:node.size.height + node.position.y + arc4random() % 100 duration:1];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *group = [SKAction group:@[alphaAction,moveAction]];
    //SKAction *music = [WDTextureManager shareManager].beAttackMusicAction;
    SKAction *seq    = [SKAction sequence:@[group,removeAction]];
    [node.parent addChild:label];
    [label runAction:seq];
}




@end
