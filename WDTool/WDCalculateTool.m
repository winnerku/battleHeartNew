//
//  WDCalculateTool.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/11.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDCalculateTool.h"
#import "WDBaseScene.h"

@implementation WDCalculateTool

+ (CGPoint)randomPositionWithNode:(WDBaseNode *)node
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    int ax = 1;
    int ay = 1;
    if (arc4random() % 2 == 0) {
        ax = -1;
    }
    if (arc4random() % 2 == 0) {
        ay = -1;
    }
    
    x = (arc4random() % (int)kScreenWidth);
    y = (arc4random() % (int)kScreenHeight);
    
    x = x * ax;
    y = y * ay;

    
    WDTextureManager *m = [WDTextureManager shareTextureManager];

    if (x + node.realSize.width  > kScreenWidth - m.mapBigX) {
        x = kScreenWidth - node.realSize.width - m.mapBigX;
    }else if(x - node.realSize.width  < -kScreenWidth + m.mapBigX){
        x = -kScreenWidth + node.realSize.width + m.mapBigX;
    }
    
    if (y + node.realSize.height  > kScreenHeight - m.mapBigY) {
        y = kScreenHeight - node.realSize.height - m.mapBigX;
    }else if(y - node.realSize.height  < -kScreenHeight + m.mapBigY){
        y = -kScreenHeight + node.realSize.height + m.mapBigY;
    }
    
    if (x < 0) {
//        NSLog(@"我是是is哒哒哒哒哒哒多多多多多多多多多多多多多多多");
    }
    
    return CGPointMake(x, y);
}

+ (CGPoint)calculateBigPoint:(CGPoint)pos
{
    CGFloat x = pos.x;
    CGFloat y = pos.y;
    
    WDTextureManager *m = [WDTextureManager shareTextureManager];
    if (x < - kScreenWidth + 120) {
        x = - kScreenWidth + 120;
    }else if(x > kScreenWidth - 90){
        x = kScreenWidth - 90;
    }
    
    if (y > kScreenHeight - m.mapBigY_Up) {
        y = kScreenHeight - m.mapBigY_Up;
    }else if(y < -kScreenHeight + m.mapBigY_down){
        y = - kScreenHeight + m.mapBigY_down;
    }
    
    return CGPointMake(x, y);
}

+ (CGFloat)nodeDistance:(WDBaseNode *)node1 seconde:(WDBaseNode *)node2
{
    CGFloat xDistance = fabs(node1.position.x - node2.position.x);
    CGFloat yDistance = fabs(node1.position.y - node2.position.y);
    
    CGFloat distance = sqrt(xDistance * xDistance + yDistance * yDistance);
    return distance;
    
}

+ (BOOL)nodeCanAttackWithNode:(WDBaseNode *)node1
                      seconde:(WDBaseNode *)node2
{
    
    CGFloat xDistance = fabs(node1.position.x - node2.position.x);
    CGFloat yDistance = fabs(node1.position.y - node2.position.y);
    
    CGFloat xR = node1.realSize.width / 2.0 + node2.realSize.width / 2.0 + 5;
    CGFloat yR = node1.realSize.height / 2.0 + node2.realSize.height / 2.0 + 5;
    
    if (xDistance < xR && yDistance < yR) {
        return YES;
    }else{
        return NO;
    }
    
}

+ (CGPoint)calculateUserMovePointWithUserNode:(WDBaseNode *)user
                                  monsterNode:(WDBaseNode *)monster
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGPoint userPoint = user.position;
    CGPoint monsterPoint = monster.position;
    
    /// 玩家需要前进到的坐标距离
    CGFloat minDistance = user.realSize.width / 2.0 + monster.realSize.width / 2.0 + monster.randomDistanceX;
    //CGFloat minY = monster.randomDistanceY;
    
    //近战
    if (user.attackDistance == 0) {
        
        //玩家在左边，怪物在右边
        if (userPoint.x < monsterPoint.x) {
        
            
            x = monsterPoint.x - minDistance - fabs(monster.realCenterX) * monster.directionNumber;
            
            user.direction = @"right";
            user.isRight = YES;
            user.xScale =  fabs(user.xScale);
            
        }else{
            
            //玩家在右边，怪物在左边
            x = monsterPoint.x + minDistance - fabs(monster.realCenterX) * monster.directionNumber;
            
            user.direction = @"left";
            user.isRight = NO;
            user.xScale = -fabs(user.xScale);
        }
        
        y = monsterPoint.y + user.upPositionY;

    }else{
        //远程
        //玩家在右边，怪物在左边
        if (userPoint.x < monsterPoint.x) {
        
            
            user.direction = @"right";
            user.isRight = YES;
            user.xScale =  fabs(user.xScale);
            
        }else{
            
            //玩家在左边，怪物在右边
            
            user.direction = @"left";
            user.isRight = NO;
            user.xScale = -fabs(user.xScale);
        }
        
        x = user.position.x;
        y = user.position.y;
        
    }
    
    
    
    
    return CGPointMake(x, y);
}

+ (WDBaseNode *)searchMonsterNearNode:(WDBaseNode *)node
{
    NSArray *childNodes = node.parent.children;
    WDBaseNode *target = nil;
    CGFloat distance = 10000;
    for (WDBaseNode *nearN in childNodes) {
        if ([nearN isKindOfClass:[WDMonsterNode class]]) {
            CGFloat d = [WDCalculateTool distanceBetweenPoints:nearN.position seconde:node.position];
            if (distance > d) {
                distance = d;
                target = nearN;
            }
        }
    }
    
    
    return target;
}

+ (WDBaseNode *)searchUserRandomNode:(WDBaseNode *)node
{
    WDBaseScene *scene = (WDBaseScene *)node.parent;
    int index = arc4random() % scene.userArr.count;
    if (index >= scene.userArr.count) {
        return nil;
    }else{
        return scene.userArr[index];
    }
}

+ (WDBaseNode *)searchUserNearNode:(WDBaseNode *)node
{
    NSArray *childNodes = node.parent.children;
    WDBaseNode *target = nil;
    CGFloat distance = 10000;
    for (WDBaseNode *nearN in childNodes) {
        if ([nearN isKindOfClass:[WDUserNode class]] && !(nearN.state & SpriteState_dead)) {
            CGFloat d = [WDCalculateTool distanceBetweenPoints:nearN.position seconde:node.position];
            if (distance > d) {
                distance = d;
                target = nearN;
            }
        }
    }
    
    
    return target;
}



+ (CGPoint)calculateMonsterMovePointWithMonsterNode:(WDBaseNode *)monster
                                           userNode:(WDBaseNode *)user
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGPoint userPoint = user.position;
    CGPoint monsterPoint = monster.position;
    
    CGFloat minDistance = user.realSize.width / 2.0 + monster.realSize.width / 2.0 + monster.randomDistanceX + monster.realCenterX * monster.directionNumber;

    //玩家在右边，怪物在左边，怪物要走在玩家靠左边边的位置
    if (userPoint.x > monsterPoint.x) {
    
        x = userPoint.x - minDistance;
        
        monster.direction = @"right";
        monster.isRight = YES;
        monster.xScale =  fabs(monster.xScale);
        
    }else{
        
        //玩家在左边，怪物在右边，怪物要走在玩家靠右边的位置
        x = userPoint.x + minDistance;
        
        monster.direction = @"left";
        monster.isRight = NO;
        monster.xScale = -fabs(monster.xScale);
    }
    
    y = userPoint.y + monster.randomDistanceY;
    
    
    return CGPointMake(x, y);
}


+ (CGFloat)calculateZposition:(WDBaseNode *)node
{
    CGFloat y = node.position.y;
    
    if (node.position.y < 0) {
        y = 2 * kScreenHeight - (kScreenHeight + node.position.y);
    }else{
        y = 2 * kScreenHeight - (kScreenHeight + node.position.y);
    }
    
    return y;
}

+ (CGFloat)distanceBetweenPoints:(CGPoint)first
                         seconde:(CGPoint)second
{
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
}

+ (CGFloat)angleForStartPoint:(CGPoint)startPoint
                     EndPoint:(CGPoint)endPoint{
    
    CGPoint Xpoint = CGPointMake(startPoint.x + 100, startPoint.y);
    
    CGFloat a = endPoint.x - startPoint.x;
    CGFloat b = endPoint.y - startPoint.y;
    CGFloat c = Xpoint.x - startPoint.x;
    CGFloat d = Xpoint.y - startPoint.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
    if (startPoint.y>endPoint.y) {
        rads = -rads;
    }
    return rads;
}

+ (NSArray *)curImageWithImage:(UIImage *)image
                          line:(NSInteger)line
                       arrange:(NSInteger)arrange
                      itemSize:(CGSize)imageSize
                         count:(NSInteger)count
{
    CGImageRef imageRef1 = [image CGImage];

    
    UIImage *curImage = [UIImage imageWithCGImage:imageRef1];
    
    CGImageRef imageRef = [curImage CGImage];
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    NSMutableArray *imagesArr = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i < count; i ++) {
           
        CGFloat x = i % arrange * width;
        CGFloat y = i / arrange * height;
       
        CGRect frame = CGRectMake(x, y, width, height);
        CGImageRef subImage = CGImageCreateWithImageInRect(imageRef, frame);
        UIImage *newImage = [UIImage imageWithCGImage:subImage];
        SKTexture *texture = [SKTexture textureWithImage:newImage];
        [imagesArr addObject:texture];
           
        dispatch_async(dispatch_get_main_queue(), ^{
            //CGImageRelease(subImage);
        });

    }
    
    
    return imagesArr;
}

+ (NSArray *)arrWithLine:(NSInteger)line
                 arrange:(NSInteger)arrange
               imageSize:(CGSize)imageSize
           subImageCount:(NSInteger)count
                   image:(UIImage *)image
           curImageFrame:(CGRect)frame{
    
   // UIImage *passImage = [UIImage imageNamed:@"chest1"];
    CGImageRef imageRef1 = [image CGImage];

    
    CGImageRef subImage = CGImageCreateWithImageInRect(imageRef1, frame);
    UIImage *curImage = [UIImage imageWithCGImage:subImage];
    
    CGImageRef imageRef = [curImage CGImage];
    
    CGFloat width = imageSize.height / (CGFloat)line;
    CGFloat height = imageSize.width / (CGFloat)arrange;
    
    NSMutableArray *imagesArr = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i < count; i ++) {
           
        CGFloat x = i % arrange * width;
        CGFloat y = i / arrange * height;
       
        CGRect frame = CGRectMake(x, y, width, height);
        CGImageRef subImage = CGImageCreateWithImageInRect(imageRef, frame);
        UIImage *newImage = [UIImage imageWithCGImage:subImage];
        SKTexture *texture = [SKTexture textureWithImage:newImage];
        [imagesArr addObject:texture];
           
        dispatch_async(dispatch_get_main_queue(), ^{
            //CGImageRelease(subImage);
        });

    }
    
    
    return imagesArr;
    
}

+ (CGFloat)calculateReduceNumberWithAttack:(int)attack
                               floatNumber:(int)floatNumber
{
    int a = 1;
    if (arc4random() % 2 == 0) {
        a = -1;
    }
    
    if (floatNumber <= 0) {
        floatNumber = 1;
    }
    
    CGFloat numer = attack + (arc4random() % floatNumber) * a;
    if (numer > 1000) {
        NSLog(@"攻击力%lf",numer);
    }
    return numer;
}

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString {
  NSString *cString = [[inColorString
      stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

  // String should be 6 or 8 characters
  if ([cString length] < 6)
    return [UIColor whiteColor];

  // strip 0X if it appears
  if ([cString hasPrefix:@"0X"])
    cString = [cString substringFromIndex:2];
  if ([cString hasPrefix:@"#"])
    cString = [cString substringFromIndex:1];
  if ([cString length] != 6)
    return [UIColor whiteColor];

  UIColor *result = nil;
  unsigned int colorCode = 0;
  unsigned char redByte, greenByte, blueByte;

  if (nil != cString) {
    NSScanner *scanner = [NSScanner scannerWithString:cString];
    (void)[scanner scanHexInt:&colorCode]; // ignore error
  }
  redByte = (unsigned char)(colorCode >> 16);
  greenByte = (unsigned char)(colorCode >> 8);
  blueByte = (unsigned char)(colorCode); // masks off high bits
  result = [UIColor colorWithRed:(float)redByte / 0xff
                           green:(float)greenByte / 0xff
                            blue:(float)blueByte / 0xff
                           alpha:1.0];
  return result;
}

@end
