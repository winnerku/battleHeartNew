//
//  Boss4Model.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/26.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "Boss4Model.h"

@implementation Boss4Model
- (void)changeArr
{
    self.cloudTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"wizard_cloud"]];
    self.flashArr = [self textureArrayWithName:@"wizard_flash_" count:3];
    UIImage *image = [UIImage imageNamed:@"iceshield"];
    _defineArr = [WDCalculateTool arrWithLine:4 arrange:4 imageSize:CGSizeMake(image.size.width, image.size.height) subImageCount:16 image:image curImageFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    self.aim = [SKTexture textureWithImage:[UIImage imageNamed:@"ox_aim"]];
    self.aim2 = [SKTexture textureWithImage:[UIImage imageNamed:@"ox_aim2"]];
    self.beAttack = [SKTexture textureWithImage:[UIImage imageNamed:@"ox_beAttack"]];
}


- (NSMutableArray <SKTexture *>*)textureArrayWithName:(NSString *)name
                                                count:(NSInteger)count
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        NSString *picNameStr = [NSString stringWithFormat:@"%@%d",name,i+1];
        UIImage *image = [UIImage imageNamed:picNameStr];
        if (!image) {
            break;
        }
        SKTexture *texture = [SKTexture textureWithImage:image];
        [arr addObject:texture];
    }
    
    return arr;
}
@end
