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

@end

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCategory:(NSString *)category {
    _category = category;
    self.categoryLabel.text = self.category;
}

@end
