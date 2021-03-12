//
//  Boss3Model.m
//  begin
//
//  Created by Mac on 2019/6/5.
//  Copyright © 2019年 吴冬. All rights reserved.
//

#import "Boss1Model.h"

@implementation Boss1Model
- (void)setTextures
{
    WDTextureManager *m = [WDTextureManager shareTextureManager];

    self.standArr = [m loadWithImageName:@"npc_Base_stay_" count:9];
    self.sitArr = [m loadWithImageName:@"npc_Base_sit_" count:6];
    self.learnArr = [m loadWithImageName:@"npc_Base_learn_" count:2];
    self.walkArr = [self textureArrayWithName:@"boss3_move_" count:10];
    self.winArr  = [self textureArrayWithName:@"boss3_win_" count:10];
    self.diedArr = [self textureArrayWithName:@"boss3_died_" count:15];
    self.beAttackArr = [self textureArrayWithName:@"boss3_beAttack_" count:4];
    self.attackArr1 = [self textureArrayWithName:@"boss3_attack1_" count:20];
    self.attackArr2 = [self textureArrayWithName:@"boss3_attack2_" count:20];
    self.attackArr3 = [self textureArrayWithName:@"boss3_attack3_" count:20];
    self.attackArr4 = [self textureArrayWithName:@"boss3_attack4_" count:20];
    self.attackArr5 = [self textureArrayWithName:@"boss3_attack5_" count:20];
    self.attackArr6 = [self textureArrayWithName:@"boss3_attack6_" count:20];
    self.attackArr7 = [self textureArrayWithName:@"boss3_attack7_" count:14];
    self.attackArr8 = [self textureArrayWithName:@"boss3_attack8_" count:20];
    self.attackArr9 = [self textureArrayWithName:@"boss3_attack9_" count:20];
    self.shadowTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"meteoriteShadow"]];
    self.meteoriteArr1 = [self textureArrayWithName:@"wuqishi_mete_star" count:5];
    self.meteoriteArr2 = [self textureArrayWithName:@"wuqishi_mete2_" count:6];
    self.windArr = [self textureArrayWithName:@"boss3_wind_" count:12];
    self.cloudTexture = [SKTexture textureWithImage:[UIImage imageNamed:@"wizard_cloud"]];
    self.flashArr = [self textureArrayWithName:@"wizard_flash_" count:3];
    [self questionArr];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 8; i ++) {
        int index = i + 7;
        NSString *name = [NSString stringWithFormat:@"boss3_attack7_%d",index];
        UIImage *image = [UIImage imageNamed:name];
        if (!image) {
            break;
        }
        SKTexture *texture = [SKTexture textureWithImage:image];
        [arr addObject:texture];
    }
    
    self.missArr = arr;
    
    self.musicFlashAction = [SKAction playSoundFileNamed:@"wizard_flash" waitForCompletion:NO];
    self.musicFireAction = [SKAction playSoundFileNamed:@"magic_fire" waitForCompletion:NO];
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

- (NSMutableArray <SKTexture *>*)questionArr{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:72];
    //057_爱给网_aigei_com
    for (int i = 0; i < 72; i ++) {
        NSString *picNameStr = [NSString stringWithFormat:@"%03d_爱给网_aigei_com",i];
        SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:picNameStr]];
        [arr addObject:texture];
    }
    
    return arr;
}

- (void)dealloc
{
//    NSLog(@"我销毁了嘛？");
}

@end
