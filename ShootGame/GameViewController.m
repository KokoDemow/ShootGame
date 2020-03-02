//
//  GameViewController.m
//  ShootGame
//
//  Created by xiejuqiang on 2020/2/26.
//  Copyright © 2020 linlufeng. All rights reserved.
//

#import "GameViewController.h"
#import "MenuScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SKView *sceneView = (SKView *)self.view;
    CGSize size = CGSizeMake(sceneView.bounds.size.height, sceneView.bounds.size.width);
    MenuScene *scene = [MenuScene sceneWithSize:size];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    // Present the scene.
    [sceneView presentScene:scene transition:[SKTransition crossFadeWithDuration:0.5]];
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
