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
    
    [_mapView setDataWithArr:@[[UIImage imageNamed:@"RedBatScene.png"],[UIImage imageNamed:@"RedBatScene.png"],[UIImage imageNamed:@"RedBatScene.png"],[UIImage imageNamed:@"RedBatScene.png"],[UIImage imageNamed:@"RedBatScene.png"]] textArr:@[@"蝙蝠领地",@"忍者？？？",@"幕后主使",@"丧尸来了？？",@"一只牛"]];

    __weak typeof(self)weakSelf = self;
    [_mapView setCancleBlock:^{
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [_mapView setSelectSceneBlock:^(NSString * _Nonnull sceneName) {
        
        if ([sceneName isEqualToString:@"NOPASS"]) {
            [weakSelf noPassAction];
        }else{
            if (weakSelf.selectSceneBlock) {
                weakSelf.selectSceneBlock(sceneName);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        
    }];
}

- (void)noPassAction
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"请先完成上一个关卡" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:^{
    }];
}

@end
