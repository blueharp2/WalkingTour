//
//  CreateTourDetailViewController.h
//  WalkingTours
//
//  Created by Miles Ranisavljevic on 12/14/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@protocol CreateTourDetailViewControllerDelegate <NSObject>

- (void)didFinishSavingLocationWithLocation:(Location *)location;

@end

@interface CreateTourDetailViewController : UIViewController

@property (strong, nonatomic) id<CreateTourDetailViewControllerDelegate> delegate;

@end
