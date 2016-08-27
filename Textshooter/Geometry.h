//
//  Geometry.h
//  Textshooter
//
//  Created by Houqi Zuo on 8/26/16.
//  Copyright © 2016 University of New Haven. All rights reserved.
//

#ifndef Geometry_h
#define Geometry_h

static inline CGVector VectorMultiply(CGVector v, CGFloat m) {
    return CGVectorMake(v.dx * m, v.dy * m);
}

static inline CGVector VectorBetweenPoints(CGPoint p1, CGPoint p2) {
    return CGVectorMake(p2.x - p1.x, p2.y - p1.y);
}

// Pythagoras theorem
static inline CGFloat VectorDistance(CGVector v) {
    return sqrtf( powf(v.dx, 2) + powf(v.dy, 2) );
}

static inline CGFloat PointDistance(CGPoint p1, CGPoint p2) {
    return sqrtf( powf(p2.x - p1.x, 2) + powf(p2.y - p1.y, 2) );
}
#endif /* Geometry_h */
