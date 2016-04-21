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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setTeam:(Team *)team {
  _team = team;
  self.teamCountry.text = team.countryName;
  self.teamImage.image = [UIImage imageNamed:team.abbreviationName];
  NSLog(@"%@ is the team immage", team.abbreviationName);
  self.teamGoals.text = team.goalsFor;
  self.teamWins.text = [NSString stringWithFormat:@"%@", team.wins];
  self.teamTies.text = [NSString stringWithFormat:@"%@", team.draws];
  self.teamLosses.text = [NSString stringWithFormat:@"%@", team.losses];
  self.teamPoints.text = team.points;
}


@end
