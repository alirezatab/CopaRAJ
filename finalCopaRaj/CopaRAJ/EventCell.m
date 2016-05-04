//
//  EventCell.m
//  CopaRAJ
//
//  Created by James Rochabrun on 30-04-16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:13];
    [self.timeLabel setTextColor:[UIColor whiteColor]];

    self.playerLabel.font = [UIFont fontWithName:@"GOTHAM Narrow" size:14];
    [self.playerLabel setTextColor:[UIColor whiteColor]];
    
    self.outLabel.font = [UIFont fontWithName:@"GOTHAM Narrow" size:14];
    [self.outLabel setTextColor:[UIColor whiteColor]];
    
    self.inLabel.font = [UIFont fontWithName:@"GOTHAM Narrow" size:14];
    [self.inLabel setTextColor:[UIColor whiteColor]];
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    

    
    // Configure the view for the selected state
}

@end
