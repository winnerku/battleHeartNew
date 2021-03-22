//
//  WDSkillBtn.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/23.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "WDSkillBtn.h"

@implementation WDSkillBtn
{
    int _allTime;
    int _startTime;
    NSTimer *_timer;
    UILabel *_timeLabel;
}

- (void)reloadAction
{
    if (_timer) {
        [_timer invalidate];
    }
    
    self.selected = NO;
    self.alpha = 1;
    self.timeLabel.hidden = YES;
}

- (void)setTime:(CGFloat)time
{
    if (time == 1000) {
        self.alpha = 0.2;
    }else{
        _startTime = time;
        _allTime = time;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
        self.alpha = 0.5;
        self.timeLabel.hidden = NO;
        self.timeLabel.text = [NSString stringWithFormat:@"%d",_allTime];
    }
    
    
}

- (void)timeAction:(NSTimer *)timer
{
    _startTime --;
    if (_startTime < 0) {
        self.alpha = 1;
        [_timer invalidate];
        self.timeLabel.hidden = YES;
        self.selected = NO;
        return;
    }
    
    self.timeLabel.text = [NSString stringWithFormat:@"%d",_startTime];
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        label.text = @"";
        label.textColor = [UIColor orangeColor];
        label.font = [UIFont systemFontOfSize:25.f];
        label.textAlignment = NSTextAlignmentCenter;
        _timeLabel = label;
        [self addSubview:_timeLabel];
    }
    
    return _timeLabel;
}

@end
