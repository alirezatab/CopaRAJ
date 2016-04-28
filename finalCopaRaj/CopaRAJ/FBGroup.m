//
//  FBGroup.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/25/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "FBGroup.h"

@implementation FBGroup

+(FBGroup *)createGroupFromTable: (NSMutableArray*) table {
  FBGroup *returnedGroup = [FBGroup new];
  
    NSDictionary *team1 = [table objectAtIndex:0];
    NSDictionary *team2 = [table objectAtIndex:1];
    NSDictionary *team3 = [table objectAtIndex:2];
    NSDictionary *team4 = [table objectAtIndex:3];
  
    returnedGroup.groupLetter = [team1 objectForKey:@"group"];
    returnedGroup.groupRound = [team1 objectForKey:@"round"];
    NSLog(@"%@ is the group letter. %@ is the group round.", returnedGroup.groupLetter, returnedGroup.groupRound);
  
    returnedGroup.team1avg = [team1 objectForKey:@"avg"];
    returnedGroup.team1Draws = [team1 objectForKey:@"draws"];
    returnedGroup.team1Losses = [team1 objectForKey:@"losses"];
    returnedGroup.team1Points = [team1 objectForKey:@"points"];
    returnedGroup.team1Pos = [team1 objectForKey:@"pos"];
    returnedGroup.team1Team= [team1 objectForKey:@"team"];
    returnedGroup.team1Wins = [team1 objectForKey:@"wins"];
    returnedGroup.team1Gf = [team1 objectForKey:@"gf"];
    NSLog(@"Team 1: %@", returnedGroup.team1Gf);
  
  
  
    returnedGroup.team2avg = [team2 objectForKey:@"avg"];
    returnedGroup.team2Draws = [team2 objectForKey:@"draws"];
    returnedGroup.team2Losses = [team2 objectForKey:@"losses"];
    returnedGroup.team2Points = [team2 objectForKey:@"points"];
    returnedGroup.team2Pos = [team2 objectForKey:@"pos"];
    returnedGroup.team2Team= [team2 objectForKey:@"team"];
    returnedGroup.team2Wins = [team2 objectForKey:@"wins"];
    returnedGroup.team2Gf = [team2 objectForKey:@"gf"];
    NSLog(@"Team 2: %@", returnedGroup.team2Gf);
  
    returnedGroup.team3avg = [team3 objectForKey:@"avg"];
    returnedGroup.team3Draws = [team3 objectForKey:@"draws"];
    returnedGroup.team3Losses = [team3 objectForKey:@"losses"];
    returnedGroup.team3Points = [team3 objectForKey:@"points"];
    returnedGroup.team3Pos = [team3 objectForKey:@"pos"];
    returnedGroup.team3Team= [team3 objectForKey:@"team"];
    returnedGroup.team3Wins = [team3 objectForKey:@"wins"];
    returnedGroup.team3Gf = [team3 objectForKey:@"gf"];
    NSLog(@"Team 3: %@", returnedGroup.team3Gf);
  
    returnedGroup.team4avg = [team4 objectForKey:@"avg"];
    returnedGroup.team4Draws = [team4 objectForKey:@"draws"];
    returnedGroup.team4Losses = [team4 objectForKey:@"losses"];
    returnedGroup.team4Points = [team4 objectForKey:@"points"];
    returnedGroup.team4Pos = [team4 objectForKey:@"pos"];
    returnedGroup.team4Team= [team4 objectForKey:@"team"];
    returnedGroup.team4Wins = [team4 objectForKey:@"wins"];
    returnedGroup.team4Gf = [team4 objectForKey:@"gf"];
    NSLog(@"Team 4: %@", returnedGroup.team4Gf);

    return returnedGroup;
}

@end


