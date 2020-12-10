//
//  WDBaseScene.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDBaseScene.h"

@implementation WDBaseScene

- (void)didMoveToView:(SKView *)view
{
    
    //屏幕适配
    CGFloat screenWidth = kScreenWidth * 2.0;
    CGFloat screenHeight = kScreenHeight * 2.0;
    
    _bgNode = (SKSpriteNode *)[self childNodeWithName:@"bgNode"];
    NSString *mapName = [NSString stringWithFormat:@"%@.jpg",NSStringFromClass([self class])];
    _bgNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:mapName]];
    
    //这里选取的背景图片都是长远远大于宽，所以只适配高度即可
    self.size = CGSizeMake(screenWidth, screenHeight);
    CGFloat scale = screenHeight / _bgNode.size.height;
    _bgNode.size = CGSizeMake(_bgNode.size.width * scale, screenHeight);
    
}



- (void)touchDownAtPoint:(CGPoint)pos {
    
    if (_selectNode) {
        [_selectNode moveActionWithPoint:pos];
    }
    
    WDBaseNode *node = (WDBaseNode *)[self nodeAtPoint:pos];
    if ([node isKindOfClass:[WDUserNode class]]) {
        
        _selectNode = node;
        
    }
    
    
    
    
    
    NSLog(@"%@",node.name);
    
}

- (void)touchMovedToPoint:(CGPoint)pos {
    
}

- (void)touchUpAtPoint:(CGPoint)pos {
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}

#pragma mark - 骑士 -
- (WDKinghtNode *)kNightNode
{
    if (!_kNightNode) {
        _kNightNode = [WDKinghtNode initWithModel:[WDTextureManager shareTextureManager].kinghtModel];
    }
    
    return _kNightNode;
}


@end
