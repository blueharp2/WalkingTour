//
//  ParseService.h
//  WalkingTours
//
//  Created by Lindsey on 12/15/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tour.h"


@interface ParseService : NSObject

+ (void)saveToParse:(Tour *)tour locations:(NSArray *)locations;

@end
