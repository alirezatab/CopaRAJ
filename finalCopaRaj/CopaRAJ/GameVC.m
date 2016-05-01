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
#import "EventCell.h"


@interface GameVC ()<UITableViewDelegate,UITableViewDataSource>

@property NSMutableArray *timeline;
@property (weak, nonatomic) IBOutlet UIView *lineUpsView;
@property (weak, nonatomic) IBOutlet UIView *statsView;
@property (weak, nonatomic) IBOutlet UIView *eventsView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControll;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *lineUpLocalFlag;
@property (weak, nonatomic) IBOutlet UIImageView *lineUpVisitorFlag;

@end

@implementation GameVC

- (IBAction)segmentedValueChanged:(UISegmentedControl *)sender {

    if (sender.selectedSegmentIndex == 0) {
        self.lineUpsView.hidden = NO;
        self.statsView.hidden = YES;
        self.eventsView.hidden = YES;
    } else if(sender.selectedSegmentIndex == 1) {
        self.lineUpsView.hidden = YES;
        self.statsView.hidden = NO;
        self.eventsView.hidden = YES;
    } else if(sender.selectedSegmentIndex == 2) {
        self.lineUpsView.hidden = YES;
        self.statsView.hidden = YES;
        self.eventsView.hidden = NO;
   }
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
//    NSLog(@"match %@", self.match);
    self.match.timeline = [NSMutableArray new];
    self.tableView.allowsSelection = NO;
   
    
}

- (void)listenToMatch {
    
    //NSString *matchID = [NSString stringWithFormat:@"%@", self.matchID];
    //if matchID
    NSString *thisWillBeThePassedMatchID = @"37483";
    NSString *url = [NSString stringWithFormat:@"https://fiery-inferno-5799.firebaseio.com/matches/%@", thisWillBeThePassedMatchID];
    Firebase *ref = [[Firebase alloc]initWithUrl:url];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSDictionary *matchDetails = snapshot.value;
        [self.match updateMatch:self.match WithData:matchDetails];
        
        //match exists from Firebase and is updated. update the view accordingly
        //call update match
        [self displayLineUpLabels];
        [self displayMatchLabels];
        [self displayStatsLabels];
        
        NSLog(@"timeline STARTS HERE from the method  %@ , %lu",self.match.timeline , (unsigned long)self.match.timeline.count );

        [self.tableView reloadData];
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
        
        //call update match
        //firebase failed but the match exists because you clicked the cell from homeVC
        //[self upadte];
    }];
}

- (void)displayMatchLabels {
    NSString *titleText = [NSString stringWithFormat:@"%@ vs %@" , self.match.local_abbr, self.match.visitor_abbr];
    self.title = titleText;
  
  if ([self.match.status isEqualToString: @"-1"]) {
    self.timeLabel.text = [NSString stringWithFormat:@"%@ : %@", self.match.hour , self.match.minute];
    self.teamOneScore.text = @"";
    self.teamTwoScore.text = @"";
  } else if ([self.match.status isEqualToString:@"0"]){
    self.timeLabel.text = self.match.live_minute;
    self.teamOneScore.text = self.match.local_goals;
    self.teamTwoScore.text = self.match.visitor_goals;
  } else if ([self.match.status isEqualToString:@"1"])  {
    self.timeLabel.text = @"Game Over";
    self.teamOneScore.text = self.match.local_goals;
    self.teamTwoScore.text = self.match.visitor_goals;

  }
    self.teamOneImage.image = [UIImage imageNamed:self.match.local];
    self.teamOneName.text = self.match.local;
    self.teamTwoImage.image = [UIImage imageNamed:self.match.visitor];
    self.teamTwoName.text = self.match.visitor;
    self.matchDateLabel.text = self.match.date;
    NSArray *labels = @[self.timeLabel , self.teamOneName , self.teamOneScore , self.teamTwoName ,self.teamTwoScore , self.matchDateLabel];
    for (UILabel *label in labels){
        [label setFont:[UIFont fontWithName:@"GOTHAM MEDIUM" size:16]];
        [label setTextColor:[UIColor colorWithWhite:0.600 alpha:1.000]];

    }
}

- (void)displayLineUpLabels {

    
    int i = 0;
    //TEAM A
    NSArray *lineUpLocalLabels = @[self.teamAPlayer1,self.teamAPlayer2,self.teamAPlayer3,self.teamAPlayer4,self.teamAPlayer5,self.teamAPlayer6,self.teamAPlayer7,self.teamAPlayer8,self.teamAPlayer9,self.teamAPlayer10,self.teamAPlayer11];
  
    
    for (FBMatch *player in self.match.local_Lineup) {
        NSString *nick = [player valueForKey:@"nick"];
        UILabel *label = [lineUpLocalLabels objectAtIndex:i];
        label.text = nick;
        [label setFont:[UIFont fontWithName:@"GOTHAM MEDIUM" size:15]];
        [label setTextColor:[UIColor colorWithWhite:0.600 alpha:1.000]];
        i++;
    }
    self.lineUpLocalFlag.image = [UIImage imageNamed:self.match.local];
    
    int x = 0;
    //TEAM B
    NSArray *lineUpVisitLabels = @[self.teamBPLayer1,self.teamBPlayer2,self.teamBPlayer3,self.teamBPlayer4,self.teamBPlayer5,self.teamBPlayer6,self.teamBPlayer7,self.teamBPlayer8,self.teamBPlayer9,self.teamBPlayer10,self.teamBPlayer11];
    
    for (FBMatch *match in self.match.visitor_Lineup) {
        NSString *nick = [match valueForKey:@"nick"];
        UILabel *label = [lineUpVisitLabels objectAtIndex:x];
        label.text = nick;
        [label setFont:[UIFont fontWithName:@"GOTHAM MEDIUM" size:15]];
        [label setTextColor:[UIColor colorWithWhite:0.600 alpha:1.000]];
        x++;
    }
    self.lineUpVisitorFlag.image = [UIImage imageNamed:self.match.visitor];
    
    NSLog(@"%@ vs %@" , self.match.local , self.match.visitor);

}

- (void) displayStatsLabels {
    
        //local Team A stats
    self.teamAStatsFlag.image = [UIImage imageNamed:self.match.local];
    self.local_posLabel.text = self.match.local_pos;
    self.local_sotLabel.text = self.match.local_sot;
    self.local_sonLabel.text = self.match.local_son;
    self.local_soffLabel.text = [NSString stringWithFormat:@"%@" , self.match.local_off];
    self.local_frkLabel.text = self.match.local_frk;
    self.local_blkLabel.text = self.match.local_blk;
    self.local_ycLabel.text = self.match.local_yc;
    self.local_rcLabel.text = [NSString stringWithFormat:@"%@" , self.match.local_rc];
    
    //local team B stats
    self.teamBStatsFlag.image = [UIImage imageNamed:self.match.visitor];
    self.visitor_posLabel.text = self.match.visitor_pos;
    self.visitor_sotLabel.text = self.match.visitor_sot;
    self.visitor_sonLabel.text = self.match.visitor_son;
    self.visitor_soffLabel.text =[NSString stringWithFormat:@"%@" , self.match.visitor_off];
    self.visitor_frkLabel.text = self.match.visitor_frk;
    self.visitor_blkSaves.text = self.match.visitor_blk;
    self.visitor_ycLabel.text = self.match.visitor_yc;
    self.visitor_rcLabel.text = [NSString stringWithFormat:@"%@", self.match.visitor_rc];
    
    //adding font color and size to the stats labels
    NSArray *labels = @[self.local_posLabel , self.local_sotLabel , self.local_sonLabel , self.local_soffLabel , self.local_frkLabel , self.local_blkLabel , self.local_ycLabel , self.local_rcLabel , self.visitor_posLabel , self.visitor_sotLabel , self.visitor_sonLabel , self.visitor_soffLabel , self.local_frkLabel , self.visitor_frkLabel , self.visitor_blkSaves , self.visitor_ycLabel , self.visitor_rcLabel , self.posessionLabel , self.shotsLabel, self.shotsTargetLabel , self.offSideLabel , self.freeKickLabel , self.savesLabel ,self.yellowCardLabel ,self.redCardLabel];
    
    for (UILabel *label in labels){
        [label setFont:[UIFont fontWithName:@"GOTHAM MEDIUM" size:16]];
        [label setTextColor:[UIColor colorWithWhite:0.600 alpha:1.000]];
    }
}

//display timeline labels
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *event = [self.match.timeline objectAtIndex:indexPath.row];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@'",[event valueForKey:@"minute"]];
    cell.playerLabel.text = [event valueForKey:@"player"];
    cell.actionImage.image = [UIImage imageNamed:[event valueForKey:@"action"]];
    cell.outLabel.text = [event valueForKey:@"playerOut"];
    cell.inLabel.text = [event valueForKey:@"playerIn"];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)self.match.timeline.count);
    return self.match.timeline.count;
}



 

    














@end











