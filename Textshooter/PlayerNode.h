//
//  PlayerNode.h
//  Textshooter
//
//  Created by Houqi Zuo on 8/26/16.
//  Copyright © 2016 University of New Haven. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Geometry.h"
@interface PlayerNode : SKNode
-(CGFloat)moveToward:(CGPoint)location;
@end
