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
- (void)setNormalTexturesWithName:(NSString *)name
                      standNumber:(int)standNumber
                        runNumber:(int)runNumber
                       walkNumber:(int)walkNumber
                       diedNumber:(int)diedNumber
                    attack1Number:(int)attackNumber
{
    
    
    self.standArr = [self stateName:@"stand" textureName:name number:standNumber];
    self.runArr   = [self stateName:@"run" textureName:name number:runNumber];
    self.walkArr = [self stateName:@"walk" textureName:name number:walkNumber];
    self.diedArr = [self stateName:@"died" textureName:name number:diedNumber];
    self.attackArr1 = [self stateName:@"attack1" textureName:name number:attackNumber];

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
