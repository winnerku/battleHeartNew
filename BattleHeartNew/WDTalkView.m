//
//  WDTalkView.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/3.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDTalkView.h"

@implementation WDTalkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setText:(NSString *)text name:(NSString *)name
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5.f;
    
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSParagraphStyleAttributeName:style,NSFontAttributeName:[UIFont systemFontOfSize:25.f]};
    
    NSAttributedString *at = [[NSAttributedString alloc] initWithString:text attributes:dic];
    self.talkLabel.attributedText = at;
    
    
    if (![name isEqualToString:@""]) {
        NSDictionary *imageDic = @{kKinght:[UIImage imageNamed:@"Knight_stand_0"],kIceWizard:[UIImage imageNamed:@"IceWizard_stand_0"]};
        self.talkImageView.image = imageDic[name];
    }
    
}

- (UILabel *)talkLabel
{
    if (!_talkLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:25];
        label.textAlignment = NSTextAlignmentJustified;
        //label.backgroundColor = [UIColor greenColor];
        label.numberOfLines = 0;
        _talkLabel = label;
        _talkLabel.frame = CGRectMake(self.talkImageView.right + 20, 15, self.bgView.width - self.talkImageView.right - 20 - 20, self.bgView.height - 30);
        [self.bgView addSubview:_talkLabel];
    }
    
    return _talkLabel;
}

- (UIImageView *)talkImageView
{
    if (!_talkImageView) {
        CGFloat page = 20;
        CGFloat height = self.bgView.height - page * 2.0;
        _talkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(page, page, height, height)];
       // _talkImageView.backgroundColor = [UIColor orangeColor];
        [self.bgView addSubview:_talkImageView];
        
    }
    
    return _talkImageView;
}

- (UIImageView *)bgView
{
    if (!_bgView) {
       
        CGFloat width = 600;
        CGFloat page = (kScreenWidth - width) / 2.0;
        CGFloat height = 130;
       
        
        UIImage *image = [UIImage imageNamed:@"sceneTalk"];
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:130 topCapHeight:60];
        
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(page, self.height - height - 10, width, height)];
        _bgView.image = newImage;
        [self addSubview:_bgView];
    }
    
    return _bgView;
}

@end
