//
//  FBMatch.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/25/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//
#import "FBMatch.h"
@implementation FBMatch

+ (NSArray *)createTimeLineWithMatch: (FBMatch *)match {
    
    NSMutableArray *nonsortedArray = [NSMutableArray new];
    
    for (NSDictionary *goal in match.goals) {
        [nonsortedArray addObject:goal];
    }
    //cards
    for (NSDictionary *cards in match.cards) {
        [nonsortedArray addObject:cards];
    }
    //substitutions
    NSMutableArray *localChanges = [NSMutableArray new];
    NSMutableArray *visitorChanges = [NSMutableArray new];
    for (NSDictionary *change in match.changes) {
        if ([[change valueForKey:@"team"] isEqualToString:@"local"]) {
            [localChanges addObject:change];
        } else {
            [visitorChanges addObject:change];
        }
    }
    //NSLog(@"local changes: %@ ", localChanges);
    //NSLog(@"visitor changes: %@ ", visitorChanges);
    
    if (localChanges.count % 2 == 0) {
        match.arrayOfSubstitutionDictionaries = [NSMutableArray new];
        NSMutableArray *arrayOfLocalSubstitutionDictionaries = [match returnSubstitutionsWithArrayOfChanges:localChanges];
        //NSLog(@"local subs returned: %@", arrayOfLocalSubstitutionDictionaries);
        for (NSDictionary *sub in arrayOfLocalSubstitutionDictionaries) {
            [nonsortedArray addObject:sub];
        }
    }
    
    if (visitorChanges.count % 2 == 0) {
        match.arrayOfSubstitutionDictionaries = [NSMutableArray new];
        NSMutableArray *arrayOfVisitorSubstitutionDictionaries = [match returnSubstitutionsWithArrayOfChanges:visitorChanges];
        //NSLog(@"visitor subs returned: %@", arrayOfVisitorSubstitutionDictionaries);
        for (NSDictionary *sub in arrayOfVisitorSubstitutionDictionaries) {
            [nonsortedArray addObject:sub];
        }
    }
    NSSortDescriptor *minute= [[NSSortDescriptor alloc] initWithKey:@"minute" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:minute];
    NSMutableArray *returnArray = [NSMutableArray arrayWithArray:[nonsortedArray sortedArrayUsingDescriptors:sortDescriptors]];
    //NSLog(@"RETURN THE CRAKEN!!!!! %@", returnArray);
    return returnArray;
    
}
+ (NSMutableArray *)returnLineupArrayUsingLineupData:(NSArray *)array {
    NSMutableArray *returnedArray = [NSMutableArray new];
    
    for (NSDictionary *player in array) {
        [returnedArray addObject:player];
        //NSLog(@"%@", player);
    }
    return returnedArray;
}
- (NSMutableArray *)returnSubstitutionsWithArrayOfChanges: (NSMutableArray *)changes{
    
    self.subIn = nil;
    self.subOut = nil;
    for (int i = 0; i < changes.count; i++) {
        NSDictionary *event = [changes objectAtIndex:i];
        if (self.subIn == nil && [[event objectForKey:@"action"] isEqualToString:[NSMutableString stringWithFormat:@"Entra en el partido"]]) {
            self.subIn = event;
            if (self.subOut != nil) {
                break;
            }
        } else if (self.subOut == nil && [[event objectForKey:@"action"] isEqualToString:[NSMutableString stringWithFormat:@"Sale del partido"]]){
            self.subOut = event;
            if (self.subIn !=nil) {
                break;
            }
        }
    }
    
    NSDictionary *substitution = @{@"playerIn": [self.subIn objectForKey:@"player"], @"playerOut": [self.subOut objectForKey:@"player"], @"minute": [self.subOut objectForKey:@"minute"], @"team": [self.subOut objectForKey:@"team"], @"action": @"substitution"};
    [self.arrayOfSubstitutionDictionaries addObject:substitution];
    //NSLog(@"%@ subin", self.subIn);
    //NSLog(@"%@ subout", self.subOut);
    //NSLog(@"changes.count before removal: %lu",(unsigned long)changes.count);
    [changes removeObject:self.subIn];
    [changes removeObject:self.subOut];
    //NSLog(@"changes.count after removal: %lu",(unsigned long)changes.count);
    
    if (changes.count > 0) {
        //NSLog(@"array for return : %@", self.arrayOfSubstitutionDictionaries);
        [self returnSubstitutionsWithArrayOfChanges:changes];
    }
    
    return self.arrayOfSubstitutionDictionaries;
}
- (void)updateMatch: (FBMatch *)match WithData: (NSDictionary *)data {
    
    //General Match Data that exists before kickoff
    match.matchID = [data valueForKey:@"id"];
    //  NSLog(@"%@ is the match id", match.matchID);
    match.groupCode = [data valueForKey:@"group_code"];
    //  NSLog(@"%@ is the group code", match.groupCode);
    match.image_stadium = [data valueForKey:@"img_stadium"];
    //  NSLog(@"%@ is the match stadium url", match.image_stadium);
    match.live_minute = [data valueForKey:@"live_minute"];
    //  NSLog(@"%@ is the current minute of the match",match.live_minute);
    match.playoffs = [data valueForKey:@"playoffs"];
    //  NSLog(@"%@ is the playoffs of the match", match.playoffs);
    match.stadium = [data valueForKey:@"stadium"];
    //  NSLog(@"%@ is the stadium name", match.stadium);
    match.status = [data valueForKey:@"status"];
    //  NSLog(@"%@ is the match status", match.status);
    match.schedule = [data valueForKey:@"schedule"];
    //  NSLog(@"%@ is the scheduled time", match.schedule);
    NSArray *seperatedSchedule = [match.schedule componentsSeparatedByString:@" "];
    match.date = seperatedSchedule[0];
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyy/MM/dd"];
    match.nsdate = [formater dateFromString:match.date];
  
  
    //NSLog(@"THIS IS THE Date -%@-", match.date);
    NSString *time =  seperatedSchedule[1];
    NSArray *timeSeparated = [time componentsSeparatedByString:@":"];
    match.hour = timeSeparated[0];
    match.minute = timeSeparated[1];
    //NSLog(@"%@: hour %@: minute %@:date",match.hour, match.minute, match.date);
  
  //NSLog(@"THIS IS THE SCORE %@", seperatedScore[1]);
  //self.visitorTeamScore.text = seperatedScore[1];
    
    //Local team info that typically exisits before matches
    match.local = [data valueForKey:@"local"];
    //  NSLog(@"%@ is the local team", match.local);
    match.local_abbr = [data valueForKey:@"local_abbr"];
    //  NSLog(@"%@ is the local abbr", match.local_abbr);
    match.local_goals = [data valueForKey:@"local_goals"];
    //  NSLog(@"%@ is the local goals", match.local_goals);
    match.pen1 = [data valueForKey:@"pen1"];
    //  NSLog(@"%@ is the local pens", match.pen1);
    
    
    //Visiting team info default
    match.visitor = [data valueForKey:@"visitor"];
    //NSLog(@"%@ is the visiting team", match.visitor);
    match.visitor_abbr = [data valueForKey:@"visitor_abbr"];
    //NSLog(@"%@ is the visiting abbr", match.visitor_abbr);
    match.visitor_goals = [data valueForKey:@"visitor_goals"];
    //NSLog(@"%@ is the visitor goals", match.visitor_goals);
    match.pen2 = [data valueForKey:@"pen2"];
    //NSLog(@"%@ is the visiting pens", match.pen2);
    match.visitor_tactic = [data valueForKey:@"visitor_tactic"];
    //NSLog(@"%@ is the local tactic", match.visitor_tactic);
    
    
    //match extra Data
    NSArray *extra_Data = [data valueForKey:@"extra_data"];
    if (![extra_Data isEqual:[NSNull null]] && extra_Data.count > 0) {
        
        NSDictionary *localExtra = [extra_Data objectAtIndex:1];
        match.local_pos = [localExtra objectForKey:@"pos"];
        //NSLog(@"%@ is local poss", match.local_pos);
        match.local_sot = [localExtra objectForKey:@"sot"];
        //NSLog(@"%@ is local sot", match.local_sot);
        match.local_son = [localExtra objectForKey:@"son"];
        //NSLog(@"%@ is local son", match.local_son);
        match.local_rc = [localExtra objectForKey:@"rc"];
        //NSLog(@"%@ is local RC", match.local_rc);
        match.local_pos = [localExtra objectForKey:@"pos"];
        //NSLog(@"%@ is local poss", match.local_pos);
        match.local_soff = [localExtra objectForKey:@"soff"];
        //NSLog(@"%@ is local soff", match.local_soff);
        match.local_frk = [localExtra objectForKey:@"frk"];
        //NSLog(@"%@ is local frk", smatch.local_frk);
        match.local_blk = [localExtra objectForKey:@"blk"];
        //NSLog(@"%@ is local blk", match.local_blk);
        match.local_yc = [localExtra objectForKey:@"yc"];
        //NSLog(@"%@ is local yc", match.local_yc);
        
        NSDictionary *visitorExtra = [extra_Data objectAtIndex:2];
        match.visitor_pos = [visitorExtra objectForKey:@"pos"];
        //NSLog(@"%@ is visitor poss", match.visitor_pos);
        match.visitor_sot = [visitorExtra objectForKey:@"sot"];
        //NSLog(@"%@ is visitor sot", match.visitor_sot);
        match.visitor_son = [visitorExtra objectForKey:@"son"];
        //NSLog(@"%@ is visitor son", match.visitor_son);
        match.visitor_rc = [visitorExtra objectForKey:@"rc"];
        //NSLog(@"%@ is visitor RC", match.visitor_rc);
        match.visitor_pos = [visitorExtra objectForKey:@"pos"];
        //NSLog(@"%@ is visitor poss", match.visitor_pos);
        match.visitor_soff = [visitorExtra objectForKey:@"soff"];
        //NSLog(@"%@ is visitor soff", match.visitor_soff);
        match.visitor_frk = [visitorExtra objectForKey:@"frk"];
        //NSLog(@"%@ is visitor frk", smatch.visitor_frk);
        match.visitor_blk = [visitorExtra objectForKey:@"blk"];
        //NSLog(@"%@ is visitor blk", match.visitor_blk);
        match.visitor_yc = [visitorExtra objectForKey:@"yc"];
        //NSLog(@"%@ is visitor yc", match.visitor_yc);
        
        //lineup data
        NSDictionary *lineups = [data valueForKey:@"lineups"];
        match.local_tactic = [lineups valueForKey:@"local_tactic"];
        //NSLog(@"%@ is the local tactic", match.local_tactic);
        match.visitor_tactic = [lineups valueForKey:@"visitor_tactic"];
        //NSLog(@"%@ is the visitor tactic", match.visitor_tactic);
        NSArray *localLineup  = [lineups valueForKey:@"local"];
        match.local_Lineup = [FBMatch returnLineupArrayUsingLineupData:localLineup];
        //NSLog(@"%@ is the local lineup", match.local_Lineup);
        NSArray *visitorLineup = [lineups valueForKey:@"visitor"];
        match.visitor_Lineup = [FBMatch returnLineupArrayUsingLineupData:visitorLineup];
        //NSLog(@"%@ is the visitor linup", match.visitor_Lineup);
        
        //events
        NSDictionary *events = [data valueForKey:@"events"];
        //NSLog(@"Events : %@", events);
        
        //--cards
        NSArray *cards = [events valueForKey:@"cards"];
        //NSLog(@"Cards: %@", cards);
        match.cards = [NSMutableArray new];
        for (NSDictionary *card in cards) {
            [match.cards addObject:card];
        }
        
        //--Substitutions
        NSArray *changes = [events valueForKey:@"changes"];
        //NSLog(@"Changes!!!!!: %@",changes);
        match.changes = [NSMutableArray new];
        for (NSDictionary *change in changes) {
            [match.changes addObject:change];
        }
        // NSLog(@"match.changes == %@", match.changes);
        
        //--Goals
        NSArray *goals = [events valueForKey:@"goals"];
        //NSLog(@"Goals: %@",goals);
        match.goals = [NSMutableArray new];
        for (NSDictionary *goal in goals) {
            [match.goals addObject:goal];
        }
        
        //timeline
        if (match.goals.count <1 && match.cards.count < 1 && match.changes.count < 1) {
        } else {
            NSArray *timeLine = [FBMatch createTimeLineWithMatch: match];
            if (timeLine.count > 0) {
                match.timeline = [NSMutableArray arrayWithArray:[NSArray arrayWithArray:timeLine]];
            }
        }
    }//if there is extra data closing bracket
    //NSLog(@"%@", match);
    //NSLog(@"%@ is the status", match.status);
    //NSLog(@"%@ is the local_soff", match.local_soff);
    //NSLog(@"%@ is the local_rc", match.local_rc);
    //NSLog(@"%@ is the pen1", match.pen1);
    //NSLog(@"%@ is the pen1", match.pen2);
}

//else if match is playoff match
+ (void)updateMatchInArray: (NSMutableArray *)array withData:(NSDictionary *)data {
  NSString *schedule = [data valueForKey:@"schedule"];
  //NSLog(@"%@ is schedule", schedule);
    for (FBMatch *match in array) {
    if ([match.schedule isEqualToString:schedule]) {
      [match updateMatch:match WithData:data];
    }
  }
}

- (void)createDateInfoForMatch {
  
  NSArray *seperatedSchedule = [self.schedule componentsSeparatedByString:@" "];
  self.date = seperatedSchedule[0];
  
  NSDateFormatter *formater = [[NSDateFormatter alloc]init];
  [formater setDateFormat:@"yyy/MM/dd"];
  self.nsdate = [formater dateFromString:self.date];
  
  NSString *time =  seperatedSchedule[1];
  NSArray *timeSeparated = [time componentsSeparatedByString:@":"];
  self.hour = timeSeparated[0];
  self.minute = timeSeparated[1];
}
@end