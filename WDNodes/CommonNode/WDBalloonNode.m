//
//  WDBalloonNode.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/18.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBalloonNode.h"

@implementation WDBalloonNode


- (void)hiddenTime{
    
    [self removeAllActions];
    self.hidden = YES;
    
    if (self.complete) {
        self.complete();
    }
    
}


- (void)setBalloonWithLine:(NSInteger)line hiddenTime:(NSInteger)time
{
    self.hidden = NO;
    NSArray *balloonArr = [[WDTextureManager shareTextureManager]balloonTexturesWithLine:line];
    
    [self removeAllActions];
    
    NSArray *a = [balloonArr subarrayWithRange:NSMakeRange(1, balloonArr.count -1)];
    SKAction *action = [SKAction animateWithTextures:a timePerFrame:0.15];
    action.timingMode = SKActionTimingEaseInEaseOut;
    SKAction *rep = [SKAction repeatActionForever:action];
  
    [self runAction:rep withKey:@"balloon"];
    if (time != 0) {
        [self performSelector:@selector(hiddenTime) withObject:nil afterDelay:time];
    }
}

- (void)setBalloonWithLine:(NSInteger)line
                hiddenTime:(NSInteger)time
             completeBlock:(void (^)(void))completeBlock
{
    self.complete = completeBlock;
    [self setBalloonWithLine:line hiddenTime:time];
}

- (void)setScaleAndPositionWithName:(NSString *)parentName
{
    if ([parentName isEqualToString:kRedBat]) {
        self.xScale = 4.0;
        self.yScale = 4.0;
        WDBaseNode *parent = (WDBaseNode *)self.parent;
        self.position = CGPointMake(0, parent.size.height / 2.0 + self.size.height / 2.0 + 100);
    }
}

@end
