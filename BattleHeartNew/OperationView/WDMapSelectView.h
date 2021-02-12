//
//  WDMapSelectView.h
//  BattleHeartNew
//
//  Created by Mac on 2021/1/5.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDMapSelectView : UIView<UIScrollViewDelegate>
@property (nonatomic,copy)void (^selectSceneBlock)(NSString *sceneName);
@property (nonatomic,copy)void (^cancleBlock)(void);
- (void)setDataWithArr:(NSArray *)images
               textArr:(NSArray *)textArr;
;
@end

NS_ASSUME_NONNULL_END
