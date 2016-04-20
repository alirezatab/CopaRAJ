//
//  Team+CoreDataProperties.h
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/20/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Team.h"

NS_ASSUME_NONNULL_BEGIN

@interface Team (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *abbreviationName;
@property (nullable, nonatomic, retain) NSString *countryName;
@property (nullable, nonatomic, retain) NSNumber *draws;
@property (nullable, nonatomic, retain) NSString *flagImageName;
@property (nullable, nonatomic, retain) NSString *gamesPlayed;
@property (nullable, nonatomic, retain) NSString *goalsAgainst;
@property (nullable, nonatomic, retain) NSString *goalsFor;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSNumber *isTournamentWinner;
@property (nullable, nonatomic, retain) NSNumber *losses;
@property (nullable, nonatomic, retain) NSString *points;
@property (nullable, nonatomic, retain) NSNumber *wins;
@property (nullable, nonatomic, retain) NSString *position;
@property (nullable, nonatomic, retain) Group *group;
@property (nullable, nonatomic, retain) NSSet<Match *> *matches;

@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addMatchesObject:(Match *)value;
- (void)removeMatchesObject:(Match *)value;
- (void)addMatches:(NSSet<Match *> *)values;
- (void)removeMatches:(NSSet<Match *> *)values;

@end

NS_ASSUME_NONNULL_END
