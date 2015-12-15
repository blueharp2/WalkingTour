//
//  CategoryTableViewCell.h
//  WalkingTours
//
//  Created by Miles Ranisavljevic on 12/15/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateTourDetailViewController.h"

@interface CategoryTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *category;
- (void)setCategory:(NSString *)category;

@end
