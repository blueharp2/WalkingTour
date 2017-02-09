//
//  CategoryTableViewCell.h
//  WalkingTours
//
//  Created by Cynthia Strickland on 12/14/15.
//  Copyright © 2015 Cynthia Strickland All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateTourDetailViewController.h"

@interface CategoryTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *category;
//@property (nonatomic) float checkboxAlpha;
- (void)setCategory:(NSString *)category;
//- (void)setCheckboxAlpha:(float)checkboxAlpha;

@end
