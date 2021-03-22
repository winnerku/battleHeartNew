//
//  WDBaseNodeModel.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseNodeModel.h"

@implementation WDBaseNodeModel

- (void)changeArr
{
    
}

- (void)setSkillTexturesWithName:(NSString *)name
                    skill1Number:(int)skill1Number
                    skill2Number:(int)skill2Number
                    skill3Number:(int)skill3Number
                    skill4Number:(int)skill4Number
                    skill5Number:(int)skill5Number
{
    NSArray *bigArr = @[@(skill1Number),@(skill2Number),@(skill3Number),@(skill4Number),@(skill5Number)];
    int big = 0;
    for (NSNumber *number in bigArr) {
        if ([number intValue] > big) {
            big = [number intValue];
        }
    }
    
    NSMutableArray *skill1Arr = [NSMutableArray array];
    NSMutableArray *skill2Arr = [NSMutableArray array];
    NSMutableArray *skill3Arr = [NSMutableArray array];
    NSMutableArray *skill4Arr = [NSMutableArray array];
    NSMutableArray *skill5Arr = [NSMutableArray array];

    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:name];
    for (int i = 0; i < big; i ++) {
        if (i < skill1Number) {
            [self createNameWithString:name actionName:@"skill1" index:i arr:skill1Arr atlas:atlas];
        }
        
        if (i < skill2Number) {
            [self createNameWithString:name actionName:@"skill2" index:i arr:skill2Arr atlas:atlas];
        }
        
        if (i < skill3Number) {
            [self createNameWithString:name actionName:@"skill3" index:i arr:skill3Arr atlas:atlas];
        }
        
        if (i < skill4Number) {
            [self createNameWithString:name actionName:@"skill4" index:i arr:skill4Arr atlas:atlas];
        }
        
        if (i < skill5Number) {
            [self createNameWithString:name actionName:@"skill5" index:i arr:skill5Arr atlas:atlas];
        }
    }
    
    self.skill1Arr = [skill1Arr copy];
    self.skill2Arr = [skill2Arr copy];
    self.skill3Arr = [skill3Arr copy];
    self.skill4Arr = [skill4Arr copy];
    self.skill5Arr = [skill5Arr copy];

}

- (void)setEffectTexturesWithName:(NSString *)name
                     skill1Number:(int)skill1Number
                     skill2Number:(int)skill2Number
                     skill3Number:(int)skill3Number
                     skill4Number:(int)skill4Number
                     skill5Number:(int)skill5Number
{
    NSArray *bigArr = @[@(skill1Number),@(skill2Number),@(skill3Number),@(skill4Number),@(skill5Number)];
    int big = 0;
    for (NSNumber *number in bigArr) {
        if ([number intValue] > big) {
            big = [number intValue];
        }
    }
    
    NSMutableArray *skill1Arr = [NSMutableArray array];
    NSMutableArray *skill2Arr = [NSMutableArray array];
    NSMutableArray *skill3Arr = [NSMutableArray array];
    NSMutableArray *skill4Arr = [NSMutableArray array];
    NSMutableArray *skill5Arr = [NSMutableArray array];

    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:name];
    for (int i = 0; i < big; i ++) {
        if (i < skill1Number) {
            [self createNameWithString:name actionName:@"effect1" index:i arr:skill1Arr atlas:atlas];
        }
        
        if (i < skill2Number) {
            [self createNameWithString:name actionName:@"effect2" index:i arr:skill2Arr atlas:atlas];
        }
        
        if (i < skill3Number) {
            [self createNameWithString:name actionName:@"effect3" index:i arr:skill3Arr atlas:atlas];
        }
        
        if (i < skill4Number) {
            [self createNameWithString:name actionName:@"effect4" index:i arr:skill4Arr atlas:atlas];
        }
        
        if (i < skill5Number) {
            [self createNameWithString:name actionName:@"effect5" index:i arr:skill5Arr atlas:atlas];
        }
    }
    
    self.effect1Arr = [skill1Arr copy];
    self.effect2Arr = [skill2Arr copy];
    self.effect3Arr = [skill3Arr copy];
    self.effect4Arr = [skill4Arr copy];
    self.effect5Arr = [skill5Arr copy];
}

- (void)setNormalTexturesWithName:(NSString *)name
                      standNumber:(int)standNumber
                        runNumber:(int)runNumber
                       walkNumber:(int)walkNumber
                       diedNumber:(int)diedNumber
                    attack1Number:(int)attackNumber
{
    
    NSArray *bigArr = @[@(standNumber),@(runNumber),@(walkNumber),@(diedNumber),@(attackNumber)];
    int big = 0;
    for (NSNumber *number in bigArr) {
        if ([number intValue] > big) {
            big = [number intValue];
        }
    }
    
    NSMutableArray *standArr = [NSMutableArray array];
    NSMutableArray *walkArr = [NSMutableArray array];
    NSMutableArray *diedArr = [NSMutableArray array];
    NSMutableArray *attackArr1 = [NSMutableArray array];
    
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:name];
    for (int i = 0; i < big; i ++) {
        
        /// 站立
        if (i < standNumber) {
            [self createNameWithString:name actionName:@"stand" index:i arr:standArr atlas:atlas];
        }
        
        /// 移动
        if (i < walkNumber) {
            [self createNameWithString:name actionName:@"walk" index:i arr:walkArr atlas:atlas];
        }
        
        /// 死亡
        if (i < diedNumber) {
            [self createNameWithString:name actionName:@"died" index:i arr:diedArr atlas:atlas];
        }
        
        /// 攻击
        if (i < attackNumber) {
            [self createNameWithString:name actionName:@"attack1" index:i arr:attackArr1 atlas:atlas];
        }
        
    }
    
    self.standArr = [standArr copy];
    self.walkArr  = [walkArr copy];
    self.diedArr  = [diedArr copy];
    self.attackArr1 = [attackArr1 copy];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        NSString *reduce = [NSString stringWithFormat:@"reduceSpeed_%d",i];
        SKTexture *texture = [SKTexture textureWithImage:[UIImage imageNamed:reduce]];
        [arr addObject:texture];
    }
    
    self.statusReduceArr = [arr copy];

}

- (void)createNameWithString:(NSString *)name
                  actionName:(NSString *)behaviorName
                       index:(int)index
                         arr:(NSMutableArray *)arr
                       atlas:(SKTextureAtlas *)atlas
{
    NSString *textureName = [NSString stringWithFormat:@"%@_%@_%d",name,behaviorName,index];
    [arr addObject:[atlas textureNamed:textureName]];
}

- (NSMutableArray *)stateName:(NSString *)stateName
                  textureName:(NSString *)name
                       number:(int)number
{
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:number];
    for (int i = 0; i < number; i ++) {
        NSString *textureName = [NSString stringWithFormat:@"%@_%@_%d",name,stateName,i];
//        NSString *urlPath = [[NSBundle mainBundle]pathForResource:textureName ofType:@"png"];
//        NSData *data = [NSData dataWithContentsOfFile:urlPath];
        UIImage *image = [UIImage imageNamed:textureName];
        //image = [self seacalImageWithData:data withSize:CGSizeMake(image.size.width / 2.0, image.size.height / 2.0) scale:0 orientation:UIImageOrientationUp];
        SKTexture *texture = [SKTexture textureWithImage:image];
        [textures addObject:texture];
        
    }
    
    return textures;
}




-(UIImage *)seacalImageWithData:(NSData *)data withSize:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation{
    CGFloat maxPixeSize = MAX(size.width, size.height);
    //读取图像源
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
    NSDictionary *options = @{(__bridge id)kCGImageSourceCreateThumbnailFromImageAlways:(__bridge id)kCFBooleanTrue,(__bridge id)kCGImageSourceThumbnailMaxPixelSize:[NSNumber numberWithFloat:maxPixeSize]};
    //创建缩略图，根据字典
    /*
     options中的
     kCGImageSourceThumbnailMaxPixelSize 指定缩略图的最大宽度和高度(以像素为单位)。如果此键未指定，缩略图的宽度和高度为不受限制，缩略图可能和图片本身一样大。如果指定，此键的值必须是CFNumberRef。* /
     kCGImageSourceCreateThumbnailFromImageAlways *如果图像源文件中存在缩略图。缩略图将由完整图像创建，受kCGImageSourceThumbnailMaxPixelSize——如果没有最大像素大小指定，则缩略图将为完整图像的大小，可能不是你想要的。这个键的值必须是CFBooleanRef;这个键的默认值是kCFBooleanFalse。
     
     */
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(sourceRef, 0, (__bridge CFDictionaryRef)options);
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef scale:scale orientation:orientation];
    return resultImage;
    
}

@end
