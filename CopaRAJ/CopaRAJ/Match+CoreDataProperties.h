//
//  Match+CoreDataProperties.h
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Match.h"

NS_ASSUME_NONNULL_BEGIN

@interface Match (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *groupCode;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *kickoffTime;
@property (nullable, nonatomic, retain) NSString *localAbbr;
@property (nullable, nonatomic, retain) NSString *localTeam;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *penalties1;
@property (nullable, nonatomic, retain) NSString *penalties2;
@property (nullable, nonatomic, retain) NSString *score;
@property (nullable, nonatomic, retain) NSString *timeInGame;
@property (nullable, nonatomic, retain) NSString *visitingTeam;
@property (nullable, nonatomic, retain) NSString *visitorAbbr;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *teams;

@end

@interface Match (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(NSManagedObject *)value;
- (void)removeTeamsObject:(NSManagedObject *)value;
- (void)addTeams:(NSSet<NSManagedObject *> *)values;
- (void)removeTeams:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
