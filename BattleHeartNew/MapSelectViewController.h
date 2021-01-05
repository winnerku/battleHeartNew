//
//  MapSelectViewController.h
//  BattleHeartNew
//
//  Created by Mac on 2021/1/5.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapSelectViewController : UIViewController
@property (nonatomic,copy)void (^selectSceneBlock)(NSString *sceneName);

@end

NS_ASSUME_NONNULL_END
