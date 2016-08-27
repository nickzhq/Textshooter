//
//  BulletNode.h
//  Textshooter
//
//  Created by Houqi Zuo on 8/26/16.
//  Copyright © 2016 University of New Haven. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BulletNode : SKNode

+(instancetype)bulletFrom:(CGPoint)start toward:(CGPoint)destination;
-(void)applyRecurringForce;

@end
