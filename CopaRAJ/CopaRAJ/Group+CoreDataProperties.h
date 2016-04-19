//
//  Group+CoreDataProperties.h
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Group.h"

NS_ASSUME_NONNULL_BEGIN

@interface Group (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *firstPlaceTeamName;
@property (nullable, nonatomic, retain) NSString *fourthPlaceTeamName;
@property (nullable, nonatomic, retain) NSString *groupID;
@property (nullable, nonatomic, retain) NSString *secondPlaceTeamName;
@property (nullable, nonatomic, retain) NSString *thirdPlaceTeamName;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *teams;

@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(NSManagedObject *)value;
- (void)removeTeamsObject:(NSManagedObject *)value;
- (void)addTeams:(NSSet<NSManagedObject *> *)values;
- (void)removeTeams:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
