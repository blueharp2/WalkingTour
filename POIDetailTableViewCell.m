//
//  POIDetailTableViewCell.m
//  WalkingTours
//
//  Created by Alberto Vega Gonzalez on 12/15/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "POIDetailTableViewCell.h"
#import "Location.h"

@interface POIDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *tourImageView;
@property (weak, nonatomic) IBOutlet UILabel *tourNameLabel;

@end

@implementation POIDetailTableViewCell

- (void)setTour:(Tour *)tour {
    self.tourNameLabel.text = tour.nameOfTour;
}


- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
