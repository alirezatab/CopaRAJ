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
@property NSDate *date;
@property (weak, nonatomic) IBOutlet UITextView *countDownTextView;

@end

@implementation GameVC



- (void)viewDidLoad {
    [super viewDidLoad];
    self.match.timeline = [NSMutableArray new];

    self.tableView.allowsSelection = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    if (self.match.matchID) {
        [self listenToMatch];
        [self eventsTableViewAppears];

    } else {
        [self displayLineUpLabels];
        [self displayMatchLabels];
        [self displayStatsLabels];
    }

    
    //setting the countdown
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.date = [dateFormat dateFromString:self.match.date];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    
    NSLog(@"HELLO STATUS =  %@   %lu", self.match.status , (unsigned long)self.match.timeline.count);
    
}

- (void)eventsTableViewAppears {
  
    int matchStatus = [self.match.status  intValue];
    if(matchStatus == -1){
        self.tableView.hidden = YES;
    }
}


- (void)updateCounter:(NSTimer *)tmr
{
    NSTimeInterval iv = [self.date  timeIntervalSinceNow];
    
    int days = iv / (60 * 60 * 24);
    iv -= days * (60 * 60 * 24);
    int hours = iv / (60 * 60);
    iv -= hours * (60 * 60);
    int minutes = iv / 60;
    iv -= minutes *60;
    int seconds = iv;
    
    NSString *countdown = [NSString stringWithFormat:@"%02d Days \n%02d Hours \n%02d Minutes \n%02d Seconds \n until Game!!", days, hours, minutes, seconds];
    
    self.countDownTextView.text = countdown;
    
    [self.countDownTextView setFont:[UIFont fontWithName:@"GOTHAM Narrow" size:22]];
    [self.countDownTextView setTextColor:[UIColor whiteColor]];
    [self.countDownTextView setTextAlignment:NSTextAlignmentCenter];
    
    if (days + hours + minutes + seconds <= 0) {
        [tmr invalidate];
    }
}


- (void)listenToMatch {
    
    NSString *url = [NSString stringWithFormat:@"https://fiery-inferno-5799.firebaseio.com/matches/%@",self.match.matchID];
                     //self.match.matchID];377                     //self.match.matchID];
    Firebase *ref = [[Firebase alloc]initWithUrl:url];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSDictionary *matchDetails = snapshot.value;
        [self.match updateMatch:self.match WithData:matchDetails];
        
        [self displayLineUpLabels];
        [self displayMatchLabels];
        [self displayStatsLabels];
        
        NSLog(@"timeline STARTS HERE from the method  %@ , %lu",self.match.timeline , (unsigned long)self.match.timeline.count );

        [self.tableView reloadData];
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
        
    }];
}

- (void)displayMatchLabels {
    NSString *titleText = [NSString stringWithFormat:@"%@ vs %@" , self.match.local_abbr, self.match.visitor_abbr];
    self.title = titleText;
  
  if ([self.match.status isEqualToString: @"-1"]) {
      
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      dateFormatter.dateFormat = @"HH:mm";
      NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@:%@", self.match.hour, self.match.minute]];
      dateFormatter.dateFormat = @"hh:mm a";
      NSString *dateString = [dateFormatter stringFromDate:date];
      
    self.timeLabel.text = [NSString stringWithFormat:@"%@ ET" ,dateString];
    self.teamOneScore.text = @"";
    self.teamTwoScore.text = @"";
  } else if ([self.match.status isEqualToString:@"0"]){
    self.timeLabel.text = [NSString stringWithFormat:@"%@'", self.match.live_minute];
    self.teamOneScore.text = self.match.local_goals;
    self.teamTwoScore.text = self.match.visitor_goals;
  } else if ([self.match.status isEqualToString:@"1"])  {
    self.timeLabel.text = @"Final";
    self.teamOneScore.text = self.match.local_goals;
    self.teamTwoScore.text = self.match.visitor_goals;

  }
    self.teamOneImage.image = [UIImage imageNamed:self.match.local];
    self.teamOneName.text = self.match.local_abbr;
    self.teamTwoImage.image = [UIImage imageNamed:self.match.visitor];
    self.teamTwoName.text = self.match.visitor_abbr;
    self.matchDateLabel.text = self.match.date;
    NSArray *labels = @[self.timeLabel , self.teamOneName ,self.teamTwoName, self.matchDateLabel , self.versusLabel , self.locationLabel];
    for (UILabel *label in labels){
        [label setFont:[UIFont fontWithName:@"GOTHAM MEDIUM" size:16]];
        [label setTextColor:[UIColor whiteColor]];
    }
    [self.teamOneScore setFont:[UIFont fontWithName:@"GOTHAM MEDIUM" size:30]];
    [self.teamOneScore setTextColor: [UIColor whiteColor]];
    [self.teamTwoScore setFont:[UIFont fontWithName:@"GOTHAM MEDIUM" size:30]];
    [self.teamTwoScore setTextColor:[UIColor whiteColor]];
}

- (void)displayLineUpLabels {
    
    //TEAM A
    
    int i = 0;
    NSArray *lineUpLocalLabels = @[self.teamAPlayer1,self.teamAPlayer2,self.teamAPlayer3,self.teamAPlayer4,self.teamAPlayer5,self.teamAPlayer6,self.teamAPlayer7,self.teamAPlayer8,self.teamAPlayer9,self.teamAPlayer10,self.teamAPlayer11];
    
    self.lineUpLocalFlag.image =[UIImage imageNamed:self.match.local];
    
    if (self.match.local_Lineup) {
        for (FBMatch *player in self.match.local_Lineup) {
            NSString *nick = [player valueForKey:@"nick"];
            UILabel *label = [lineUpLocalLabels objectAtIndex:i];
            label.text = nick;
            [label setFont:[UIFont fontWithName:@"Gotham Narrow" size:15]];
            [label setTextColor:[UIColor whiteColor]];
            i++;
        }
    } else{
        for (UILabel *label  in lineUpLocalLabels) {
            [label setFont:[UIFont fontWithName:@"Gotham Narrow" size:15]];
            [label setTextColor:[UIColor whiteColor]];
        }
    }
    
    //TEAM B
    int x = 0;
    
    NSArray *lineUpVisitLabels = @[self.teamBPLayer1,self.teamBPlayer2,self.teamBPlayer3,self.teamBPlayer4,self.teamBPlayer5,self.teamBPlayer6,self.teamBPlayer7,self.teamBPlayer8,self.teamBPlayer9,self.teamBPlayer10,self.teamBPlayer11];
    
    self.lineUpVisitorFlag.image = [UIImage imageNamed:self.match.visitor];
    
    if (self.match.visitor_Lineup) {
        for (FBMatch *match in self.match.visitor_Lineup) {
            NSString *nick = [match valueForKey:@"nick"];
            UILabel *label = [lineUpVisitLabels objectAtIndex:x];
            label.text = nick;
            [label setFont:[UIFont fontWithName:@"Gotham Narrow" size:15]];
            [label setTextColor:[UIColor whiteColor]];
            x++;
        }
    } else{
        for (UILabel *label  in lineUpVisitLabels) {
            [label setFont:[UIFont fontWithName:@"Gotham Narrow" size:15]];
            [label setTextColor:[UIColor whiteColor]];
        }
    }
    NSLog(@"%@ vs %@" , self.match.local , self.match.visitor);
    
}

- (void) displayStatsLabels {
    
    //local Team A stats
    self.teamAStatsFlag.image = [UIImage imageNamed:self.match.local];
    if(self.match.local_pos != NULL){
    self.local_posLabel.text = [NSString stringWithFormat:@"%@ %%" , self.match.local_pos];
    }
    self.local_sotLabel.text = self.match.local_sot;
    self.local_sonLabel.text = self.match.local_son;
    if (self.match.local_off != NULL){
        self.local_soffLabel.text = [NSString stringWithFormat:@"%@" , self.match.local_off];
    }
    self.local_frkLabel.text = self.match.local_frk;
    self.local_blkLabel.text = self.match.local_blk;
    self.local_ycLabel.text = self.match.local_yc;
    self.local_cor.text = self.match.local_cor;
    if (self.match.local_rc != NULL){
        self.local_rcLabel.text = [NSString stringWithFormat:@"%@", self.match.local_rc];
    }
    
    //local team B stats
    self.teamBStatsFlag.image = [UIImage imageNamed:self.match.visitor];
    if(self.match.visitor_pos != NULL){
    self.visitor_posLabel.text = [NSString stringWithFormat: @"%@ %%",self.match.visitor_pos];
    }
    self.visitor_sotLabel.text = self.match.visitor_sot;
    self.visitor_sonLabel.text = self.match.visitor_son;
    if (self.match.visitor_off != NULL){
        self.visitor_soffLabel.text =[NSString stringWithFormat:@"%@" , self.match.visitor_off];
    }
    self.visitor_frkLabel.text = self.match.visitor_frk;
    self.visitor_blkSaves.text = self.match.visitor_blk;
    self.visitor_ycLabel.text = self.match.visitor_yc;
    self.visitor_cor.text = self.match.visitor_cor;
    if (self.match.visitor_rc != NULL){
        self.visitor_rcLabel.text = [NSString stringWithFormat:@"%@", self.match.visitor_rc];
    }
    
    //adding font color and size to the stats labels
    NSArray *labels = @[self.local_posLabel , self.local_sotLabel , self.local_sonLabel , self.local_soffLabel , self.local_frkLabel , self.local_blkLabel , self.local_ycLabel , self.local_rcLabel , self.visitor_posLabel , self.visitor_sotLabel , self.visitor_sonLabel , self.visitor_soffLabel , self.local_frkLabel , self.visitor_frkLabel , self.visitor_blkSaves , self.visitor_ycLabel , self.visitor_rcLabel , self.posessionLabel , self.shotsLabel, self.shotsTargetLabel , self.offSideLabel , self.freeKickLabel , self.savesLabel ,self.yellowCardLabel ,self.redCardLabel , self.cornerKick , self.local_cor , self.visitor_cor];
    
    for (UILabel *label in labels){
        [label setFont:[UIFont fontWithName:@"Gotham Narrow" size:15]];
        [label setTextColor:[UIColor whiteColor]];
    }
}

//display timeline labels
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSArray *reversedArray = [[self.match.timeline reverseObjectEnumerator] allObjects];
    
    NSDictionary *event = [reversedArray objectAtIndex:indexPath.row];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@'",[event valueForKey:@"minute"]];

    if ([[event valueForKey:@"team"] isEqualToString: @"local"]) {
        cell.eventsTeamFlag.image = [UIImage imageNamed: self.match.local];
    } else if ([[event valueForKey:@"team"] isEqualToString: @"visitor"]) {
        cell.eventsTeamFlag.image = [UIImage imageNamed: self.match.visitor];
    } else{
        cell.eventsTeamFlag.image = [UIImage imageNamed:@""];
    }
    
    BOOL isPLayer = [event objectForKey:@"player"];
    
    if(isPLayer){
        cell.playerLabel.text = [event valueForKey:@"player"];
    } else {
        cell.playerLabel.text = @"replaced by";
    }
    
    cell.backgroundColor = [UIColor colorWithRed:0.063 green:0.188 blue:0.231 alpha:0.9];
    
    cell.actionImage.image = [UIImage imageNamed:[event valueForKey:@"action"]];
    cell.inLabel.text = [event valueForKey:@"playerOut"];
    cell.outLabel.text = [event valueForKey:@"playerIn"];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.111 alpha:0.000]
    ;
    [cell.contentView addSubview:lineView];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)self.match.timeline.count);
    return self.match.timeline.count;
}

- (IBAction)segmentedValueChanged:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        self.lineUpsView.hidden = YES;
        self.statsView.hidden = YES;
        self.eventsView.hidden = NO;
    } else if(sender.selectedSegmentIndex == 1) {
        self.lineUpsView.hidden = YES;
        self.statsView.hidden = NO;
        self.eventsView.hidden = YES;
    } else if(sender.selectedSegmentIndex == 2) {
        self.lineUpsView.hidden = NO;
        self.statsView.hidden = YES;
        self.eventsView.hidden = YES;
    }
}





 

    














@end











