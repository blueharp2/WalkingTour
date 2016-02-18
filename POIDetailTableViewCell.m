//
//  POIDetailTableViewCell.m
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/15/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "POIDetailTableViewCell.h"
#import "Location.h"

@interface POIDetailTableViewCell () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *tourImageView;
@property (weak, nonatomic) IBOutlet UILabel *tourNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *favoriteStarButton;
- (IBAction)favoriteStarButtonPressed:(id)sender;

@end

@implementation POIDetailTableViewCell

- (void)setTour:(Tour *)tour {
    _tour = tour;
    self.tourNameLabel.text = tour.nameOfTour;
}

- (void)awakeFromNib {
    [_favoriteStarButton setTitle:@"☆" forState:UIControlStateNormal];
    _favoriteStarButton.titleLabel.font = [UIFont fontWithName:@"Futura" size:30];
    _favoriteStarButton.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [_favoriteStarButton setTintColor:[UIColor colorWithRed:0.278 green:0.510 blue:0.855 alpha:1.000]];
    [_favoriteStarButton setShowsTouchWhenHighlighted:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (IBAction)favoriteStarButtonPressed:(id)sender {
    NSString *currentTitle = [_favoriteStarButton titleForState:UIControlStateNormal];
    NSString *newTitle = [currentTitle isEqual:@"☆"]? @"★" : @"☆";
    [_favoriteStarButton setTitle:newTitle forState:UIControlStateNormal];
    
    if (self.delegate) {
        [self.delegate favoriteButtonPressedForTourID:self.tour.objectId];
       // NSLog(@"%@", self.tour.objectId);
    }
}
@end
