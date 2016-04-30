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

@property NSMutableArray *timeline;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *lineUpsView;
@property (weak, nonatomic) IBOutlet UIView *statsView;
@property (weak, nonatomic) IBOutlet UIView *eventsView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControll;

//team A
@property (weak, nonatomic) IBOutlet UIImageView *teamAFlag;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer1;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer2;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer3;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer4;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer5;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer6;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer7;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer8;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer9;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer10;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer11;

//teamB
@property (weak, nonatomic) IBOutlet UIImageView *teamBFlag;
@property (weak, nonatomic) IBOutlet UILabel *teamBPLayer1;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer2;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer3;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer4;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer5;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer6;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer7;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer8;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer9;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer10;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer11;




@end

@implementation GameVC
- (IBAction)segmentedValueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.lineUpsView.hidden = NO;
            self.statsView.hidden = YES;
            self.eventsView.hidden = YES;
            [self displayLineUps];
            NSLog(@"this is the segmentedindex lineUps 0 = %li" , (long)sender.selectedSegmentIndex);
            break;
        case 1:
            self.lineUpsView.hidden = YES;
            self.statsView.hidden = NO;
            self.eventsView.hidden = YES;
            NSLog(@"this is the segmentedindex  stats 1 =%li" , (long)sender.selectedSegmentIndex);
        case 2:
            self.lineUpsView.hidden = YES;
            self.statsView.hidden = YES;
            self.eventsView.hidden = NO;
            NSLog(@"this is the segmentedindex events  2 = %li" , (long)sender.selectedSegmentIndex);

        default:
            break;
    }
}


- (void)displayLineUps {
    
//    NSDictionary *dictionary =
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //this gets taken out after segue works ....code below
    self.match = [FBMatch new];
    
    if (self.match.matchID) {
        //listen to match
    } else {
        //update match  view with passed match data
    }
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
        //call update match
//       [self updateMatchLabels];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
        
        //call update match
        //firebase failed but the match exists because you clicked the cell from homeVC
        //[self upadte];
    }];
}


//- (void)updateMatchLabels {
//    NSString *titleText = [NSString stringWithFormat:@"%@ vs %@" , self.match.local_abbr, self.match.visitor];
//    self.title = titleText;
////    self.teamAPlayer1.text =
//    ///matchlineup array
//    NSLog(@"SHOW ME THE PLAYERS %@", self.match.visitor_Lineup);
//    
//    NSArray *lineUpLocalLabels = @[self.teamAPlayer1,self.teamAPlayer2,self.teamAPlayer3,self.teamAPlayer4,self.teamAPlayer5,self.teamAPlayer6,self.teamAPlayer7,self.teamAPlayer8,self.teamAPlayer9,self.teamAPlayer10,self.teamAPlayer11];
//    
////    for (NSString *playerA in self.match.local_Lineup) {
////        
////    }
//    
//    NSMutableArray *matchAPLayersNames = [NSMutableArray new];
//    
////    for (FBMatch *match in self.match.local_Lineup) {
////        [matchAPLayersNames addObject:[match valueForKey:[@"name"]];
////    }
////  
////    for (int i = 0; (lineUpLocalLabels.count && self.match.local_Lineup)  ; i++) {
////        
////        
////    }
////    NSLog(@"thi is tru or false %@" )
//    
////    
////    NSMutableArray *matchIds = [NSMutableArray new];
////    
////    for (Match *match in self.matchesObject) {
////        [matchIds addObject:match.matchId];
////    }
////    
////    

    
    



//-updatematchwithsmatch: self.match {
//
//this
///able.text = self.match.something
//if (![self.matchlineup isEqual:[NSNull null]] && selfcount > 0)
///11lables = @"-"
//esle {
//label = self.match.lineups
//}
//
//penalties
//
//}
//
//- (void)updateMatchesWithMatch {
////    self.title.text =
//    
//}
















@end











