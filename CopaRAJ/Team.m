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
    team.flagImageName = team.abbreviationName;
    team.gamesPlayed = @"0";
    team.goalsAgainst = @"0";
    team.goalsFor = @"0";
    team.id = @"0";
    team.isTournamentWinner = [NSNumber numberWithInt:0];
    team.losses = [NSNumber numberWithInt:0];
    team.points = @"0";
    team.wins = [NSNumber numberWithInt:0];
    team.position = @"5";
}



@end

