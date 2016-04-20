//
//  Group+CoreDataProperties.h
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/20/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Group.h"

NS_ASSUME_NONNULL_BEGIN

@interface Group (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *groupID;
@property (nullable, nonatomic, retain) NSSet<Team *> *teams;

@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet<Team *> *)values;
- (void)removeTeams:(NSSet<Team *> *)values;

@end

NS_ASSUME_NONNULL_END
