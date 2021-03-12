//
//  Boss3Model.h
//  begin
//
//  Created by Mac on 2019/6/5.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "WDBaseNodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Boss1Model : WDBaseNodeModel
@property (nonatomic,copy)NSArray *sitArr;
@property (nonatomic,copy)NSArray *learnArr;
@property (nonatomic,copy)NSArray <SKTexture *>*winArr;
@property (nonatomic,copy)NSArray <SKTexture *>*beAttackArr;
@property (nonatomic,copy)NSArray <SKTexture *>*missArr;

@property (nonatomic,copy)NSArray <SKTexture *>*attackArr1;
@property (nonatomic,copy)NSArray <SKTexture *>*attackArr2;
@property (nonatomic,copy)NSArray <SKTexture *>*attackArr3;
@property (nonatomic,copy)NSArray <SKTexture *>*attackArr4;
@property (nonatomic,copy)NSArray <SKTexture *>*attackArr5;
@property (nonatomic,copy)NSArray <SKTexture *>*attackArr6;
@property (nonatomic,copy)NSArray <SKTexture *>*attackArr7;
@property (nonatomic,copy)NSArray <SKTexture *>*attackArr8;
@property (nonatomic,copy)NSArray <SKTexture *>*attackArr9;

@property (nonatomic,strong)SKTexture *shadowTexture;
@property (nonatomic,copy)NSArray <SKTexture *>*meteoriteArr1;
@property (nonatomic,copy)NSArray <SKTexture *>*meteoriteArr2;

@property (nonatomic,copy)NSArray <SKTexture *>*windArr;
@property (nonatomic,strong)SKTexture *cloudTexture;
@property (nonatomic,copy)NSArray <SKTexture *>*flashArr;

@property (nonatomic,strong)SKAction *musicFlashAction;
@property (nonatomic,strong)SKAction *musicFireAction;

- (void)setTextures;

@end


NS_ASSUME_NONNULL_END
