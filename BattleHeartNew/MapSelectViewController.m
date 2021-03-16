//
//  MapSelectViewController.m
//  BattleHeartNew
//
//  Created by Mac on 2021/1/5.
//  Copyright © 2021 Macdddd. All rights reserved.
//

#import "MapSelectViewController.h"
#import "WDMapSelectView.h"

@interface MapSelectViewController ()
{
    WDMapSelectView *_mapView;
}
@end

@implementation MapSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _mapView = [[WDMapSelectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _mapView.userInteractionEnabled = YES;
    [self.view addSubview:_mapView];
    
    [_mapView setDataWithArr:@[[UIImage imageNamed:@"RedBatScene.png"]] textArr:@[@"蝙蝠领地"]];

    __weak typeof(self)weakSelf = self;
    [_mapView setCancleBlock:^{
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [_mapView setSelectSceneBlock:^(NSString * _Nonnull sceneName) {
        if (weakSelf.selectSceneBlock) {
            weakSelf.selectSceneBlock(sceneName);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}



@end
