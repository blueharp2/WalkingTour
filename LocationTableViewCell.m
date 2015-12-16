//
//  LocationTableViewCell.m
//  WalkingTours
//
//  Created by Miles Ranisavljevic on 12/15/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "LocationTableViewCell.h"
@import Parse;

@interface LocationTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation LocationTableViewCell

- (void)awakeFromNib {
    self.locationImageView.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setLocation:(Location *)location {
    _location = location;
    self.locationLabel.text = location.locationName;
//    if ([location.photo.url containsString:@".jpg"]) {
//        [location.photo getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
//            if (error) {
//                NSLog(@"%@", error.localizedFailureReason);
//                self.locationImageView.backgroundColor = [UIColor colorWithRed:0.000 green:0.152 blue:1.000 alpha:1.000];
//            }
//            if (data) {
//                UIImage *image = [UIImage imageWithData:data];
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    self.locationImageView.image = image;
//                }];
//            }
//        }];
//    } else {
//        //get a screenshot from the video
//    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.locationImageView.image = image;
}

@end
