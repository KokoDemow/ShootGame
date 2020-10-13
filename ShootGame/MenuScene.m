//
//  MenuScene.m
//  ShootGame
//
//  Created by xiejuqiang on 2020/2/26.
//  Copyright © 2020 linlufeng. All rights reserved.
//

#import "MenuScene.h"
#import "GameScene.h"

@interface MenuScene()
@property (nonatomic, strong) SKSpriteNode *ruleNodeAlert;
@end

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

// 添加菜单
- (void)addMenu{
    SKSpriteNode *playNode = [SKSpriteNode spriteNodeWithImageNamed:@"btn01"];
    playNode.name = @"play";
    playNode.size = CGSizeMake(170, 45);
    playNode.position = CGPointMake(self.size.width/2,self.size.height/2);
    [self addChild:playNode];
    
    SKSpriteNode *ruleNode = [SKSpriteNode spriteNodeWithImageNamed:@"btn02"];
    ruleNode.name = @"rule";
    ruleNode.size = CGSizeMake(170, 45);
    ruleNode.position = CGPointMake(self.size.width/2,self.size.height/2-60);
    [self addChild:ruleNode];
}

- (void)addRule{
    if (self.ruleNodeAlert == nil) {
        self.ruleNodeAlert = [SKSpriteNode spriteNodeWithImageNamed:@"alertrule"];
        self.ruleNodeAlert.name = @"alertrule";
        self.ruleNodeAlert.size = CGSizeMake(310, 342);
        self.ruleNodeAlert.position = CGPointMake(self.size.width/2,self.size.height/2);
    }
    [self addChild:self.ruleNodeAlert];
}

- (void)hiddenRule{
    if (self.ruleNodeAlert && self.ruleNodeAlert.parent) {
        [self.ruleNodeAlert removeFromParent];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    SKSpriteNode *playNode = (SKSpriteNode *)[self childNodeWithName:@"play"];
    SKSpriteNode *ruleNode = (SKSpriteNode *)[self childNodeWithName:@"rule"];
    for (UITouch *t in touches){
        if (CGRectContainsPoint(playNode.frame, [t locationInNode:self])) {
            GameScene *gameScene = [[GameScene alloc]initWithSize:self.size];
            [self.view presentScene:gameScene transition:[SKTransition doorwayWithDuration:0.5]];
        }
        
        if (CGRectContainsPoint(ruleNode.frame, [t locationInNode:self])) {
            [self addRule];
        }else{
            [self hiddenRule];
        }
    }
}
@end
