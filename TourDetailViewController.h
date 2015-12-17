//
//  TourDetailViewController.h
//  WalkingTours
//
//  Created by Miles Ranisavljevic on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;
#import "Location.h"

@interface TourDetailViewController : UIViewController

//@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) Location *location;
- (void)setLocation:(Location *)location;

@end
