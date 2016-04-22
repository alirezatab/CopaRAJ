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
}

- (NSArray *)returnGroupTeamsOrderedByPointsForGroup:(Group *)group {
  
  NSMutableArray *teams = [NSMutableArray new];
  
  for (Team *team in group.teams) {
    [teams addObject:team];
  }
  
  NSSortDescriptor *sortDescriptor;
  sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position"
                                               ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
  NSArray *sortedTeams = [teams sortedArrayUsingDescriptors:sortDescriptors];
  
  NSLog(@"the group is sorted like this First : %@ and Last: %@", sortedTeams.firstObject, sortedTeams.lastObject);
  return sortedTeams;
}
@end












