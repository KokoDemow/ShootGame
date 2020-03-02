//
//  MenuScene.m
//  ShootGame
//
//  Created by xiejuqiang on 2020/2/26.
//  Copyright © 2020 linlufeng. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"

@implementation MenuScene
- (id)initWithSize:(CGSize)size{
    self = [super initWithSize:size];
    if (self) {
        self.backgroundColor = [SKColor yellowColor];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view{
    [self addBackground];// 背景
    [self addMenu];
    
    SKAudioNode *music = [[SKAudioNode alloc] initWithFileNamed:@"bgm.mp3"];
    [self addChild:music];
}
// 添加背景

- (void)addBackground {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    background.name = @"bg";
    background.size = CGSizeMake(self.size.width, self.size.height);
    background.position = CGPointMake(background.size.width/2,background.size.height/2);
    [self addChild:background];
}

- (void)addMenu{
//    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    startButton.frame = CGRectMake((self.size.width/2)-25, (self.size.height/2), 100, 50);
//    [startButton setTitle:@"开始游戏" forState:UIControlStateNormal];
//    [self.view addSubview:startButton];

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    GameScene *gameScene = [[GameScene alloc]initWithSize:self.size];
    [self.view presentScene:gameScene transition:[SKTransition doorwayWithDuration:0.5]];
}
@end
