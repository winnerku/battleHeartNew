//
//  WDLearnSkillView.h
//  BattleHeartNew
//
//  Created by Mac on 2021/1/6.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDLearnSkillView : UIView

@property (nonatomic,strong)void (^ClickLearnBlock)(NSString *skillName,NSInteger index, NSString *userName,UIButton *sender);

- (instancetype)initWithFrame:(CGRect)frame
                         name:(NSString *)name
                        index:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
