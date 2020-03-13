//
//  GameScene.m
//  ShootGame
//
//  Created by xiejuqiang on 2020/2/26.
//  Copyright © 2020 linlufeng. All rights reserved.
//

#import "GameScene.h"
#import "MenuScene.h"

@interface GameScene()<SKPhysicsContactDelegate>
@property (nonatomic, assign) NSInteger seedValue;
@property (nonatomic, assign) NSInteger scoreValue;
@property (nonatomic, strong) SKSpriteNode *soundBtnNode;
@property (nonatomic, strong) SKLabelNode *seedLabel;
@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property (nonatomic, strong) SKAudioNode *music;

@property (nonatomic, strong) SKSpriteNode *gameOverNode;
@property (nonatomic, strong) SKSpriteNode *restartNode;

@property (nonatomic, assign) BOOL gameOverFlag;
@property (nonatomic, strong) SKLabelNode *bestLabel;
@property (nonatomic, strong) SKLabelNode *resultLabel;

@end

@implementation GameScene
- (instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        self.gameOverFlag = NO;
        [self addBackground];
        [self addTopIcons];
        [self startGame];
        self.physicsWorld.contactDelegate = self;
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

- (void)addTopIcons{
    SKColor *textColor = [SKColor colorWithRed:140.0/255.0 green:80.0/255.0 blue:32.0/255.0 alpha:1.0];
    SKSpriteNode *seedNode = [SKSpriteNode spriteNodeWithImageNamed:@"01"];
    seedNode.name = @"seed";
    seedNode.anchorPoint = CGPointMake(0, 1);
    seedNode.size = CGSizeMake(92, 51);
    seedNode.position = CGPointMake(5, self.size.height);
    [self addChild:seedNode];
    self.seedLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    self.seedLabel.name = @"seedLabel";
    self.seedLabel.fontColor = textColor;
    self.seedLabel.fontSize = 20;
    self.seedLabel.position = CGPointMake(CGRectGetMidX(seedNode.frame)+10,
                                          CGRectGetMidY(seedNode.frame)-5);
    [self addChild:self.seedLabel];
    
    SKSpriteNode *scoreNode = [SKSpriteNode spriteNodeWithImageNamed:@"02"];
    scoreNode.name = @"score";
    scoreNode.anchorPoint = CGPointMake(0, 1);
    scoreNode.size = CGSizeMake(123, 40);
    scoreNode.position = CGPointMake(5+seedNode.size.width+5, self.size.height-3);
    [self addChild:scoreNode];
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    self.scoreLabel.name = @"scoreLabel";
    self.scoreLabel.fontColor = textColor;
    self.scoreLabel.fontSize = 20;
    self.scoreLabel.position = CGPointMake(CGRectGetMidX(scoreNode.frame)+40,
                                           CGRectGetMidY(scoreNode.frame)-8);
    [self addChild:self.scoreLabel];
    
    SKSpriteNode *backNode = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
    backNode.name = @"back";
    backNode.anchorPoint = CGPointMake(1, 1);
    backNode.size = CGSizeMake(44, 45);
    backNode.position = CGPointMake(self.size.width-22, self.size.height-3);
    [self addChild:backNode];
    
    self.soundBtnNode = [SKSpriteNode spriteNodeWithImageNamed:@"sound"];
    self.soundBtnNode.name = @"sound";
    self.soundBtnNode.anchorPoint = CGPointMake(1, 1);
    self.soundBtnNode.size = CGSizeMake(44, 45);
    self.soundBtnNode.position = CGPointMake(self.size.width-22-44-22, self.size.height-3);
    [self addChild:self.soundBtnNode];

}

- (void)refreshSeedLabel{
    self.seedLabel.text = [NSString stringWithFormat:@"%@", @(self.seedValue)];
}

- (void)refreshScoreLabel{
    self.scoreLabel.text = [NSString stringWithFormat:@"%@", @(self.scoreValue)];
}

- (void)didMoveToView:(SKView *)view{
    
}

- (void)play{
    if (self.soundBtnNode) {
        self.soundBtnNode.name = @"sound";
        self.soundBtnNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"sound"]];
    }
    self.music = [[SKAudioNode alloc] initWithFileNamed:@"bgm1.mp3"];
    [self addChild:self.music];
}

- (void)stop{
    if (self.soundBtnNode) {
        self.soundBtnNode.name = @"nosound";
        self.soundBtnNode.texture = [SKTexture textureWithImage:[UIImage imageNamed:@"nosound"]];
    }
    if (self.music && [self.music parent]) {
        [self.music removeFromParent];
    }
}

- (void)startGame{
    [self play];
    [self hiddenGameOver];
    self.gameOverFlag = NO;
    self.seedValue = 10;
    self.scoreValue = 0;
    [self refreshSeedLabel];
    [self refreshScoreLabel];
    NSDictionary *heroInfo = @{@"name":@"fox", @"size":@(CGSizeMake(146, 164))};
    CGSize heroSize = [heroInfo[@"size"] CGSizeValue];
    NSString *heroName = heroInfo[@"name"];
    SKSpriteNode *hero = [SKSpriteNode spriteNodeWithImageNamed:heroName];
    hero.size = heroSize;
    hero.position = CGPointMake(heroSize.width/2, hero.size.height/2);
    hero.name = @"hero";
    hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hero.size];
    //    //物理体是否受力
    hero.physicsBody.dynamic = NO;
    //    //设置物理体的标识符
    //    hero.physicsBody.categoryBitMask = 1;
    //    //设置可与哪一类的物理体发生碰撞
    //    hero.physicsBody.contactTestBitMask = 2;
    
    [self addChild:hero];
    SKAction *left = [SKAction moveToX:self.size.width duration:1.0];
    SKAction *right = [SKAction moveToX:0 duration:1.0];
    SKAction *sq = [SKAction sequence:@[left, right]];
    [hero runAction:[SKAction repeatActionForever:sq]];
}

- (void)generateSeed:(CGPoint)postion{
    NSArray *seedTypes = @[@{@"name":@"zhenzi", @"size":@(CGSizeMake(59, 52))}, @{@"name":@"huluobo", @"size":@(CGSizeMake(70, 80))}, @{@"name":@"maotouying", @"size":@(CGSizeMake(78, 82))}, @{@"name":@"tuzi", @"size":@(CGSizeMake(63, 89))}, @{@"name":@"songshu", @"size":@(CGSizeMake(81, 78))}, @{@"name":@"shizi", @"size":@(CGSizeMake(109, 90))}, @{@"name":@"pingguo", @"size":@(CGSizeMake(55, 53))}];
    NSDictionary *seedInfo = [seedTypes objectAtIndex:arc4random()%seedTypes.count];
    CGSize seedSize = CGSizeMake(100, 100);
    NSString *seedName = seedInfo[@"name"];
    SKSpriteNode *seed = [SKSpriteNode spriteNodeWithImageNamed:seedName];
    seed.size = seedSize;
    seed.position = CGPointMake(postion.x, self.size.height);
    seed.anchorPoint = CGPointMake(0.5, 1);
    seed.zPosition = 1;
    seed.name = @"seed";
    seed.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:seed.size];
    //物理体是否受力
    seed.physicsBody.dynamic = YES;
    //设置物理体的标识符
    seed.physicsBody.categoryBitMask = 2;
    //设置可与哪一类的物理体发生碰撞
    seed.physicsBody.contactTestBitMask = 1;
    
    [self addChild:seed];
//    添加动作
//    [seed runAction:[SKAction moveToY:self.size.height duration:2]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    SKSpriteNode *backNode = (SKSpriteNode *)[self childNodeWithName:@"back"];
    for (UITouch *t in touches){
        if (CGRectContainsPoint(backNode.frame, [t locationInNode:self])) {
            MenuScene *menuScene = [[MenuScene alloc]initWithSize:self.size];
            [self.view presentScene:menuScene transition:[SKTransition doorwayWithDuration:0.5]];
        }else if(CGRectContainsPoint(self.soundBtnNode.frame, [t locationInNode:self])){
            if ([self.soundBtnNode.name isEqualToString:@"sound"]) {
                [self stop];
            }else{
                [self play];
            }
        } else if(CGRectContainsPoint(self.restartNode.frame, [t locationInNode:self]) && self.restartNode.parent){
            [self startGame];
        }else{
            if (self.seedValue > 0) {
                CGPoint position = [t locationInNode:self];
                [self generateSeed:position];
                self.seedValue--;
                [self refreshSeedLabel];
            }
        }
    }
}


- (void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *bodyA = contact.bodyA;
    SKPhysicsBody *bodyB = contact.bodyB;
    NSLog(@"A = %@, B = %@", bodyA.node.name, bodyB.node.name);
    if ([bodyA.node.name isEqualToString:@"hero"] &&  [bodyB.node.name isEqualToString:@"seed"]) {
        [bodyB.node removeFromParent];
        self.scoreValue++;
        [self refreshScoreLabel];
    }
    
    if (self.seedValue == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.gameOverFlag) {
                [self gameOver];
            }
        });
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact{
    
}

- (void)gameOver{
    NSLog(@"game over");
    NSInteger bestScore = 0;
    self.gameOverFlag = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"BestScore"]) {
        bestScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"BestScore"] integerValue];
    }
    if (self.scoreValue > bestScore) {
        bestScore = self.scoreValue;
        [[NSUserDefaults standardUserDefaults] setValue:@(bestScore) forKey:@"BestScore"];
    }
    
    SKSpriteNode *hero = (SKSpriteNode *)[self childNodeWithName:@"hero"];
    [hero removeFromParent];
    [self stop];
    
    if (self.gameOverNode == nil) {
        SKColor *textColor = [SKColor colorWithRed:140.0/255.0 green:80.0/255.0 blue:32.0/255.0 alpha:1.0];

        self.gameOverNode = [SKSpriteNode spriteNodeWithImageNamed:@"gameOver"];
        self.gameOverNode.name = @"gameOver";
        self.gameOverNode.size = CGSizeMake(258, 185);
        self.gameOverNode.position = CGPointMake(self.size.width/2,self.size.height/2);
        
        self.bestLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.bestLabel.name = @"bestLabel";
        self.bestLabel.fontColor = textColor;
        self.bestLabel.fontSize = 20;
        self.bestLabel.position = CGPointMake(25, -8);
        [self.gameOverNode addChild:self.bestLabel];
        
        self.resultLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.resultLabel.name = @"resultLabel";
        self.resultLabel.fontColor = textColor;
        self.resultLabel.fontSize = 20;
        self.resultLabel.position = CGPointMake(40, -50);
        [self.gameOverNode addChild:self.resultLabel];
        
    }
    [self addChild:self.gameOverNode];
    self.bestLabel.text = [NSString stringWithFormat:@"%@", @(bestScore)];
    self.resultLabel.text = [NSString stringWithFormat:@"%@", @(self.scoreValue)];

    
    if (self.restartNode == nil) {
        self.restartNode = [SKSpriteNode spriteNodeWithImageNamed:@"restart"];
        self.restartNode.name = @"restart";
        self.restartNode.size = CGSizeMake(170, 45);
        self.restartNode.position = CGPointMake(self.size.width/2,self.size.height/2-150);
    }
    [self addChild:self.restartNode];
}




- (void)hiddenGameOver{
    if (self.gameOverNode && self.gameOverNode.parent) {
        [self.gameOverNode removeFromParent];
    }
    
    if (self.restartNode && self.restartNode.parent) {
        [self.restartNode removeFromParent];
    }
}


@end
