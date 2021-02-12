//
//  WDTextureManager.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDTextureManager.h"

@implementation WDTextureManager
{
    NSDictionary *_balloonDic;
}
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

- (void)onlyArrowWithPos:(CGPoint)pos
{
    WDBaseNode *arrow  = self.arrowNode;
    WDBaseNode *location = self.locationNode;
       
    [arrow removeAllActions];
    [location removeAllActions];

    CGFloat y = pos.y;
       
    arrow.alpha = 1;
    arrow.position = CGPointMake(pos.x, y);
    arrow.zPosition = 1000;
    SKAction *move1 = [SKAction moveTo:CGPointMake(pos.x,y + 40) duration:0.3];
    SKAction *move2 = [SKAction moveTo:CGPointMake(pos.x, y ) duration:0.3];
    SKAction *seq = [SKAction sequence:@[move1,move2]];
    SKAction *rep = [SKAction repeatActionForever:seq];
    [arrow runAction:rep];
       
   
}

- (void)arrowMoveActionWithPos:(CGPoint)pos
{
    WDBaseNode *arrow  = self.arrowNode;
    WDBaseNode *location = self.locationNode;
       
    [arrow removeAllActions];
    [location removeAllActions];

    CGFloat y = pos.y;
       
    arrow.alpha = 1;
    location.alpha = 1;
    arrow.position = CGPointMake(pos.x, y);
    location.position = CGPointMake(pos.x, y - 80);
       
    SKAction *move1 = [SKAction moveTo:CGPointMake(pos.x,y + 40) duration:0.3];
    SKAction *move2 = [SKAction moveTo:CGPointMake(pos.x, y ) duration:0.3];
    SKAction *seq = [SKAction sequence:@[move1,move2]];
    SKAction *rep = [SKAction repeatActionForever:seq];
    [arrow runAction:rep];
       
    SKAction *alpha1 = [SKAction fadeAlphaTo:0.6 duration:0.3];
    SKAction *alpha2 = [SKAction fadeAlphaTo:1 duration:0.3];
    SKAction *seq1 = [SKAction sequence:@[alpha1,alpha2]];
    SKAction *rep2 = [SKAction repeatActionForever:seq1];
    [location runAction:rep2];
}

- (void)hiddenArrow
{
     WDBaseNode *arrow  = self.arrowNode;
     WDBaseNode *location = self.locationNode;
            
     [arrow removeAllActions];
     [location removeAllActions];
            
     arrow.alpha = 0;
     location.alpha = 0;
}

- (void)setMonsterMovePointWithName:(NSString *)name
                            monster:(WDBaseNode *)monster
{
    if ([name isEqualToString:kRedBat]) {
        [self setRedBatPosition:monster];
    }
}



- (void)setRedBatPosition:(WDBaseNode *)monster
{
    CGFloat rY = 0;
    CGFloat a = arc4random() % 15;
    CGFloat rX = a + 30;

    
    if (self.redBatY == 20) {
        self.redBatY = -20;
        rY = -20 - a;
    }else{
        self.redBatY = 20;
        rY = 20 + a;
    }
    
    monster.randomDistanceX = rX;
    monster.randomDistanceY = rY;
}

- (NSArray *)balloonTexturesWithLine:(NSInteger)line
{
    if (!_balloonDic) {
        UIImage *image = [UIImage imageNamed:@"Balloon"];
        NSArray *arr = [WDCalculateTool arrWithLine:10 arrange:8 imageSize:CGSizeMake(image.size.width, 48 * 10) subImageCount:80 image:image curImageFrame:CGRectMake(0, 0, image.size.width, 48 * 10)];
        

        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:80];
        for (int i = 0; i < 10; i ++) {
            
            NSArray *subArr = [arr subarrayWithRange:NSMakeRange(i * 8, 8)];
            NSString *key = [NSString stringWithFormat:@"%d",i+1];
            [dic setValue:subArr forKey:key];
        }
        
        _balloonDic = dic;
    }
    
    
    NSString *key = [NSString stringWithFormat:@"%ld",line];
    return _balloonDic[key];
}

- (void)releaseKinghtModel
{
    _kinghtModel = nil;
}

- (void)releaseIceModel{
    _iceWizardModel = nil;
}

- (void)releaseArcherModel
{
    _archerModel = nil;
}

- (void)releaseRedBatModel
{
    _redBatModel = nil;
}

- (void)releaseStoneModel
{
    _stoneModel = nil;
}

- (void)releasePassWordModel
{
    _passDoorArr = nil;
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


/// 冰女巫
- (WDIceWizardModel *)iceWizardModel
{
    if (!_iceWizardModel) {
        
        _iceWizardModel = [[WDIceWizardModel alloc] init];
        [_iceWizardModel setNormalTexturesWithName:kIceWizard standNumber:10 runNumber:0 walkNumber:10 diedNumber:0 attack1Number:9];
    }
    
    return _iceWizardModel;
}


/// 弓箭手
- (WDArcherModel *)archerModel
{
    if (!_archerModel) {
        _archerModel = [[WDArcherModel alloc] init];
        [_archerModel setNormalTexturesWithName:kArcher standNumber:10 runNumber:0 walkNumber:10 diedNumber:0 attack1Number:10];
    }
    
    return _archerModel;
}

/// 石头人
- (WDStoneModel *)stoneModel
{
    if (!_stoneModel) {
        _stoneModel = [[WDStoneModel alloc] init];
        [_stoneModel setNormalTexturesWithName:kStone standNumber:0 runNumber:0 walkNumber:6 diedNumber:0 attack1Number:6];
        _stoneModel.appearArr = [self loadWithImageName:@"appear_" count:15];
        _stoneModel.stoneDiedArr = [self loadWithImageName:@"die_" count:7];
    }
    
    return _stoneModel;
}

#pragma mark - 怪物 -
- (WDRedBatModel *)redBatModel
{
    if (!_redBatModel) {
        _redBatModel = [[WDRedBatModel alloc] init];
        [_redBatModel setNormalTexturesWithName:kRedBat standNumber:12 runNumber:0 walkNumber:8 diedNumber:8 attack1Number:7];
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

- (SKTexture *)demageTexture
{
    if (!_demageTexture) {
        _demageTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"demage1"]];
    }
    
    return _demageTexture;
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

- (NSArray<SKTexture *> *)passDoorArr
{
    if (!_passDoorArr) {
        _passDoorArr = [WDCalculateTool curImageWithImage:[UIImage imageNamed:@"passDoor"] line:5 arrange:1 itemSize:CGSizeMake(256, 128) count:5];
    }
    
    return _passDoorArr;
}

- (void)loadCommonTexture
{
    _smokeArr = [self loadWithImageName:@"smoke_" count:14];
//    _lightArr = [self loadWithImageName:@"light_" count:23];
//    _greenArr = [self loadWithImageName:@"green_light_" count:16];
 
    _clickArr = [WDCalculateTool curImageWithImage:[UIImage imageNamed:@"hand2"] line:1 arrange:2 itemSize:CGSizeMake(128, 128) count:2];
}



- (NSMutableArray *)loadWithImageName:(NSString *)name
                                count:(NSInteger)count
{
    NSMutableArray *muAr = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        NSString *nameS = [NSString stringWithFormat:@"%@%d",name,i+1];
        SKTexture *texture1 = [SKTexture textureWithImage:[UIImage imageNamed:nameS]];
        [muAr addObject:texture1];
    }
    
    return muAr;
}



@end
