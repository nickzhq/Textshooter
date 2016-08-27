//
//  BulletNode.m
//  Textshooter
//
//  Created by Houqi Zuo on 8/26/16.
//  Copyright © 2016 University of New Haven. All rights reserved.
//

#import "BulletNode.h"
#import "PhysicsCategories.h"
#import "Geometry.h"
@interface BulletNode()
@property (assign, nonatomic) CGVector thrust;
@end

@implementation BulletNode
+(instancetype)bulletFrom:(CGPoint)start toward:(CGPoint)destination {
    BulletNode *bullet = [[self alloc] init];
    
    bullet.position = start;
    
    CGVector movement = VectorBetweenPoints(start, destination);
    CGFloat magnitude = VectorDistance(movement);
    if(magnitude == 0.0f) return nil;
    
    CGVector scaledMovement = VectorMultiply(movement, 1 / magnitude);
    
    CGFloat thrustMagnitude = 100.0;
    bullet.thrust = VectorMultiply(scaledMovement, thrustMagnitude);
    
    return bullet;
}

-(instancetype)init {
    if(self = [super init]) {
        SKLabelNode *dot = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        dot.fontColor = [SKColor blackColor];
        dot.fontSize = 40;
        dot.text = @".";
        [self addChild:dot];
        
        SKPhysicsBody *body = [SKPhysicsBody bodyWithCircleOfRadius:1];
        body.dynamic = YES;
        body.categoryBitMask = PlayerMissileCategory;
        body.contactTestBitMask = EnemyCategory;
        body.collisionBitMask = EnemyCategory;
        body.mass = 0.01;
        
        self.physicsBody = body;
        self.name = [NSString stringWithFormat:@"Bullet %p", self];
    }
    return self;
}

-(void)applyRecurringForce {
    [self.physicsBody applyForce:self.thrust];
}
@end
