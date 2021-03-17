//
//  WDBaseScene+Moive.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/17.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBaseScene+Moive.h"

@implementation WDBaseScene (Moive)
- (void)ninjaMoive
{
    self.ninjaNode.isPubScene = YES;
    self.ninjaNode.physicsBody.categoryBitMask = 1;
    self.archerNode.arrowNode.hidden = YES;
    self.ninjaNode.arrowNode.hidden = NO;
    [self.iceWizardNode.talkNode setText:@"" hiddenTime:0];
    [self.kNightNode.talkNode setText:@"" hiddenTime:0];
    [self.archerNode.talkNode  setText:@"" hiddenTime:0];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kNinjaFirst];
        self.ninjaNode.position = CGPointMake(1400, 300);
        self.archerNode.position = CGPointMake(800, 300);
        self.selectNode = self.ninjaNode;
        [self.bgNode addChild:self.ninjaNode];
    self.kNightNode.xScale = fabs(self.kNightNode.xScale);
    self.kNightNode.isRight = YES;
    self.ninjaNode.xScale = -fabs(self.ninjaNode.xScale);
    self.ninjaNode.isRight = NO;
    __weak typeof(self)weakSelf = self;
    [self.ninjaNode.talkNode setText:@"之前碰到的骷髅\n只是小罗罗。" hiddenTime:3 completeBlock:^{
        [weakSelf.ninjaNode.talkNode setText:@"有幕后主使\n找到并消灭它" hiddenTime:3 completeBlock:^{
            [weakSelf.ninjaNode.talkNode setText:@"传送门已开启\n我会一起出发" hiddenTime:3 completeBlock:^{
                            
            }];
        }];
    }];
}
@end
