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
  NSLog(@"local changes: %@ ", localChanges);
  NSLog(@"visitor changes: %@ ", visitorChanges);
  
  if (localChanges.count % 2 == 0) {
    match.arrayOfSubstitutionDictionaries = [NSMutableArray new];
    NSMutableArray *arrayOfLocalSubstitutionDictionaries = [match returnSubstitutionsWithArrayOfChanges:localChanges];
    NSLog(@"local subs returned: %@", arrayOfLocalSubstitutionDictionaries);
      for (NSDictionary *sub in arrayOfLocalSubstitutionDictionaries) {
        [nonsortedArray addObject:sub];
      }
  }
  
  if (visitorChanges.count % 2 == 0) {
    match.arrayOfSubstitutionDictionaries = [NSMutableArray new];
     NSMutableArray *arrayOfVisitorSubstitutionDictionaries = [match returnSubstitutionsWithArrayOfChanges:visitorChanges];
    NSLog(@"visitor subs returned: %@", arrayOfVisitorSubstitutionDictionaries);
      for (NSDictionary *sub in arrayOfVisitorSubstitutionDictionaries) {
        [nonsortedArray addObject:sub];
      }
  }
  NSSortDescriptor *minute= [[NSSortDescriptor alloc] initWithKey:@"minute" ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObject:minute];
  NSMutableArray *returnArray = [NSMutableArray arrayWithArray:[nonsortedArray sortedArrayUsingDescriptors:sortDescriptors]];
  NSLog(@"RETURN THE CRAKEN!!!!! %@", returnArray);
  return returnArray;
  
}

+ (NSMutableArray *)returnLineupArrayUsingLineupData:(NSArray *)array {
  NSMutableArray *returnedArray = [NSMutableArray new];
  
  for (NSDictionary *player in array) {
    [returnedArray addObject:player];
    NSLog(@"%@", player);
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
  NSLog(@"%@ subin", self.subIn);
  NSLog(@"%@ subout", self.subOut);

  NSLog(@"changes.count before removal: %lu",(unsigned long)changes.count);
  [changes removeObject:self.subIn];
  [changes removeObject:self.subOut];
  NSLog(@"changes.count after removal: %lu",(unsigned long)changes.count);
  
  if (changes.count > 0) {
    NSLog(@"array for return : %@", self.arrayOfSubstitutionDictionaries);
    [self returnSubstitutionsWithArrayOfChanges:changes];
  }
  
  return self.arrayOfSubstitutionDictionaries;
}

@end
