//
//  HomeTableViewCell.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //label formatting in HomeVC
    self.teamOneName.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:15];
    self.teamTwoName.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:15];
    self.teamOneScore.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:18];
    self.teamTwoScore.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:18];
    self.timeLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:13];
    self.locationLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:10];
    self.penaltiesLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:11];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFont:(UIFont *)font {
    
}




@end
