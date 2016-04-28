//
//  GameVC.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "GameVC.h"
#import <Firebase/Firebase.h>
#import "FBMatch.h"

@interface GameVC ()
@property FBMatch *match;
@property NSMutableArray *timeline;
@end

@implementation GameVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.match = [FBMatch new];
  
  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!later add if self.match. else.. use data passed to us via segue
  [self listenToMatch];
}

- (void)listenToMatch {
  
  //NSString *matchID = [NSString stringWithFormat:@"%@", self.matchID];
  //if matchID
  NSString *thisWillBeThePassedMatchID = @"377717";
  NSString *url = [NSString stringWithFormat:@"https://fiery-inferno-5799.firebaseio.com/matches/%@", thisWillBeThePassedMatchID];
  Firebase *ref = [[Firebase alloc]initWithUrl:url];
  [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {

    NSDictionary *matchDetails = snapshot.value;
    [self updateMatchWithData:matchDetails];
    
  } withCancelBlock:^(NSError *error) {
    NSLog(@"%@", error.description);
  }];
}

-(void)updateMatchWithData: (NSDictionary *)data {
  
  //General Match Data that exists before kickoff
  self.match.matchID = [data valueForKey:@"id"];
//  NSLog(@"%@ is the match id", self.match.matchID);
  self.match.groupCode = [data valueForKey:@"group_code"];
//  NSLog(@"%@ is the group code", self.match.groupCode);
  self.match.image_stadium = [data valueForKey:@"img_stadium"];
//  NSLog(@"%@ is the match stadium url", self.match.image_stadium);
  self.match.live_minute = [data valueForKey:@"live_minute"];
//  NSLog(@"%@ is the current minute of the match",self.match.live_minute);
  self.match.playoffs = [data valueForKey:@"playoffs"];
//  NSLog(@"%@ is the playoffs of the match", self.match.playoffs);
  self.match.schedule = [data valueForKey:@"schedule"];
//  NSLog(@"%@ is the scheduled time", self.match.schedule);
  self.match.stadium = [data valueForKey:@"stadium"];
//  NSLog(@"%@ is the stadium name", self.match.stadium);
  self.match.status = [data valueForKey:@"status"];
//  NSLog(@"%@ is the match status", self.match.status);
  
  //Local team info that typically exisits before matches
  self.match.local = [data valueForKey:@"local"];
//  NSLog(@"%@ is the local team", self.match.local);
  self.match.local_abbr = [data valueForKey:@"local_abbr"];
//  NSLog(@"%@ is the local abbr", self.match.local_abbr);
  self.match.local_goals = [data valueForKey:@"local_goals"];
//  NSLog(@"%@ is the local goals", self.match.local_goals);
  self.match.pen1 = [data valueForKey:@"pen1"];
//  NSLog(@"%@ is the local pens", self.match.pen1);

  
  //Visiting team info default
  self.match.visitor = [data valueForKey:@"visitor"];
  //NSLog(@"%@ is the visiting team", self.match.visitor);
  self.match.visitor_abbr = [data valueForKey:@"visitor_abbr"];
  //NSLog(@"%@ is the visiting abbr", self.match.visitor_abbr);
  self.match.visitor_goals = [data valueForKey:@"visitor_goals"];
  //NSLog(@"%@ is the visitor goals", self.match.visitor_goals);
  self.match.pen2 = [data valueForKey:@"pen2"];
  //NSLog(@"%@ is the visiting pens", self.match.pen2);
  self.match.visitor_tactic = [data valueForKey:@"visitor_tactic"];
  //NSLog(@"%@ is the local tactic", self.match.visitor_tactic);
  
  
  //match extra Data
  NSArray *extra_Data = [data valueForKey:@"extra_data"];
  if (![extra_Data isEqual:[NSNull null]] && extra_Data.count > 0) {
  
    NSDictionary *localExtra = [extra_Data objectAtIndex:1];
    self.match.local_pos = [localExtra objectForKey:@"pos"];
    //NSLog(@"%@ is local poss", self.match.local_pos);
    self.match.local_sot = [localExtra objectForKey:@"sot"];
    //NSLog(@"%@ is local sot", self.match.local_sot);
    self.match.local_son = [localExtra objectForKey:@"son"];
    //NSLog(@"%@ is local son", self.match.local_son);
    self.match.local_rc = [localExtra objectForKey:@"rc"];
    //NSLog(@"%@ is local RC", self.match.local_rc);
    self.match.local_pos = [localExtra objectForKey:@"pos"];
    //NSLog(@"%@ is local poss", self.match.local_pos);
    self.match.local_soff = [localExtra objectForKey:@"soff"];
    //NSLog(@"%@ is local soff", self.match.local_soff);
    self.match.local_frk = [localExtra objectForKey:@"frk"];
    //NSLog(@"%@ is local frk", self.match.local_frk);
    self.match.local_blk = [localExtra objectForKey:@"blk"];
    //NSLog(@"%@ is local blk", self.match.local_blk);
    self.match.local_yc = [localExtra objectForKey:@"yc"];
    //NSLog(@"%@ is local yc", self.match.local_yc);
    
    //lineup data
    NSDictionary *lineups = [data valueForKey:@"lineups"];
    self.match.local_tactic = [lineups valueForKey:@"local_tactic"];
    //NSLog(@"%@ is the local tactic", self.match.local_tactic);
    self.match.visitor_tactic = [lineups valueForKey:@"visitor_tactic"];
    //NSLog(@"%@ is the visitor tactic", self.match.visitor_tactic);
    NSArray *localLineup  = [lineups valueForKey:@"local"];
    self.match.local_Lineup = [FBMatch returnLineupArrayUsingLineupData:localLineup];
    //NSLog(@"%@ is the local lineup", self.match.local_Lineup);
    NSArray *visitorLineup = [lineups valueForKey:@"visitor"];
    self.match.visitor_Lineup = [FBMatch returnLineupArrayUsingLineupData:visitorLineup];
    //NSLog(@"%@ is the visitor linup", self.match.visitor_Lineup);
    
    //events
    NSDictionary *events = [data valueForKey:@"events"];
    //NSLog(@"Events : %@", events);

    //--cards
    NSArray *cards = [events valueForKey:@"cards"];
    //NSLog(@"Cards: %@", cards);
    self.match.cards = [NSMutableArray new];
    for (NSDictionary *card in cards) {
      [self.match.cards addObject:card];
    }
    
    //--Substitutions
    NSArray *changes = [events valueForKey:@"changes"];
    //NSLog(@"Changes!!!!!: %@",changes);
    self.match.changes = [NSMutableArray new];
    for (NSDictionary *change in changes) {
      [self.match.changes addObject:change];
    }
   // NSLog(@"self.match.changes == %@", self.match.changes);
    
    //--Goals
    NSArray *goals = [events valueForKey:@"goals"];
    //NSLog(@"Goals: %@",goals);
    self.match.goals = [NSMutableArray new];
    for (NSDictionary *goal in goals) {
      [self.match.goals addObject:goal];
    }
    
    //timeline
    if (self.match.goals.count <1 && self.match.cards.count < 1 && self.match.changes.count < 1) {
    } else {
    NSArray *timeLine = [FBMatch createTimeLineWithMatch: self.match];
    if (timeLine.count > 0) {
      self.match.timeline = [NSMutableArray arrayWithArray:[NSArray arrayWithArray:timeLine]];
    }
    }
    
    
  }//if there is extra data closing bracket
  
}

//after you have everything


//@property NSMutableArray *timeline;
@end
