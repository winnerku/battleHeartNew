//
//  BattleScene_1.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "BattleScene_1.h"

@implementation BattleScene_1

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    [self addChild:self.kNightNode];
    
    self.kNightNode.position = CGPointMake(0, 0);
    self.kNightNode.zPosition = self.size.height - self.kNightNode.position.y;
    
}

@end
