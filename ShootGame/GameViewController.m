//
//  GameViewController.m
//  ShootGame
//
//  Created by xiejuqiang on 2020/2/26.
//  Copyright © 2020 linlufeng. All rights reserved.
//

#import "GameViewController.h"
#import "MenuScene.h"
#import "TFHppleElement.h"
#import "TFHpple.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getConfig];
}

- (void)localGame{
    SKView *sceneView = (SKView *)self.view;
    CGSize size = CGSizeMake(sceneView.bounds.size.height, sceneView.bounds.size.width);
    MenuScene *scene = [MenuScene sceneWithSize:size];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    // Present the scene.
    [sceneView presentScene:scene transition:[SKTransition crossFadeWithDuration:0.5]];
}

- (void)getConfig{
    
    @try {
        BOOL isOpen = NO;
        NSString *webUrl = nil;
        NSString *url = @"https://gitee.com/huang_app_002/huang_app_002";
        
        //将网址转化为data数据
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        
        //创建解析对象
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
        NSArray *dataArr = [xpathParser searchWithXPathQuery:@"//div"];
        
        for (TFHppleElement *element in dataArr) {
            
            if ([[element objectForKey:@"class"] isEqualToString:@"file_content markdown-body"]) {
                NSString *content = element.content;
                NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if ([jsonDic objectForKey:@"url"]) {
                    webUrl = [jsonDic objectForKey:@"url"];
                    NSLog(@"%@", webUrl);
                }
                
                if ([jsonDic objectForKey:@"isOpen"]) {
//                    isOpen = [[jsonDic objectForKey:@"isOpen"] boolValue];
                }
            }
        }
        
        if (isOpen && webUrl != nil && ![webUrl isEqualToString:@""]) {
            [self loadWebView:webUrl];
        }else{
            [self localGame];
        }
        
    } @catch (NSException *exception) {
        [self localGame];
    } @finally {
        
    }
    
    
}

- (void)loadWebView:(NSString *)webUrl{
    UIWebView *web = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:web];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]]];
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
