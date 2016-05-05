//
//  FBMatch.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/25/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//
#import "FBMatch.h"
@implementation FBMatch


//+ (NSArray *)createTimeLineWithMatch: (FBMatch *)match {
//    
//    NSMutableArray *nonsortedArray = [NSMutableArray new];
//    
//    for (NSDictionary *goal in match.goals) {
//        [nonsortedArray addObject:goal];
//    }
//    
//    //kickoff
//    NSDictionary *kickOff = @{
//                              @"action" : @"kickoff",
//                              @"minute" : @"0"
//                              };
//    
//    [nonsortedArray addObject:kickOff];
//    
//    
//    //cards
//    for (NSDictionary *cards in match.cards) {
//        [nonsortedArray addObject:cards];
//    }
//    //substitutions
//    NSMutableArray *localChanges = [NSMutableArray new];
//    NSMutableArray *visitorChanges = [NSMutableArray new];
//    for (NSDictionary *change in match.changes) {
//        if ([[change valueForKey:@"team"] isEqualToString:@"local"]) {
//            [localChanges addObject:change];
//        } else {
//            [visitorChanges addObject:change];
//        }
//    }
//    //NSLog(@"local changes: %@ ", localChanges);
//    //NSLog(@"visitor changes: %@ ", visitorChanges);
//    
//    if (localChanges.count % 2 == 0 && localChanges.count > 1) {
//        match.arrayOfSubstitutionDictionaries = [NSMutableArray new];
//        NSMutableArray *arrayOfLocalSubstitutionDictionaries = [match returnSubstitutionsWithArrayOfChanges:localChanges];
//        //NSLog(@"local subs returned: %@", arrayOfLocalSubstitutionDictionaries);
//        for (NSDictionary *sub in arrayOfLocalSubstitutionDictionaries) {
//            [nonsortedArray addObject:sub];
//        }
//    }
//    
//    if (visitorChanges.count % 2 == 0 && visitorChanges.count > 1) {
//        match.arrayOfSubstitutionDictionaries = [NSMutableArray new];
//        NSMutableArray *arrayOfVisitorSubstitutionDictionaries = [match returnSubstitutionsWithArrayOfChanges:visitorChanges];
//        //NSLog(@"visitor subs returned: %@", arrayOfVisitorSubstitutionDictionaries);
//        for (NSDictionary *sub in arrayOfVisitorSubstitutionDictionaries) {
//            [nonsortedArray addObject:sub];
//        }
//    }
//  
//    for (NSDictionary *other in match.others) {
//      [nonsortedArray addObject:other];
//    }
//  
//    for (NSDictionary *occasion in match.occasions) {
//      [nonsortedArray addObject:occasion];
//    }
//  
//    NSSortDescriptor *minute= [[NSSortDescriptor alloc] initWithKey:@"minute" ascending:YES];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:minute];
//    NSMutableArray *returnArray = [NSMutableArray arrayWithArray:[nonsortedArray sortedArrayUsingDescriptors:sortDescriptors]];
//    //NSLog(@"RETURN THE CRAKEN!!!!! %@", returnArray);
//    return returnArray;
//    
//}

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
        NSMutableDictionary *event = [changes objectAtIndex:i];
        if (self.subIn == nil && [[event objectForKey:@"action"] isEqualToString:[NSMutableString stringWithFormat:@"Entra en el partido"]]) {
          NSInteger minute = [[event objectForKey:@"minute"] integerValue];
          NSNumber *num = [NSNumber numberWithInteger:minute];
          NSDictionary *minuteDict = @{@"minuteF":num};
          [event addEntriesFromDictionary:minuteDict];
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
  
  if (self.subIn != nil && self.subOut != nil) {
  
      NSString *substitutionstring = @"substitution";
    NSDictionary *substitution = @{@"playerIn": [self.subIn objectForKey:@"player"], @"playerOut": [self.subOut objectForKey:@"player"], @"minute": [self.subOut objectForKey:@"minute"], @"team": [self.subOut objectForKey:@"team"], @"action": substitutionstring, @"minuteF":[self.subIn objectForKey:@"minuteF"]};
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
  return nil;
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
    match.status = [NSString stringWithFormat:@"%@",[data valueForKey:@"status"]];
    //  NSLog(@"%@ is the match status", match.status);
    match.schedule = [data valueForKey:@"schedule"];
    //  NSLog(@"%@ is the scheduled time", match.schedule);
  
    [match createDateInfoForMatch];
  
  
    //NSLog(@"THIS IS THE Date -%@-", match.date);
//    NSString *time =  seperatedSchedule[1];
//    NSArray *timeSeparated = [time componentsSeparatedByString:@":"];
//    match.hour = timeSeparated[0];
//    match.minute = timeSeparated[1];
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
  
  //lineup data
  if ([[data valueForKey:@"isLineup"] isEqualToString:@"1"]) {
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
  }
  
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
        match.local_off = [localExtra objectForKey:@"off"];
        //NSLog(@"%@ is local soff", match.local_soff);
        match.local_frk = [localExtra objectForKey:@"frk"];
        //NSLog(@"%@ is local frk", smatch.local_frk);
        match.local_blk = [localExtra objectForKey:@"blk"];
        //NSLog(@"%@ is local blk", match.local_blk);
        match.local_yc = [localExtra objectForKey:@"yc"];
        //NSLog(@"%@ is local yc", match.local_yc);
        match.local_cor = [localExtra objectForKey:@"cor"];
        //NSLog(@"%@ is local yc", match.local_cor);
      
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
        match.visitor_off = [visitorExtra objectForKey:@"off"];
        //NSLog(@"%@ is visitor soff", match.visitor_soff);
        match.visitor_frk = [visitorExtra objectForKey:@"frk"];
        //NSLog(@"%@ is visitor frk", smatch.visitor_frk);
        match.visitor_blk = [visitorExtra objectForKey:@"blk"];
        //NSLog(@"%@ is visitor blk", match.visitor_blk);
        match.visitor_yc = [visitorExtra objectForKey:@"yc"];
        //NSLog(@"%@ is visitor yc", match.visitor_yc);
        match.visitor_cor = [visitorExtra objectForKey:@"cor"];
        //NSLog(@"%@ is local yc", match.visitor_cor);
      
      
        
        //events
        NSDictionary *events = [data valueForKey:@"events"];
        //NSLog(@"Events : %@", events);
        
        //--cards
        NSArray *cards = [events valueForKey:@"cards"];
        //NSLog(@"Cards: %@", cards);
        match.cards = [NSMutableArray new];
        for (NSMutableDictionary *card in cards) {
          
          NSInteger minute = [[card objectForKey:@"minute"] integerValue];
          NSNumber *num = [NSNumber numberWithInteger:minute];
          NSDictionary *minuteDict = @{@"minuteF":num};
          [card addEntriesFromDictionary:minuteDict];
          [match.cards addObject:card];
          
        }
        
        //--Substitutions
        NSArray *changes = [events valueForKey:@"changes"];
        //NSLog(@"Changes!!!!!: %@",changes);
        match.changes = [NSMutableArray new];
        for (NSMutableDictionary *change in changes) {
            ;
          NSInteger minute = [[change objectForKey:@"minute"] integerValue];
          NSNumber *num = [NSNumber numberWithInteger:minute];
          NSDictionary *minuteDict = @{@"minuteF":num};
          [change addEntriesFromDictionary:minuteDict];
          [match.changes addObject:change];
        }
        // NSLog(@"match.changes == %@", match.changes);
        
        //--Goals
        NSArray *goals = [events valueForKey:@"goals"];
        //NSLog(@"Goals: %@",goals);
        match.goals = [NSMutableArray new];
        for (NSMutableDictionary *goal in goals) {
          NSInteger minute = [[goal objectForKey:@"minute"] integerValue];
          NSNumber *num = [NSNumber numberWithInteger:minute];
          NSDictionary *minuteDict = @{@"minuteF":num};
          [goal addEntriesFromDictionary:minuteDict];
          [match.goals addObject:goal];
        }
      
      //occasions
      NSArray *occasions = [events valueForKey:@"occasions"];
      match.occasions = [NSMutableArray new];
      
      for (NSMutableDictionary *occasion in occasions) {
        if (![[occasion valueForKey:@"action"] isEqualToString:@"Penalti parado"] && ![[occasion valueForKey:@"action"] isEqualToString:@"Asistencia"] && ![[occasion valueForKey:@"action"] isEqualToString:@"Tiro al palo"]) {
          
          NSInteger minute = [[occasion objectForKey:@"minute"] integerValue];
          NSNumber *num = [NSNumber numberWithInteger:minute];
          NSDictionary *minuteDict = @{@"minuteF":num};
          [occasion addEntriesFromDictionary:minuteDict];
          [match.occasions addObject:occasion];
        }
      }
      
      //others
      NSArray *others = [events valueForKey:@"others"];
      match.others = [NSMutableArray new];
      for (NSMutableDictionary *other in others) {
        if (![[other valueForKey:@"action"] isEqualToString:@"Penalti parado"] && ![[other valueForKey:@"action"] isEqualToString:@"Asistencia"] && ![[other valueForKey:@"action"] isEqualToString:@"Tiro al palo"]) {
          
          NSInteger minute = [[other objectForKey:@"minute"] integerValue];
          NSNumber *num = [NSNumber numberWithInteger:minute];
          NSDictionary *minuteDict = @{@"minuteF":num};
          [other addEntriesFromDictionary:minuteDict];
          [match.others addObject:other];
        }
      }
      
        
        //timeline

    NSArray *timeLine = [FBMatch createTimeLineWithMatch: match];
            if (timeLine.count > 0) {
                match.timeline = [NSMutableArray arrayWithArray:[NSArray arrayWithArray:timeLine]];
            }

    }//if there is extra data closing bracket
}

+ (NSArray *)createTimeLineWithMatch: (FBMatch *)match {
  
  NSMutableArray *nonsortedArray = [NSMutableArray new];
    
  
  NSDictionary *kickOff = @{
                                                          @"action" : @"kickoff",
                                                          @"minute" : @"0",
                                                          @"minuteF": @0
                                  };
                                
                                [nonsortedArray addObject:kickOff];
                            
  
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
  
  if (localChanges.count % 2 == 0 && localChanges.count > 1) {
    match.arrayOfSubstitutionDictionaries = [NSMutableArray new];
    NSMutableArray *arrayOfLocalSubstitutionDictionaries = [match returnSubstitutionsWithArrayOfChanges:localChanges];
    //NSLog(@"local subs returned: %@", arrayOfLocalSubstitutionDictionaries);
    for (NSDictionary *sub in arrayOfLocalSubstitutionDictionaries) {
      [nonsortedArray addObject:sub];
    }
  }
  
  if (visitorChanges.count % 2 == 0 && visitorChanges.count > 1) {
    match.arrayOfSubstitutionDictionaries = [NSMutableArray new];
    NSMutableArray *arrayOfVisitorSubstitutionDictionaries = [match returnSubstitutionsWithArrayOfChanges:visitorChanges];
    //NSLog(@"visitor subs returned: %@", arrayOfVisitorSubstitutionDictionaries);
    for (NSDictionary *sub in arrayOfVisitorSubstitutionDictionaries) {
      [nonsortedArray addObject:sub];
    }
  }
  
  for (NSDictionary *other in match.others) {
    [nonsortedArray addObject:other];
  }
  
  for (NSDictionary *occasion in match.occasions) {
    [nonsortedArray addObject:occasion];
  }
  
  NSSortDescriptor *minute= [[NSSortDescriptor alloc] initWithKey:@"minuteF" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObject:minute];
  NSMutableArray *returnArray = [NSMutableArray arrayWithArray:[nonsortedArray sortedArrayUsingDescriptors:sortDescriptors]];
  NSLog(@"RETURN THE CRAKEN!!!!! %@", returnArray);
  return returnArray;
  
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
  
 
  NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
  formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
  formatter.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Madrid"];
  self.nsdate = [formatter dateFromString:self.schedule];
  
  
  NSDateFormatter *eastern = [[NSDateFormatter alloc]init];
  eastern.dateFormat = @"yyyy-MM-dd HH:mm:ss";
  eastern.timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
  
  
  NSString *easternTime =  [eastern stringFromDate:self.nsdate];
  NSArray *scheduleSeparated = [easternTime componentsSeparatedByString:@" "];
  self.date = scheduleSeparated[0];
  NSString *time = scheduleSeparated[1];
  NSArray *timeSeparated = [time componentsSeparatedByString:@":"];
  self.hour = timeSeparated[0];
  self.minute = timeSeparated[1];
}


@end