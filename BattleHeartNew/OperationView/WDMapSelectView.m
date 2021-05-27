//
//  WDMapSelectView.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/5.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "WDMapSelectView.h"

@implementation WDMapSelectView
{
    UIScrollView *_scrollView;
    NSArray      *_mapArr;
    NSString     *_selectMapName;
    UIButton     *_selectBtn;
    NSArray      *_tipArr;
    UILabel      *_tipLabel;
    UIButton     *_playBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createScrollView];
    }
    return self;
}

- (void)createScrollView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imageView.image = [UIImage imageNamed:@"gogogo.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //_scrollView.backgroundColor = [UIColor orangeColor]col;
    [self addSubview:_scrollView];
    _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake(kScreenWidth * 2.0, 0)];
    
    CGFloat cancelBtnWidth = 176 / 2.0;
    CGFloat cancelBtnHeight = 84 / 2.0;
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 20 - cancelBtnWidth, 20, cancelBtnWidth, cancelBtnHeight)];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self addSubview:cancelBtn];
    
    CGFloat playBtnWidth = 240 / 2.0;
    CGFloat playBtnHeight = 160 / 2.0;
    
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 20 - playBtnWidth, kScreenHeight - 20 - playBtnHeight, playBtnWidth, playBtnHeight)];
    [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    playBtn.hidden = YES;
    [self addSubview:playBtn];
    
    _playBtn = playBtn;
}

- (void)cancelAction:(UIButton *)sender
{
    if (self.cancleBlock) {
        self.cancleBlock();
    }
}

- (void)setDataWithArr:(NSArray *)images
               textArr:(NSArray *)textArr
{
    NSArray *sub = _scrollView.subviews;
    for (UIView *v in sub) {
        [v removeFromSuperview];
    }
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 20, kScreenWidth - 100, kScreenHeight - 40)];
    imageView.image = images[0];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 40.f;
    imageView.layer.borderWidth = 3.f;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.userInteractionEnabled = YES;
    [_scrollView addSubview:imageView];
    
    
    [self createIceWorld:imageView];
    
    
    [_scrollView setContentSize:CGSizeMake(kScreenWidth * images.count, 0)];
    
    //[self performSelector:@selector(a) withObject:nil afterDelay:0.5];
}


/// 冰封世界
- (void)createIceWorld:(UIImageView *)imageView{
    
    
    
    CGFloat page = 30.f;
    CGFloat width = (kScreenWidth - 300 - 8 * page) / 7.f;
    CGFloat middle = imageView.height / 2.0 - 50;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, middle + page + width + width / 2.0 + 20 , imageView.width, 30)];
    label.text = @"IceWorld";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:40.f];
    label.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:label];
    //label.backgroundColor = [UIColor orangeColor];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom + 10,imageView.width, 30)];
    _tipLabel.text = @"";
    _tipLabel.textColor = [WDCalculateTool colorFromHexRGB:@"#006400"];
    _tipLabel.font = [UIFont boldSystemFontOfSize:25.f];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:_tipLabel];
    
    NSArray *btnFrame = @[
                        @(CGRectMake(page, middle - width / 2.0, width, width)),
                        @(CGRectMake(page + width + page, middle - width / 2.0, width, width)),
                        @(CGRectMake(page+width+page, middle - width / 2.0 - page - width, width, width)),
                        @(CGRectMake(page+width+page, middle+width / 2.0+page, width, width)),
                        @(CGRectMake(width*2.0+page*3.0, middle - width / 2.0, width, width)),
                        @(CGRectMake(width*3.0+page*4.0, middle - width / 2.0, width, width)),
                        @(CGRectMake(width*3.0+page*4.0, middle - width / 2.0 - page - width, width, width)),
                        @(CGRectMake(width*4.0+page*5.0, middle - width / 2.0 - page - width, width, width)),
                        @(CGRectMake(width*4.0+page*5.0, middle - width / 2.0, width, width)),
                        @(CGRectMake(width*4.0+page*5.0, middle + width / 2.0 + page, width, width)),
                        @(CGRectMake(width*5.0+page*6.0, middle + width / 2.0 + page, width, width)),
                        @(CGRectMake(width*5.0+page*6.0, middle - width / 2.0, width, width)),
                        @(CGRectMake(width*6.0+page*7.0, middle - width / 2.0, width, width))
    ];
    
    CGFloat line = 4;
    
    NSArray *lineFrame = @[@(CGRectMake(page+width, middle - line / 2.0, page, line)),
                           @(CGRectMake(page*2.0+width*2.0-width / 2.0-line / 2.0, middle - width / 2.0 - page, line, page)),
                           @(CGRectMake(page*2.0+width*2.0-width / 2.0-line / 2.0, middle + width / 2.0, line, page)),
                           @(CGRectMake(page*2.0+width*2.0, middle - line / 2.0, page, line)),
                           @(CGRectMake(page*3.0+width*3.0, middle - line / 2.0, page, line)),
                           @(CGRectMake(page*4.0+width*4.0-width / 2.0 - line / 2.0, middle - width / 2.0-page, line, page)),
                           @(CGRectMake(page*4.0+width*4.0, middle - width / 2.0 - page - width / 2.0 - line / 2.0, page, line)),
                           @(CGRectMake(page*4.0+width*4.0, middle - line / 2.0, page, line)),
                           @(CGRectMake(page*5.0+width*5.0 - width / 2.0 - line / 2.0, middle + width / 2.0, line, page)),
                           @(CGRectMake(page*5.0+width*5.0, middle + width + page - line / 2.0, page, line)),
                           @(CGRectMake(page*6.0+width*6.0 - width / 2.0 - line / 2.0, middle + width / 2.0, line, page)),
                           @(CGRectMake(page*6.0+width*6.0, middle - line / 2.0, page, line)),
                           @(CGRectMake(0, 0, 0, 0))

    ];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *keys = @[kPassCheckPoint1,kPassCheckPoint2,kPassCheckPoint3,kPassCheckPoint4,kPassCheckPoint5,kPassCheckPoint6,kPassCheckPoint7,kPassCheckPoint8,kPassCheckPoint9,kPassCheckPoint10,kPassCheckPoint11,kPassCheckPoint12,kPassCheckPoint13];
    _tipArr = @[@"tips:走位嘲讽很关键哦！",@"tips:白给。。。",@"tips:外强中干，上下不去",@"tips:群体治疗，对抗病毒",@"tips:以其人之道，还治其人之身，方可破盾",@"",@""];
    int passNumber = 0;
    int lastNumber = 0;
    for (int i = 0; i < btnFrame.count; i ++) {
        BOOL isPass = [defaults boolForKey:keys[i]];
        if (isPass) {
            passNumber ++;
            lastNumber = i + 1;
        }
    }
    
//    lastNumber = 7;

    CGFloat startX = (imageView.width - 7 * width - 6 * page) / 2.0;
    
    for (int i = 0; i < btnFrame.count; i ++) {
        
        CGRect rect = [btnFrame[i]CGRectValue];
        rect = CGRectMake(startX + rect.origin.x - page, rect.origin.y, rect.size.width, rect.size.height);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        btn.tag = 100 + i;
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [imageView addSubview:btn];

        btn.backgroundColor = [UIColor blackColor];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.f;
        
        UIImageView *lockOrRight = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, btn.width - 20, btn.width - 20)];
        lockOrRight.image = [UIImage imageNamed:@"lock"];
        [btn addSubview:lockOrRight];

        
        CGRect lineRect = [lineFrame[i]CGRectValue];
        lineRect = CGRectMake(startX + lineRect.origin.x - page, lineRect.origin.y, lineRect.size.width, lineRect.size.height);
        UIView *lineView = [[UIView alloc] initWithFrame:lineRect];
        lineView.backgroundColor = [UIColor grayColor];
        [imageView addSubview:lineView];
           
            
        BOOL isPass = [defaults boolForKey:keys[i]];
        if (isPass) {
            lineView.backgroundColor = [UIColor blackColor];
            btn.userInteractionEnabled = NO;
            btn.backgroundColor = [WDCalculateTool colorFromHexRGB:@"#FFFFF0"];
            btn.layer.borderWidth = 2.f;
            btn.layer.borderColor = [WDCalculateTool colorFromHexRGB:@"#2F4F4F"].CGColor;
            lockOrRight.image = [UIImage imageNamed:@"duigou"];
            [btn addTarget:self action:@selector(iceMapAction:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
            if (i > lastNumber && lastNumber != 6 && lastNumber != 7) {
                
                [btn addTarget:self action:@selector(notCompleteAction:) forControlEvents:UIControlEventTouchUpInside];

            }else{
                
                if ((i == 2 || i == 3)&&(lastNumber >= 2 || lastNumber >= 3)){
                    if (lastNumber == 2 || lastNumber == 3) {
                        lastNumber ++;
                    }
                    //lastNumber ++;
                    lineView.backgroundColor = [UIColor blackColor];
                }
                

                
                if (i == 6 && lastNumber == 7) {
                    lineView.backgroundColor = [UIColor blackColor];
                }else if(i == 7 && lastNumber == 7){
                    lastNumber ++;
                    lineView.backgroundColor = [UIColor blackColor];
                }
                
                
                if (i == 7 && lastNumber == 6) {
                    lastNumber = 8;
                    lineView.backgroundColor = [UIColor blackColor];
                    [btn addTarget:self action:@selector(notCompleteAction:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [btn addTarget:self action:@selector(iceMapAction:) forControlEvents:UIControlEventTouchUpInside];
                    btn.backgroundColor = [WDCalculateTool colorFromHexRGB:@"#F5F5F5"];
                    btn.layer.borderWidth = 2.f;
                    btn.layer.borderColor = [WDCalculateTool colorFromHexRGB:@"#2F4F4F"].CGColor;
                    lockOrRight.image = [UIImage imageNamed:@"bone"];
                }
      
            }
            
        }
        
        UIImageView *sword = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, btn.width - 10, btn.width - 10)];
        sword.image = [UIImage imageNamed:@"sword"];
        sword.tag = 123321;
        sword.hidden = YES;
        sword.alpha = 0.5;
        [btn addSubview:sword];
        
    }
    
    
}


- (void)notCompleteAction:(UIButton *)sender
{
    if (self.selectSceneBlock) {
        self.selectSceneBlock(@"NOPASS");
    }
}

- (void)iceMapAction:(UIButton *)sender
{
    if (_selectBtn) {
        UIImageView *imageView = [_selectBtn viewWithTag:123321];
        imageView.hidden = YES;
        _selectBtn.backgroundColor = [WDCalculateTool colorFromHexRGB:@"#F5F5F5"];
    }
    
    NSArray *mapArr = @[@"RedBatScene",@"BoneSoliderScene",@"BoneBossScene",@"ZombieScene",@"OXScene",@"GhostScene",@"DogScene"];
    NSString *mapName = mapArr[sender.tag - 100];
    _selectMapName = mapName;
    _selectBtn = sender;
    
    _selectBtn.backgroundColor = [WDCalculateTool colorFromHexRGB:@"#CD5C5C"];
    
    UIImageView *imageView = [_selectBtn viewWithTag:123321];
    imageView.hidden = NO;
    
    _tipLabel.text = _tipArr[sender.tag - 100];
    
    _playBtn.hidden = NO;

}

- (void)play{
    if (self.selectSceneBlock) {
        self.selectSceneBlock(_selectMapName);
    }
}

- (void)mapAction:(UIButton *)sender
{
   
}


@end
