//
//  GameVC.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "GameVC.h"
#import <Firebase/Firebase.h>

@interface GameVC ()

@end

@implementation GameVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self listenToMatch];
}

- (void)listenToMatch {
  
  //NSString *matchID = [NSString stringWithFormat:@"%@", self.matchID];
  NSString *thisWillBeThePassedMatchID = @"347342";
  NSString *url = [NSString stringWithFormat:@"https://fiery-inferno-5799.firebaseio.com/matches/%@", thisWillBeThePassedMatchID];
  Firebase *ref = [[Firebase alloc]initWithUrl:url];
  [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
    NSLog(@"%@", snapshot.value);
  } withCancelBlock:^(NSError *error) {
    NSLog(@"%@", error.description);
  }];

}

@end
