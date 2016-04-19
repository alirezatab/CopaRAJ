//
//  Team.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "Team.h"
#import "Group.h"
#import "Match.h"

@implementation Team

- (instancetype)initTeamWithCountryName:(NSString *)countryName andFlagImageName:(NSString *)flagImageName {
  self = [super init];
  
  if (self) {
    self.countryName = countryName;
    self.draws = 0;
    self.flagImageName = flagImageName;
    self.gamesPlayed = @"0";
    self.goalsAgainst = @"0";
    self.goalsFor = @"0";
    self.id = @"";
    self.isTournamentWinner = FALSE;
    self.losses = 0;
    self.points = @"0";
    self.wins =0;
  }
  
  return self;
}

@end

