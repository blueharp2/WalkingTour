//
//  TourListViewController.h
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/15/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTableViewCell.h"
@import Parse;
@import ParseUI;


@interface TourListViewController : PFQueryTableViewController

@property (weak, nonatomic) UIImageView *locationImageView;
@property (weak, nonatomic) UILabel *locationLabel;

@end
