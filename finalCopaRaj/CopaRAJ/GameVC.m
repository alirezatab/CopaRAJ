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
    
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!later add if self.matchID. else.. use data passed to us via segue
    [self listenToMatch];
    
    //else {
    //use passed match data
}

- (void)listenToMatch {
    
    //NSString *matchID = [NSString stringWithFormat:@"%@", self.matchID];
    //if matchID
    NSString *thisWillBeThePassedMatchID = @"377717";
    NSString *url = [NSString stringWithFormat:@"https://fiery-inferno-5799.firebaseio.com/matches/%@", thisWillBeThePassedMatchID];
    Firebase *ref = [[Firebase alloc]initWithUrl:url];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSDictionary *matchDetails = snapshot.value;
        [self.match updateMatch:self.match WithData:matchDetails];
        //match exists from Firebase and is updated. update the view accordingly
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
        
        //firebase failed but the match exists because you clicked the cell from homeVC
    }];
}


@end