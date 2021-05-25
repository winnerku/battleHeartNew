//
//  Boss3Model.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/25.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "Boss3Model.h"

@implementation Boss3Model
- (void)changeArr
{
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:kZombie];
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *arr2 = [NSMutableArray array];

    for (int i = 0; i < 5; i ++) {
        NSString *name = [NSString stringWithFormat:@"%@_posion_%d",kZombie,i];
        NSString *name2 = [NSString stringWithFormat:@"%@_claw_%d",kZombie,i];
        [arr addObject:[atlas textureNamed:name]];
        [arr2 addObject:[atlas textureNamed:name2]];
    }
    
    self.poisonArr = [arr copy];
    self.clawArr   = [arr2 copy];
}
@end
