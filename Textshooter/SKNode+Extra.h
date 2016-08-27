//
//  SKNode+Extra.h
//  Textshooter
//
//  Created by Houqi Zuo on 8/27/16.
//  Copyright © 2016 University of New Haven. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKNode (Extra)
-(void)receiveAttacker:(SKNode *)attacker contact:(SKPhysicsContact *)contact;
-(void)friendlyBumpFrom:(SKNode *)node;
@end
