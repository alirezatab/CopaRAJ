//
//  Match+CoreDataProperties.h
//  CopaRAJ
//
//  Created by James Rochabrun on 26-04-16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Match.h"

NS_ASSUME_NONNULL_BEGIN

@interface Match (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *groupCode;
@property (nullable, nonatomic, retain) NSString *hour;
@property (nullable, nonatomic, retain) NSString *localAbbr;
@property (nullable, nonatomic, retain) NSString *localTeam;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *matchId;
@property (nullable, nonatomic, retain) NSString *minute;
@property (nullable, nonatomic, retain) NSString *penalties1;
@property (nullable, nonatomic, retain) NSString *penalties2;
@property (nullable, nonatomic, retain) NSString *score;
@property (nullable, nonatomic, retain) NSString *timeInGame;
@property (nullable, nonatomic, retain) NSString *visitingTeam;
@property (nullable, nonatomic, retain) NSString *visitorAbbr;
@property (nullable, nonatomic, retain) NSString *localScore;
@property (nullable, nonatomic, retain) NSString *visitorScore;
@property (nullable, nonatomic, retain) NSSet<Team *> *teams;

@end

@interface Match (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet<Team *> *)values;
- (void)removeTeams:(NSSet<Team *> *)values;

@end

NS_ASSUME_NONNULL_END
