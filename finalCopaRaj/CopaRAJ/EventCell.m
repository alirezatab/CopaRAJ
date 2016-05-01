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
    self.playerLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:13];
    self.outLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:13];
    self.inLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:13];
    
    self.timeLabel.tintColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    
    
    [self.timeLabel setTextColor:[UIColor colorWithWhite:0.600 alpha:1.000]];
     
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    

    
    // Configure the view for the selected state
}

@end
