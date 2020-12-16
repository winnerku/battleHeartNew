//
//  GameViewController.m
//  BattleHeartNew
//
//  Created by Mac on 2020/12/7.
//  Copyright © 2020 Macdddd. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"


#import "LearnScene.h"
#import "BattleScene_1.h"

@implementation GameViewController
{
    WDBaseScene *_selectScene;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    WDTextureManager *manager = [WDTextureManager shareTextureManager];
    [manager iceWizardModel];
    [manager kinghtModel];
    [manager redBatModel];
    [manager loadCommonTexture];
    
    // Load the SKScene from 'GameScene.sks'
    LearnScene *scene = (LearnScene *)[LearnScene nodeWithFileNamed:@"LearnScene"];
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:scene];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsPhysics = YES;
    
    _selectScene = scene;
    
    //[self createMiddleLine];
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
