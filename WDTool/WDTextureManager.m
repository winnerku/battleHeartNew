//
//  WDTextureManager.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDTextureManager.h"

@implementation WDTextureManager

static WDTextureManager *textureManager = nil;

+ (WDTextureManager *)shareTextureManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!textureManager) {
            textureManager = [[WDTextureManager alloc] init];
        }
    });
    
    return textureManager;
}

#pragma mark - 骑士 texture -
- (WDKinghtModel *)kinghtModel
{
    if (!_kinghtModel) {
        
        _kinghtModel = [[WDKinghtModel alloc] init];
        [_kinghtModel setNormalTexturesWithName:kKinght standNumber:10 runNumber:0 walkNumber:10 diedNumber:0];
    }
    
    return _kinghtModel;
}

@end
