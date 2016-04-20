//
//  Team.h
//  CopaRAJ
//
//  Created by James Rochabrun on 19-04-16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Match;

NS_ASSUME_NONNULL_BEGIN

@interface Team : NSManagedObject

- (void)createDefaultTeamSettingsForTeam:(Team *)team andName:(NSString *)teamName;

@end

NS_ASSUME_NONNULL_END

#import "Team+CoreDataProperties.h"
