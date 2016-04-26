//
//  FBGroup.h
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/25/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBGroup : NSObject
@property NSString *groupLetter;
@property NSString *groupRound;

@property NSNumber *team1avg;
@property NSNumber *team1Draws;
@property NSString *team1GA;
@property NSNumber *team1Losses;
@property NSString *team1Points;
@property NSString *team1Pos;
@property NSString *team1Team;
@property NSNumber *team1Wins;
@property NSString *team1Gf;


@property NSNumber *team2avg;
@property NSNumber* team2Draws;
@property NSString *team2GA;
@property NSNumber* team2Losses;
@property NSString *team2Points;
@property NSString *team2Pos;
@property NSString *team2Team;
@property NSNumber *team2Wins;
@property NSString *team2Gf;

@property NSNumber *team3avg;
@property NSNumber *team3Draws;
@property NSString *team3GA;
@property NSNumber *team3Losses;
@property NSString *team3Points;
@property NSString *team3Pos;
@property NSString *team3Team;
@property NSNumber *team3Wins;
@property NSString *team3Gf;

@property NSNumber *team4avg;
@property NSNumber *team4Draws;
@property NSString *team4GA;
@property NSNumber *team4Losses;
@property NSString *team4Points;
@property NSString *team4Pos;
@property NSString *team4Team;
@property NSNumber *team4Wins;
@property NSString *team4Gf;

+(FBGroup *)createGroupFromTable: (NSMutableArray*) table;



@end
