//
//  Group.h
//  CopaRAJ
//
//  Created by James Rochabrun on 19-04-16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;

NS_ASSUME_NONNULL_BEGIN

@interface Group : NSManagedObject

- (void)createDefaultGroupForGroup:(Group *)group withfirstTeam:(Team *)team1 andSecondTeam:(Team *)team2 andThirdTeam:(Team *)team3 andFourthTeam:(Team *)team4;
- (NSArray *)returnGroupTeamsOrderedByPointsForGroup:(Group *)group;

@end

NS_ASSUME_NONNULL_END

#import "Group+CoreDataProperties.h"
