//
//  GameScene.m
//  ShootGame
//
//  Created by xiejuqiang on 2020/2/26.
//  Copyright © 2020 linlufeng. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene
- (instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        [self addBackground];
        [self generateEnemy];
    }
    return self;
}

- (void)addBackground {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
    background.name = @"bg";
    background.size = CGSizeMake(self.size.width, self.size.height);
    background.position = CGPointMake(background.size.width/2,background.size.height/2);
    [self addChild:background];
}

- (void)didMoveToView:(SKView *)view{
    SKAudioNode *music = [[SKAudioNode alloc] initWithFileNamed:@"bgm1.mp3"];
    [self addChild:music];
}

- (void)generateEnemy{
    CGSize enemySize = CGSizeMake(100, 100);
    SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithImageNamed:@"enemy2"];
    enemy.size = enemySize;
    enemy.position = CGPointMake(enemySize.width/2, self.size.height-enemySize.height/2);
    enemy.name = @"enemy";
    enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemy.size];
//    //物理体是否受力
    enemy.physicsBody.dynamic = NO;
//    //设置物理体的标识符
//    enemy.physicsBody.categoryBitMask = 1;
//    //设置可与哪一类的物理体发生碰撞
//    enemy.physicsBody.contactTestBitMask = 2;
    
    [self addChild:enemy];
    SKAction *left = [SKAction moveToX:self.size.width duration:1.0];
    SKAction *right = [SKAction moveToX:0 duration:1.0];
    SKAction *sq = [SKAction sequence:@[left, right]];
    [enemy runAction:[SKAction repeatActionForever:sq]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGSize heroSize = CGSizeMake(100, 100);
    SKSpriteNode *hero = [SKSpriteNode spriteNodeWithImageNamed:@"hero"];
    hero.size = heroSize;
    hero.position = CGPointMake(self.size.width/2, 0);
    hero.anchorPoint = CGPointMake(0.5, 1);
    hero.zPosition = 1;
    hero.name = @"hero";
    hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hero.size];
//    //物理体是否受力
//    hero.physicsBody.dynamic = YES;
//    //设置物理体的标识符
//    hero.physicsBody.categoryBitMask = 2;
//    //设置可与哪一类的物理体发生碰撞
//    hero.physicsBody.contactTestBitMask = 1;
    
    [self addChild:hero];
    //添加动作
    [hero runAction:[SKAction moveToY:self.size.height duration:2]];
}


@end
