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

#pragma mark - 玩家人物 -
/// - 骑士 texture -
- (WDKinghtModel *)kinghtModel
{
    if (!_kinghtModel) {
        
        _kinghtModel = [[WDKinghtModel alloc] init];
        [_kinghtModel setNormalTexturesWithName:kKinght standNumber:10 runNumber:0 walkNumber:10 diedNumber:0 attack1Number:10];
    }
    
    return _kinghtModel;
}

- (WDIceWizardModel *)iceWizardModel
{
    if (!_iceWizardModel) {
        
        _iceWizardModel = [[WDIceWizardModel alloc] init];
        [_iceWizardModel setNormalTexturesWithName:kIceWizard standNumber:10 runNumber:0 walkNumber:10 diedNumber:0 attack1Number:9];
    }
    
    return _iceWizardModel;
}

#pragma mark - 怪物 -
- (WDRedBatModel *)redBatModel
{
    if (!_redBatModel) {
        _redBatModel = [[WDRedBatModel alloc] init];
        [_redBatModel setNormalTexturesWithName:kRedBat standNumber:12 runNumber:0 walkNumber:8 diedNumber:0 attack1Number:7];
    }
    
    return _redBatModel;
}


#pragma mark - 点击位置 -
- (WDBaseNode *)arrowNode
{
    if (!_arrowNode) {
        _arrowNode = [WDBaseNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"arrow"]]];
        _arrowNode.zPosition = 2;
        _arrowNode.name = @"arrow";
        _arrowNode.alpha = 0;
    }
    
    return _arrowNode;
}

- (WDBaseNode *)locationNode
{
    if (!_locationNode) {
        _locationNode = [WDBaseNode spriteNodeWithTexture:[SKTexture textureWithImage:[UIImage imageNamed:@"biaoji"]]];
        _locationNode.zPosition = 1;
        _locationNode.name = @"location";
        _locationNode.alpha = 0;
    }
    
    return _locationNode;
}

@end
