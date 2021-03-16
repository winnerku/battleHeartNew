//
//  GameViewController.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "GameViewController.h"
#import "MapSelectViewController.h"
#import "LearnSkillViewController.h"


#import "WDSkillView.h"
#import "WDTalkView.h"
#import "WDHomePageUIView.h"

#import "LearnScene.h"
#import "LearnScene2.h"
#import "LoadingScene.h"
@interface GameViewController ()
@property (nonatomic,strong)WDHomePageUIView *uiView;
@end


@implementation GameViewController
{
    WDBaseScene *_selectScene;
    WDSkillView *_skillView;
    WDTalkView  *_talkView;
    WDHomePageUIView *_uiView;
}


/// 初始化起始技能
- (void)initUserSkill{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key1 = [NSString stringWithFormat:@"%@_0",kKinght];
    NSString *key2 = [NSString stringWithFormat:@"%@_0",kArcher];
    NSString *key3 = [NSString stringWithFormat:@"%@_0",kIceWizard];
    
    [defaults setBool:YES forKey:key1];
    [defaults setBool:YES forKey:key2];
    [defaults setBool:YES forKey:key3];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserSkill];

    CGFloat a = [UIScreen mainScreen].scale;
    NSLog(@"%lf",a);
    
    [self createSkillView];
    //[self createTalkView];


    WDTextureManager *manager = [WDTextureManager shareTextureManager];
    manager.goText = @"点击传送门\n选择出发地点";
 
    [manager loadCommonTexture];
    [manager setLinker];

    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    if (![d boolForKey:kPassLearn1]) {
        [self createSceneWithName:@"LearnScene"];
    }else if(![d boolForKey:kPassLearn2]){
        [self createSceneWithName:@"LearnScene2"];
    }else if(![d boolForKey:kPassLearn3]){
        [self createSceneWithName:@"PubScene"];
    }else{
        [self createSceneWithName:@"RealPubScene"];
    }

//    [self createSceneWithName:@"TestScene"];
//    [self showLearnSkillViewControllerWithName:kArcher];
}



- (void)createTalkView
{
    _talkView = [[WDTalkView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kScreenHeight / 2.0, kScreenWidth, kScreenHeight / 2.0)];
    _talkView.hidden = YES;
    [self.view addSubview:_talkView];
}


- (WDHomePageUIView *)uiView
{
    if(!_uiView){
        _uiView = [[WDHomePageUIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.view addSubview:_uiView];
    }
    
    return _uiView;
}


/// 展示地图选择器
- (void)showMapSelectViewController
{
    MapSelectViewController *vc = [[MapSelectViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
    __weak typeof(self)weakSelf = self;
    [vc setSelectSceneBlock:^(NSString * _Nonnull sceneName) {
        [weakSelf createSceneWithName:sceneName];
    }];
}


/// 展示技能学习界面
- (void)showLearnSkillViewControllerWithName:(NSString *)userName
{
    LearnSkillViewController *vc = [[LearnSkillViewController alloc] init];
    vc.userName = userName;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
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
    _skillView.hidden = YES;
    [self.view addSubview:_skillView];
    __weak typeof(self)weakSelf = self;
    [_skillView setSkillActionBlock:^(NSInteger tag) {
        [weakSelf skillActionWithTag:tag];
    }];

}


- (void)skillActionWithTag:(NSInteger)tag{
   
    if (tag == 100) {
        
        [_selectScene skill1Action];
        //NSLog(@"技能1");
        
    }else if(tag == 101){
        
        [_selectScene skill2Action];
        //NSLog(@"技能2");
        
    }else if(tag == 102){
        
        [_selectScene skill3Action];
        //NSLog(@"技能3");
        
    }else if(tag == 103){
        
        [_selectScene skill4Action];
        //NSLog(@"技能4");
        
    }else if(tag == 104){
        
        [_selectScene skill5Action];
        //NSLog(@"技能5");
        
    }
}


- (void)createLoadingScene{
    LoadingScene *scene = [LoadingScene nodeWithFileNamed:@"LoadingScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
       
    SKView *skView = (SKView *)self.view;
    SKTransition *tr = [SKTransition fadeWithDuration:1];

    [skView presentScene:scene transition:tr];

}

/// 创建场景
/// @param name 类名
- (void)createSceneWithName:(NSString *)name
{
    if ([name isEqualToString:@"RealPubScene"] && [[NSUserDefaults standardUserDefaults]boolForKey:kSkillNPC]) {
        self.uiView.hidden = NO;
    }else{
        self.uiView.hidden = YES;
    }
    
    [_skillView reloadAction];
    
    [_selectScene releaseAction];
    [self withName:name];
}

- (void)withName:(NSString *)name{
   
    
    Class class = NSClassFromString(name);
    WDBaseScene *scene = [class nodeWithFileNamed:name];
    _selectScene = scene;

    scene.scaleMode = SKSceneScaleModeAspectFill;
       
    SKView *skView = (SKView *)self.view;
       
    SKTransition *tr = [SKTransition fadeWithDuration:1];

    // Present the scene
  
       
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsPhysics = YES;
       
       
    __weak typeof(self)weakSelf = self;
    [_selectScene setChangeSceneWithNameBlock:^(NSString * _Nonnull sceneName) {
        [weakSelf createSceneWithName:sceneName];
    }];
    
    [_selectScene setTalkBlock:^(NSString * _Nonnull text, NSString * _Nonnull name) {
        [weakSelf setTextWithName:name text:text];
    }];
    
    [_selectScene setShowMapSelectBlock:^{
        [weakSelf showMapSelectViewController];
    }];
    
    [_selectScene setShowSkillSelectBlock:^(NSString * _Nonnull userName) {
        [weakSelf showLearnSkillViewControllerWithName:userName];
    }];
    
    [skView presentScene:scene transition:tr];
}

- (void)setTextWithName:(NSString *)name text:(NSString *)text
{
    if ([name isEqualToString:@""]) {
        _talkView.hidden = YES;
    }else{
        _talkView.hidden = NO;
        [_talkView setText:text name:name];
    }
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
