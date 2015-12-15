//
//  CategoryTableViewCell.m
//  WalkingTours
//
//  Created by Miles Ranisavljevic on 12/15/15.
//  Copyright © 2015 Lindsey Boggio. All rights reserved.
//

#import "CategoryTableViewCell.h"

@interface CategoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkboxLabel;

@end

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    self.checkboxAlpha = 0.0;
    self.checkboxLabel.alpha = self.checkboxAlpha;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCategory:(NSString *)category {
    _category = category;
    self.categoryLabel.text = self.category;
}

- (void)setCheckboxAlpha:(float)checkboxAlpha {
    _checkboxAlpha = checkboxAlpha;
    [UIView animateWithDuration:0.5 animations:^{
        self.checkboxLabel.alpha = _checkboxAlpha;
    }];
}

@end
