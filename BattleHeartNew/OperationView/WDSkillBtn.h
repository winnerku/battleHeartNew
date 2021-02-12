//
//  WDSkillBtn.h
//  BattleHeartNew
//
//  Created by Mac on 2020/12/23.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDSkillBtn : UIButton

@property (nonatomic,strong)UILabel *timeLabel;

- (void)setTime:(CGFloat)time;

@end

NS_ASSUME_NONNULL_END
