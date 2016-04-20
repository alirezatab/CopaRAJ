//
//  Group.m
//  CopaRAJ
//
//  Created by James Rochabrun on 19-04-16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "Group.h"
#import "Team.h"

@implementation Group

- (void)createDefaultGroupForGroup:(Group *)group withfirstTeam:(Team *)team1 andSecondTeam:(Team *)team2 andThirdTeam:(Team *)team3 andFourthTeam:(Team *)team4 {
  
  [group addTeamsObject:team1];
  [group addTeamsObject:team2];
  [group addTeamsObject:team3];
  [group addTeamsObject:team4];
  
  group.firstPlaceTeamName = team1.countryName;
  group.secondPlaceTeamName = team2.countryName;
  group.thirdPlaceTeamName = team3.countryName;
  group.fourthPlaceTeamName = team4.countryName;
  
 
}

- (void)createTeamNamesForGroup:(Group *)group {
  NSMutableArray *teamNames = [NSMutableArray new];
  
  for (Team *team in group.teams) {
    [teamNames addObject:team.countryName];
  }
  
  int count = (int)teamNames.count;

  for (int i = 0; i < count; i++) {
    if (i == 0) {
      group.firstPlaceTeamName = [teamNames objectAtIndex:0];
    } else if (i == 1) {
      group.secondPlaceTeamName = [teamNames objectAtIndex:1];
    } else if (i == 2) {
      group.thirdPlaceTeamName = [teamNames objectAtIndex:2];
    } else if (i == 3) {
      group.fourthPlaceTeamName = [teamNames objectAtIndex:3];
    } 
  }
  
  NSLog(@"Groups should have team names");
}

@end
