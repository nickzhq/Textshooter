//
//  GameScene.m
//  Textshooter
//
//  Created by Houqi Zuo on 8/26/16.
//  Copyright (c) 2016 University of New Haven. All rights reserved.
//

#import "LevelScene.h"
#import "PlayerNode.h"
#import "EnemyNode.h"
#import "BulletNode.h"
#import "SKNode+Extra.h"
#import "GameOverScene.h"

#define ARC4RANDOM_MAX 0x100000000

@interface LevelScene() <SKPhysicsContactDelegate>
@property (strong, nonatomic) PlayerNode *playerNode;
@property (strong, nonatomic) SKNode *enemies;
@property (strong, nonatomic) SKNode *playerBullets;
@end
@implementation LevelScene

+(instancetype)sceneWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber {
    return [[self alloc] initWithSize:size levelNumber:levelNumber];
}

-(instancetype)initWithSize:(CGSize)size {
    return [self initWithSize:size levelNumber:1];
}

-(instancetype)initWithSize:(CGSize)size levelNumber:(NSUInteger)levelNumber {
    if(self = [super initWithSize:size]) {
        _levelNumber = levelNumber;
        _playerLives = 5;
        
        self.backgroundColor = [SKColor whiteColor];
        SKLabelNode *lives = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        lives.fontSize = 16;
        lives.fontColor = [SKColor blackColor];
        lives.name = @"LivesLabel";
        lives.text = [NSString stringWithFormat:@"lives: %lu",(unsigned long)_playerLives];
        lives.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        lives.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        lives.position = CGPointMake(self.frame.size.width, self.frame.size.height);
        
        [self addChild:lives];
        
        SKLabelNode *level = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        level.fontSize = 16;
        level.fontColor = [SKColor blackColor];
        level.name = @"LevelLabel";
        level.text = [NSString stringWithFormat:@"Level: %lu", (unsigned long)_levelNumber];
        level.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        level.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        level.position = CGPointMake(0, self.frame.size.height);
        [self addChild:level];
        
        _playerNode = [PlayerNode node];
        _playerNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) * 0.1);
        [self addChild:_playerNode];
        
        _enemies = [SKNode node];
        [self addChild:_enemies];
        [self spawnEnemies];
        
        _playerBullets = [SKNode node];
        [self addChild:_playerBullets];
        
        // setup for delegate
        self.physicsWorld.gravity = CGVectorMake(0, -1);
        self.physicsWorld.contactDelegate = self;
    }
    
    return self;
}
// contactDelegate
-(void)didBeginContact:(SKPhysicsContact *)contact {
    if( contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask) {
        // these bodys in the same category
        SKNode *nodeA = contact.bodyA.node;
        SKNode *nodeB = contact.bodyB.node;
        
        [nodeA friendlyBumpFrom:nodeB];
        [nodeB friendlyBumpFrom:nodeA];
    }else {
        SKNode *attacker = nil;
        SKNode *attackee = nil;
        
        if(contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
            // A attacks B
            attacker = contact.bodyA.node;
            attackee = contact.bodyB.node;
        }else {
            // B attacks A
            attacker = contact.bodyB.node;
            attackee = contact.bodyA.node;
        }
        // reduce player a live
        if ([attackee isKindOfClass:[PlayerNode class]]) {
            self.playerLives--;
        }
        if(attacker) {
            [attackee receiveAttacker:attacker contact:contact];
            [self.playerBullets removeChildrenInArray:@[attacker]];
            [self.enemies removeChildrenInArray:@[attacker]];
        }
    }
}
-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 45;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    //[self addChild:myLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if( location.y < CGRectGetHeight(self.frame) * 0.2 ) {
            CGPoint target = CGPointMake(location.x, self.playerNode.position.y);
            CGFloat duration = [self.playerNode moveToward:target];
        } else {
            BulletNode *bullet = [BulletNode bulletFrom:self.playerNode.position
                                                 toward:location];
            if (bullet) {
                [self.playerBullets addChild:bullet];
            }
        }
        
    }
}

-(void)spawnEnemies {
    NSUInteger count = log(self.levelNumber) + self.levelNumber;
    for(NSUInteger i = 0; i < count; ++i) {
        EnemyNode *enemy = [EnemyNode node];
        CGSize size = self.frame.size;
        CGFloat x = (size.width * 0.8 * arc4random() / ARC4RANDOM_MAX) + (size.width * 0.1);
        CGFloat y = (size.height * 0.5 * arc4random() / ARC4RANDOM_MAX) + (size.height * 0.5);
        enemy.position = CGPointMake(x,y);
        [self.enemies addChild:enemy];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.finished) return;
    
    [self updateBullets];
    [self updateEnemies];
    if(![self checkForGameOver]) {
        [self checkForNextLevel];
    }
}
-(void)checkForNextLevel {
    if([self.enemies.children count] == 0) [self goToNextLevel];
}
-(void)goToNextLevel {
    self.finished = YES;
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    label.text = @"Level Complete!";
    label.fontColor = [SKColor blueColor];
    label.fontSize = 32;
    label.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    [self addChild:label];
    
    LevelScene *nextLevel = [[LevelScene alloc] initWithSize:self.frame.size levelNumber:self.levelNumber + 1];
    nextLevel.playerLives = self.playerLives;
    
    [self.view presentScene:nextLevel
                 transition:[SKTransition flipHorizontalWithDuration:2.0f]];
    

}
-(void)updateBullets {
    NSMutableArray *bulletsToRemove = [NSMutableArray array];
    for( BulletNode *bullet in self.playerBullets.children) {
        if ( !CGRectContainsPoint(self.frame, bullet.position) ) {
            [bulletsToRemove addObject:bullet];
            continue;
        }
        
        [bullet applyRecurringForce];
    }
    [self.playerBullets removeChildrenInArray:bulletsToRemove];
}
-(void)updateEnemies {
    NSMutableArray *enemiesToRemove = [NSMutableArray array];
    for (SKNode *node in self.enemies.children) {
        if ( !CGRectContainsPoint(self.frame, node.position) ) {
            [enemiesToRemove addObject:node];
            continue;
        }
    }
    if ([enemiesToRemove count] > 0) {
        [self.enemies removeChildrenInArray:enemiesToRemove];
    }
}
-(void)setPlayerLives:(NSUInteger)playerLives {
    _playerLives = playerLives;
    SKLabelNode *lives = (id)[self childNodeWithName:@"LivesLabel"];
    lives.text = [NSString stringWithFormat:@"Lives: %lu", (unsigned long)_playerLives];
}

-(void)triggerGameOver {
    self.finished = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EnemyExplosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.numParticlesToEmit = 200;
    explosion.position = _playerNode.position;
    [self addChild:explosion];
    [_playerNode removeFromParent];
    SKTransition *transition = [SKTransition doorsOpenVerticalWithDuration:1.0];
    SKScene *gameOver = [[GameOverScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:gameOver transition:transition];
    [self runAction:[SKAction playSoundFileNamed:@"gameOver.wav" waitForCompletion:NO]];
}
-(BOOL)checkForGameOver {
    if(self.playerLives == 0) {
        [self triggerGameOver];
        return YES;
    }
    return NO;
}
@end
