//
//  GameOverScene.m
//  Textshooter
//
//  Created by Houqi Zuo on 8/27/16.
//  Copyright © 2016 University of New Haven. All rights reserved.
//

#import "GameOverScene.h"
#import "StartScene.h"
@implementation GameOverScene
-(instancetype)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor purpleColor];
        SKLabelNode *text = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        text.text = @"Game Over";
        text.fontColor = [SKColor whiteColor];
        text.fontSize = 50;
        text.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        [self addChild:text];
    }
    return self;
}
-(void)didMoveToView:(SKView *)view {
    [self performSelector:@selector(goToStart) withObject:nil afterDelay:3.0];
}
-(void)goToStart {
    SKTransition *transition = [SKTransition flipVerticalWithDuration:1.0];
    SKScene *start = [[StartScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:start transition:transition];
}
@end
