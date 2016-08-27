//
//  PhysicsCategories.h
//  Textshooter
//
//  Created by Houqi Zuo on 8/26/16.
//  Copyright © 2016 University of New Haven. All rights reserved.
//

#ifndef PhysicsCategories_h
#define PhysicsCategories_h

typedef NS_OPTIONS(uint32_t, PhysicsCategory) {
    PlayerCategory        = 1 << 1,
    EnemyCategory         = 1 << 2,
    PlayerMissileCategory = 1 << 3
};
#endif /* PhysicsCategories_h */
