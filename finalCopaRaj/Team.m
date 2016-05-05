//
//  Team.m
//  CopaRAJ
//
//  Created by James Rochabrun on 19-04-16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "Team.h"
#import "Group.h"
#import "Match.h"

@implementation Team

- (void)createDefaultTeamSettingsForTeam:(Team *)team andName:(NSString *)teamName {
    team.countryName = teamName;
    team.draws = [NSNumber numberWithInt:0];
    team.flagImageName = @"ARG";
    team.gamesPlayed = @"0";
    team.goalsAgainst = @"0";
    team.goalsFor = @"0";
    team.id = @"0";
    team.isTournamentWinner = [NSNumber numberWithInt:0];
    team.losses = [NSNumber numberWithInt:0];
    team.points = @"0";
    team.wins = [NSNumber numberWithInt:0];
    //team.position = @"5";
}

+ (void)updateTeamFromTeamArray:(NSMutableArray *)teams WithLatestDictionary:(NSDictionary *)dictionary {
  
  NSString *teamNameFromDictionary = dictionary[@"team"];
  Team *teamForDictionary;
  
  for (Team *team in teams) {
    if ([team.countryName isEqualToString:teamNameFromDictionary]) {
      teamForDictionary = team;
    }
  }
  teamForDictionary.wins = dictionary[@"wins"];
  teamForDictionary.points = dictionary[@"points"];
  teamForDictionary.losses = dictionary[@"losses"];
  teamForDictionary.id = dictionary[@"id"];
  teamForDictionary.goalsFor = dictionary[@"gf"];
  teamForDictionary.goalsAgainst = dictionary[@"ga"];
  teamForDictionary.gamesPlayed = dictionary[@"round"];
  teamForDictionary.position = dictionary[@"pos"];
  teamForDictionary.draws = dictionary[@"draws"];
  
//  NSLog(@"The team that will be updated is %@", teamForDictionary.countryName);
  
}




@end

