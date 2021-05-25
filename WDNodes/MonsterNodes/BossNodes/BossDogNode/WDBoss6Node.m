//
//  WDBoss6Node.m
//  BattleHeartNew
//
//  Created by Mac on 2021/5/25.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBoss6Node.h"
#import "Boss6Model.h"
@implementation WDBoss6Node
{
    Boss6Model *_bossModel;
  
}

+ (instancetype)initWithModel:(WDBaseNodeModel *)model
{
    WDBoss6Node *node = [WDBoss6Node spriteNodeWithTexture:model.walkArr[0]];
    [node setChildNodeWithModel:model];
    return node;
}

- (void)setChildNodeWithModel:(WDBaseNodeModel *)model
{
    [super setChildNodeWithModel:model];
    
    self.xScale = 2.5;
    self.yScale = 2.5;
    
    _bossModel = (Boss6Model *)model;
    [_bossModel changeArr];
    self.model = _bossModel;
    self.realSize = CGSizeMake(self.size.width - 200, self.size.height / 2.0);
    
    self.anchorPoint = CGPointMake(0.5, 0.5);
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.realSize.width,self.realSize.height) center:CGPointMake(-30, -30)];
    self.physicsBody = body;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.allowsRotation = NO;
        
    [self setBodyCanUse];
 
    self.realCenterX = -30;
    self.realCenterY = -30;
    self.bloodY = 60;
    self.bloodX = -55;
    self.bloodHeight = 10;
    self.bloodWidth = self.realSize.width / 2.0;
//    self.bloodX_adapt_right = 13;
//    self.bloodX_adapt_left = 13;

    [WDNumberManager initNodeValueWithName:kDog node:self];
    [self setShadowNodeWithPosition:CGPointMake(-25, -self.realSize.height / 2.0 + 30) scale:0.2];
    [self setBloodNodeNumber:0];
    
    [self createRealSizeNode];
  
    self.talkNode.xScale = 1;
    self.talkNode.yScale = 1;
    self.talkNode.position = CGPointMake(0, 120);
        
}

#pragma mark - 移动 -
- (void)observedNode
{
    [super observedNode];
    self.zPosition = [WDCalculateTool calculateZposition:self] + 60;
}

@end
