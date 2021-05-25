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
@property (nonatomic,strong)NSArray *userBtnArr;
@end


@implementation GameViewController
{
    WDBaseScene *_selectScene;
    WDSkillView *_skillView;
    WDTalkView  *_talkView;
    WDHomePageUIView *_uiView;
    UIView      *_userView; /// 玩家人物辅助面板
}


/// 初始化起始技能
- (void)initUserSkill{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key1 = [NSString stringWithFormat:@"%@_0",kKinght];
    NSString *key2 = [NSString stringWithFormat:@"%@_0",kArcher];
    NSString *key3 = [NSString stringWithFormat:@"%@_0",kIceWizard];
    NSString *key4 = [NSString stringWithFormat:@"%@_0",kNinja];
    
    [defaults setBool:YES forKey:key1];
    [defaults setBool:YES forKey:key2];
    [defaults setBool:YES forKey:key3];
    [defaults setBool:YES forKey:key4];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isHiddenOrShow:) name:kNotificationForHiddenSkill object:nil];
    
    [self initUserSkill];

    CGFloat a = [UIScreen mainScreen].scale;
    NSLog(@"%lf",a);
    
    [self createSkillView];
    //[self createTalkView];


    WDTextureManager *manager = [WDTextureManager shareTextureManager];
    manager.goText = @"点击传送门\n选择出发地点";
 
    [manager loadCommonTexture];
    [manager setLinker];
//
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
  
//   [self createSceneWithName:@"TestScene"];
//   [self showLearnSkillViewControllerWithName:kArcher];
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

/// 玩家技能以及辅助选中界面
- (void)createSkillView
{
    CGFloat page = 0;
    CGFloat page2 = 20;
    CGFloat page3 = 20;

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

//    CGFloat widthU = kScreenWidth - _skillView.right - page2 * 2.0;
//    _userView = [[UIView alloc] initWithFrame:CGRectMake(_skillView.right + page2, kScreenHeight - 50 - page, widthU, 50)];
//    //_userView.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:_userView];
//    
//    NSArray *images = @[@"Knight_stand_0",@"IceWizard_stand_0",@"Archer_stand_0",@"Ninja_stand_0"];
//    NSArray *colors = @[@"#00BFFF",@"#2E8B57",@"#F08080",@"#696969"];
//    CGFloat smallWidth = (widthU - 3 * page3) / 4.0;
//    NSMutableArray *btnArr = [NSMutableArray array];
//    for (int i = 0; i < 4; i ++) {
//        CGFloat x = smallWidth * i + page3 * i;
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, smallWidth, 50)];
//        //view.backgroundColor = [WDCalculateTool colorFromHexRGB:colors[i]];
//        [_userView addSubview:view];
//        
//        view.layer.masksToBounds = YES;
//        view.layer.cornerRadius = 50 / 2.0;
//        
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, smallWidth, 50)];
//        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(selectUser:) forControlEvents:UIControlEventTouchUpInside];
//        btn.tag = 100 + i;
//        [view addSubview:btn];
//        
//        [btnArr addObject:btn];
//    }
//    
//    self.userBtnArr = [btnArr copy];
}

/// 辅助选中英雄
- (void)selectUser:(UIButton *)sender
{
    NSArray *nameArr = @[kKinght,kIceWizard,kArcher,kNinja];
    [_selectScene selectUserWithName:nameArr[sender.tag - 100]];
    
}

/// 一局中玩家死亡，暂时置灰
- (void)userDiedWithName:(NSString *)name
{
    NSDictionary *dic = @{kKinght:@"100",kIceWizard:@"101",kArcher:@"102",kNinja:@"103"};
    NSInteger tag = [dic[name]integerValue];
    
    UIButton *btn = [_userView viewWithTag:tag];
    btn.userInteractionEnabled = NO;
    btn.alpha = 0.3;
}

- (void)isHiddenOrShow:(NSNotification *)notifiaction
{
    int a = [notifiaction.object intValue];
    if (a == 0) {
        _userView.hidden = YES;
    }else{
        _userView.hidden = NO;
    }
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
//    if ([name isEqualToString:@"RealPubScene"] && [[NSUserDefaults standardUserDefaults]boolForKey:kSkillNPC]) {
//        self.uiView.hidden = NO;
//    }else{
//        self.uiView.hidden = YES;
//    }
    
    [_skillView reloadAction];
    
    [_selectScene releaseAction];
    [self withName:name];
}

- (void)withName:(NSString *)name{
   
    /// 辅助选中功能的按钮
    for (UIButton *btn in self.userBtnArr) {
        btn.userInteractionEnabled = YES;
        btn.alpha = 1;
    }
    
    
    Class class = NSClassFromString(name);
    WDBaseScene *scene = [class nodeWithFileNamed:name];
    _selectScene = scene;

    scene.scaleMode = SKSceneScaleModeAspectFill;
       
    SKView *skView = (SKView *)self.view;
    skView.ignoresSiblingOrder = YES;
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
    
    [_selectScene setDiedBlock:^(NSString * _Nonnull userName) {
        [weakSelf userDiedWithName:userName];
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
