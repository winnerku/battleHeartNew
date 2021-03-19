//
//  Boss2Model.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/19.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "Boss2Model.h"

@implementation Boss2Model
- (void)changeArr{
    UIImage *image = [UIImage imageNamed:@"knight_iceAttack"];
    _iceAttackArr = [WDCalculateTool arrWithLine:4 arrange:4 imageSize:CGSizeMake(image.size.width, image.size.height) subImageCount:16 image:image curImageFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"knight_rush_%d",i]];
        SKTexture *texture = [SKTexture textureWithImage:image];
        [arr addObject:texture];
    }
    
    _rushAttackArr = [arr copy];
}
@end
