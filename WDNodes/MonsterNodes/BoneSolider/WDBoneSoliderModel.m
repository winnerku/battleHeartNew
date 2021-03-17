//
//  WDBoneSoliderModel.m
//  BattleHeartNew
//
//  Created by Mac on 2021/3/17.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDBoneSoliderModel.h"

@implementation WDBoneSoliderModel
- (void)changeArr
{
    UIImage *image = [UIImage imageNamed:@"define_state"];
    _defineArr = [WDCalculateTool arrWithLine:4 arrange:4 imageSize:CGSizeMake(image.size.width, image.size.height) subImageCount:16 image:image curImageFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
   
}
@end
