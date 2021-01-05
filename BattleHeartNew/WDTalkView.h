//
//  WDTalkView.h
//  BattleHeartNew
//
//  Created by Mac on 2021/1/3.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDTalkView : UIView

- (void)setText:(NSString *)text name:(NSString *)name;

@property (nonatomic,strong)UIImageView *bgView;
@property (nonatomic,strong)UIImageView *talkImageView;
@property (nonatomic,strong)UILabel *talkLabel;

@end

NS_ASSUME_NONNULL_END
