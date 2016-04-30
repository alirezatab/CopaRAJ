//
//  GroupTableViewCell.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "GroupTableViewCell.h"

@implementation GroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //changing the fonts for the groupVC
    self.teamCountry.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:18];
    self.teamGoals.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.teamWins.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.teamTies.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.teamLosses.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.teamPoints.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    //assigning the distances programatically
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}




@end
