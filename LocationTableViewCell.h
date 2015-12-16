//
//  LocationTableViewCell.h
//  WalkingTours
//
//  Created by Miles Ranisavljevic on 12/15/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface LocationTableViewCell : UITableViewCell

@property (strong, nonatomic) Location *location;
- (void)setLocation:(Location *)location;

@end
