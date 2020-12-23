//
//  GameViewController.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

#import "WDSkillView.h"

#import "LearnScene.h"
#import "PubScene.h"

@implementation GameViewController
{
    WDBaseScene *_selectScene;
    WDSkillView *_skillView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSkillView];


    WDTextureManager *manager = [WDTextureManager shareTextureManager];
    [manager iceWizardModel];
    [manager kinghtModel];
    [manager archerModel];
    
    [manager redBatModel];
    [manager loadCommonTexture];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kPassLearn];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:kPassLearn]){
        [self createSceneWithName:@"PubScene"];
    }else{
        [self createSceneWithName:@"LearnScene"];
    }

}

- (void)createSkillView
{
    CGFloat page = 0;
    if (IS_IPHONEX) {
        page = 20;
    }
    CGFloat width = 4 * 10 + 50 * 5;
    CGFloat x = (kScreenWidth - width) / 2.0;
    
    
    
    _skillView = [[WDSkillView alloc] initWithFrame:CGRectMake(x,kScreenHeight - 50 - page, width , 50)];
    //_skillView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_skillView];
    __weak typeof(self)weakSelf = self;
    [_skillView setSkillActionBlock:^(NSInteger tag) {
        [weakSelf skillActionWithTag:tag];
    }];
}


- (void)skillActionWithTag:(NSInteger)tag{
   
    if (tag == 100) {
        
        [_selectScene skill1Action];
        NSLog(@"技能1");
        
    }else if(tag == 101){
        
        [_selectScene skill2Action];
        NSLog(@"技能2");
        
    }else if(tag == 102){
        
        [_selectScene skill3Action];
        NSLog(@"技能3");
        
    }else if(tag == 103){
        
        [_selectScene skill4Action];
        NSLog(@"技能4");
        
    }else if(tag == 104){
        
        [_selectScene skill5Action];
        NSLog(@"技能5");
        
    }
}




/// 创建场景
/// @param name 类名
- (void)createSceneWithName:(NSString *)name
{
    [_selectScene releaseAction];
    
    Class class = NSClassFromString(name);
    WDBaseScene *scene = [class nodeWithFileNamed:name];
    _selectScene = scene;

    scene.scaleMode = SKSceneScaleModeAspectFill;
       
    SKView *skView = (SKView *)self.view;
       
    SKTransition *tr = [SKTransition fadeWithDuration:1];

    // Present the scene
    [skView presentScene:scene transition:tr];
  
       
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsPhysics = YES;
       
       
    __weak typeof(self)weakSelf = self;
    [_selectScene setChangeSceneWithNameBlock:^(NSString * _Nonnull sceneName) {
        [weakSelf createSceneWithName:sceneName];
    }];
    
}

#pragma mark - 中线 -
- (void)createMiddleLine
{
    UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 0.5, 0, 1, kScreenHeight)];
    middleLine.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:middleLine];

    UIView *middleLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight / 2.0 - 0.5, kScreenWidth, 1)];
    middleLine2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:middleLine2];
}









- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
