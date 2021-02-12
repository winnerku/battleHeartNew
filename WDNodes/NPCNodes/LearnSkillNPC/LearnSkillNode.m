//
//  LearnSkillNode.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/6.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "LearnSkillNode.h"

@implementation LearnSkillNode
{
    BOOL _isStand;
    
}

- (void)stayAction
{
    if (!_isStand) {
        return;
    }
    self.alpha = 1;
    [self removeAllActions];
    SKAction *stayA = [SKAction animateWithTextures:_model.sitArr timePerFrame:0.15];
    SKSpriteNode *butterNode = (SKSpriteNode *)[self childNodeWithName:@"butterFly"];
    SKAction *moveAction = [SKAction moveTo:CGPointMake(0, 0) duration:0.15 * _model.sitArr.count];
    [butterNode runAction:moveAction];
    __weak typeof(self)weakSelf = self;
    [self runAction:stayA completion:^{
        [weakSelf setStand:NO];
    }];
}

- (void)setStand:(BOOL)isStand
{
    _isStand = isStand;
}

- (void)standAction
{
    [self setStand:YES];
    [self removeAllActions];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = _model.sitArr.count - 1; i >= 0; i--) {
        SKTexture *texture = _model.sitArr[i];
        [arr addObject:texture];
    }
    
    SKAction *action = [SKAction animateWithTextures:arr timePerFrame:0.15];
    SKAction *action2 = [SKAction animateWithTextures:_model.learnArr timePerFrame:0.15];
    SKAction *seq = [SKAction sequence:@[action,action2]];
    
    SKAction *moveB = [SKAction moveToY:self.position.y + 5 duration:0.8];
    SKAction *moveA = [SKAction moveToY:self.position.y duration:0.8];
    SKAction *seqMove = [SKAction sequence:@[moveB,moveA]];
    
    SKAction *alpha1 = [SKAction fadeAlphaTo:0.7 duration:0.8];
    SKAction *alpha2 = [SKAction fadeAlphaTo:1.0 duration:0.8];
    SKAction *seqAlpha = [SKAction sequence:@[alpha1,alpha2]];
    
    SKAction *grou  = [SKAction group:@[seqMove,seqAlpha]];
    SKAction *rep = [SKAction repeatActionForever:grou];
   
    SKAction *seq2 = [SKAction sequence:@[seq,rep]];
    
    
   

    SKSpriteNode *butterNode = (SKSpriteNode *)[self childNodeWithName:@"butterFly"];
    
    CGFloat y = self.size.height / 2.0 - butterNode.size.height / 2.0 - 5;
    CGFloat x = self.size.width / 2.0 * - 1 + 20;
 
    
    SKAction *moveAction = [SKAction moveTo:CGPointMake(x, y) duration:0.15 * 5 ];
    
    [butterNode runAction:moveAction];
    [self runAction:seq2 completion:^{
        
    }];
}

@end
