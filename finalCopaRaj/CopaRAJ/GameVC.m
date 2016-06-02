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
#import <EventKit/EventKit.h>

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
@property (weak, nonatomic) IBOutlet UILabel *penaltyLabel;
@property NSString *eventSavedId;
@property BOOL eventExists;


@end

@implementation GameVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self localizeStrings];
    self.match.timeline = [NSMutableArray new];

    self.tableView.allowsSelection = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.locationLabel.text = self.match.stadium;

    [self eventsTableViewAppears];

    if (self.match.matchID) {
       [self listenToMatch];
    } else {
        [self displayLineUpLabels];
        [self displayMatchLabels];
        [self displayStatsLabels];
    }

    //setting the countdown
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.date = self.match.nsdate;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
    [[self.eventsCalendarButton layer] setBorderWidth:2.0f];
    [[self.eventsCalendarButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.eventsCalendarButton.titleLabel.font = [UIFont fontWithName:@"Gotham Narrow" size:17];
}

- (void)localizeStrings {
    //segmented control section titles
    NSString *evento = [NSString stringWithFormat:NSLocalizedString(@"EVENTS", nil)];
    [self.segmentedControll setTitle:evento forSegmentAtIndex:0];
    NSString *estadisticas = [NSString stringWithFormat:NSLocalizedString(@"STATS", nil)];
    [self.segmentedControll setTitle:estadisticas forSegmentAtIndex:1];
    NSString *alineacion = [NSString stringWithFormat:NSLocalizedString(@"LINEUPS", nil)];
    [self.segmentedControll setTitle:alineacion forSegmentAtIndex:2];
    //stats labels
    [self.posessionLabel setText:[NSString stringWithFormat:NSLocalizedString(@"possession", nil)]];
    [self.shotsLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Shots", nil)]];
    [self.shotsTargetLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Shots on target", nil)]];
    [self.offSideLabel setText:[NSString stringWithFormat:NSLocalizedString(@"offsides", nil)]];
    [self.freeKickLabel setText:[NSString stringWithFormat:NSLocalizedString(@"free kicks", nil)]];
    [self.savesLabel setText:[NSString stringWithFormat:NSLocalizedString(@"saves", nil)]];
    [self.yellowCardLabel setText:[NSString stringWithFormat:NSLocalizedString(@"yellow cards", nil)]];
    [self.redCardLabel setText:[NSString stringWithFormat:NSLocalizedString(@"red cards", nil)]];
    [self.cornerKick setText:[NSString stringWithFormat:NSLocalizedString(@"Corner kicks", nil)]];
    //lineup labels team A 
    [self.teamAPlayer1 setText:[NSString stringWithFormat:NSLocalizedString(@"player 1", nil)]];
    [self.teamAPlayer2 setText:[NSString stringWithFormat:NSLocalizedString(@"player 2", nil)]];
    [self.teamAPlayer3 setText:[NSString stringWithFormat:NSLocalizedString(@"player 3", nil)]];
    [self.teamAPlayer4 setText:[NSString stringWithFormat:NSLocalizedString(@"player 4", nil)]];
    [self.teamAPlayer5 setText:[NSString stringWithFormat:NSLocalizedString(@"player 5", nil)]];
    [self.teamAPlayer6 setText:[NSString stringWithFormat:NSLocalizedString(@"player 6", nil)]];
    [self.teamAPlayer7 setText:[NSString stringWithFormat:NSLocalizedString(@"player 7", nil)]];
    [self.teamAPlayer8 setText:[NSString stringWithFormat:NSLocalizedString(@"player 8", nil)]];
    [self.teamAPlayer9 setText:[NSString stringWithFormat:NSLocalizedString(@"player 9", nil)]];
    [self.teamAPlayer10 setText:[NSString stringWithFormat:NSLocalizedString(@"player 10", nil)]];
    [self.teamAPlayer11 setText:[NSString stringWithFormat:NSLocalizedString(@"player 11", nil)]];
    //TEAM b
    [self.teamBPLayer1 setText:[NSString stringWithFormat:NSLocalizedString(@"player 1", nil)]];
    [self.teamBPlayer2 setText:[NSString stringWithFormat:NSLocalizedString(@"player 2", nil)]];
    [self.teamBPlayer3 setText:[NSString stringWithFormat:NSLocalizedString(@"player 3", nil)]];
    [self.teamBPlayer4 setText:[NSString stringWithFormat:NSLocalizedString(@"player 4", nil)]];
    [self.teamBPlayer5 setText:[NSString stringWithFormat:NSLocalizedString(@"player 5", nil)]];
    [self.teamBPlayer6 setText:[NSString stringWithFormat:NSLocalizedString(@"player 6", nil)]];
    [self.teamBPlayer7 setText:[NSString stringWithFormat:NSLocalizedString(@"player 7", nil)]];
    [self.teamBPlayer8 setText:[NSString stringWithFormat:NSLocalizedString(@"player 8", nil)]];
    [self.teamBPlayer9 setText:[NSString stringWithFormat:NSLocalizedString(@"player 9", nil)]];
    [self.teamBPlayer10 setText:[NSString stringWithFormat:NSLocalizedString(@"player 10", nil)]];
    [self.teamBPlayer11 setText:[NSString stringWithFormat:NSLocalizedString(@"player 11", nil)]];
    //text button
     [self.eventsCalendarButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"Add match to calendar", nil)] forState:UIControlStateNormal];
}

- (void)eventsTableViewAppears {
    int matchStatus = [self.match.status  intValue];
    if(matchStatus == -1){
        self.tableView.hidden = YES;
    } else {
        self.tableView.hidden = NO;
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
    
    NSString *countdown = [NSString stringWithFormat:@"%02d d : %02d h : %02d m : %02d s\n", days, hours, minutes, seconds];
    NSString *countDownText =[NSString stringWithFormat:NSLocalizedString(@"until kickoff", nil)];
    self.countDownTextView.text = [NSString stringWithFormat:@"%@ %@", countdown ,countDownText];
    
    [self.countDownTextView setFont:[UIFont fontWithName:@"GOTHAM MEDIUM" size:23]];
    [self.countDownTextView setTextColor:[UIColor whiteColor]];
    [self.countDownTextView setTextAlignment:NSTextAlignmentCenter];
    
    if (days + hours + minutes + seconds <= 0) {
        [tmr invalidate];
    }
}

- (void)listenToMatch {
  
    NSString *url = [NSString stringWithFormat:@"https://fiery-inferno-5799.firebaseio.com/matches/374982"];
                     //%@" , self.match.matchID];

    Firebase *ref = [[Firebase alloc]initWithUrl:url];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSDictionary *matchDetails = snapshot.value;
        [self.match updateMatch:self.match WithData:matchDetails];
        
        [self displayLineUpLabels];
        [self displayMatchLabels];
        [self displayStatsLabels];

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
  } //MARK: Ali Added Status
    else if ([self.match.status isEqualToString:@"5"]){
        if ([self.match.live_minute isEqualToString:@"45"]) {
            self.timeLabel.text = @"Half Time";
            self.teamOneScore.text = self.match.local_goals;
            self.teamTwoScore.text = self.match.visitor_goals;
        } else if ([self.match.live_minute isEqualToString:@"90"]){
            self.timeLabel.text = @"Extra Time";
            self.teamOneScore.text = self.match.local_goals;
            self.teamTwoScore.text = self.match.visitor_goals;
        } else if ([self.match.live_minute isEqualToString:@"120"]){
            self.timeLabel.text = @"Penalty Kicks";
            self.teamOneScore.text = self.match.local_goals;
            self.teamTwoScore.text = self.match.visitor_goals;
        }
    //MARK: Rickys original code
  } else if ([self.match.status isEqualToString:@"1"])  {
    self.timeLabel.text = @"Final";
    self.teamOneScore.text = self.match.local_goals;
    self.teamTwoScore.text = self.match.visitor_goals;
  }
    
    if ([self.match.pen1 isKindOfClass:[NSString class]] || [self.match.pen2 isKindOfClass:[NSString class]]) {
        self.penaltyLabel.text = [NSString stringWithFormat:@"(%@-%@)" , self.match.pen1 , self.match.pen2];
    } else {
        self.penaltyLabel.text = @"";
    }
    
    if ([self.match.local isEqualToString:@"Haití"]) {
        self.teamOneImage.image = [UIImage imageNamed:@"Haiti"];
    } else {
        self.teamOneImage.image = [UIImage imageNamed:self.match.local];
    }
    
    if ([self.match.visitor isEqualToString:@"Haití"]) {
        self.teamTwoImage.image = [UIImage imageNamed:@"Haiti"];
    } else {
        self.teamTwoImage.image = [UIImage imageNamed:self.match.visitor];
    }
    
    self.teamOneName.text = self.match.local_abbr;
    self.teamTwoName.text = self.match.visitor_abbr;
    
    //formating the date so we display the month first
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:self.match.date];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSString *strMyDate= [dateFormat stringFromDate:date];
    self.matchDateLabel.text = strMyDate;
    
    NSArray *labels = @[self.timeLabel , self.teamOneName ,self.teamTwoName, self.matchDateLabel , self.versusLabel , self.locationLabel];
    for (UILabel *label in labels){
        [label setFont:[UIFont fontWithName:@"GOTHAM MEDIUM" size:18]];
        [label setTextColor:[UIColor whiteColor]];
    }
    
    [self.teamOneScore setFont:[UIFont fontWithName:@"GOTHAM MEDIUM" size:30]];
    [self.teamOneScore setTextColor: [UIColor whiteColor]];
    [self.teamTwoScore setFont:[UIFont fontWithName:@"GOTHAM MEDIUM" size:30]];
    [self.teamTwoScore setTextColor:[UIColor whiteColor]];
    [self.penaltyLabel setTextColor:[UIColor whiteColor]];
    [self.penaltyLabel setFont:[UIFont fontWithName:@"Gotham MEDIUM" size:19]];
}

- (void)displayLineUpLabels {
    
    //TEAM A
    int i = 0;
    NSArray *lineUpLocalLabels = @[self.teamAPlayer1,self.teamAPlayer2,self.teamAPlayer3,self.teamAPlayer4,self.teamAPlayer5,self.teamAPlayer6,self.teamAPlayer7,self.teamAPlayer8,self.teamAPlayer9,self.teamAPlayer10,self.teamAPlayer11];
    
    if ([self.match.local isEqualToString:@"Haití"]) {
        self.lineUpLocalFlag.image = [UIImage imageNamed:@"Haiti"];
    } else {
        self.lineUpLocalFlag.image =[UIImage imageNamed:self.match.local];
    }
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
    NSLog(@"LINEUPS %@" , self.match.visitor_Lineup);
    
    if ([self.match.visitor isEqualToString:@"Haití"]) {
        self.lineUpVisitorFlag.image = [UIImage imageNamed:@"Haiti"];
    } else {
        self.lineUpVisitorFlag.image = [UIImage imageNamed:self.match.visitor];
    }
    
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
    if ([self.match.status isEqualToString: @"-1"]){
        //local Team A stats
        if ([self.match.local isEqualToString:@"Haití"]) {
            self.teamAStatsFlag.image = [UIImage imageNamed:@"Haiti"];
        } else {
            self.teamAStatsFlag.image = [UIImage imageNamed:self.match.local];
        }
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
        if ([self.match.visitor isEqualToString:@"Haití"]) {
            self.teamBStatsFlag.image = [UIImage imageNamed:@"Haiti"];
        } else {
            self.teamBStatsFlag.image = [UIImage imageNamed:self.match.visitor];
        }
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
        
    } else {
        //local Team A stats
        if ([self.match.local isEqualToString:@"Haití"]) {
            self.teamAStatsFlag.image = [UIImage imageNamed:@"Haiti"];
        } else {
            self.teamAStatsFlag.image = [UIImage imageNamed:self.match.local];
        }
        if(self.match.local_pos != NULL){
        self.local_posLabel.text = [NSString stringWithFormat:@"%@ %%" , self.match.local_pos];
        }
        self.local_sotLabel.text = self.match.local_sot;
        self.local_sonLabel.text = self.match.local_son;
        if (self.match.local_off != NULL){
            self.local_soffLabel.text = [NSString stringWithFormat:@"%@" , self.match.local_off];
        }
        if (self.match.local_frk == nil) {
            self.local_frkLabel.text = @"0";
        } else {
            self.local_frkLabel.text = self.match.local_frk;
        }
        self.local_blkLabel.text = self.match.local_blk;
        if (self.match.local_yc == nil) {
            self.local_ycLabel.text = @"0";
        } else {
            self.local_ycLabel.text = self.match.local_yc;
        }
        self.local_cor.text = self.match.local_cor;
        if (self.match.local_rc != NULL){
            self.local_rcLabel.text = [NSString stringWithFormat:@"%@", self.match.local_rc];
        }
        
        //local team B stats
        if ([self.match.visitor isEqualToString:@"Haití"]) {
            self.teamBStatsFlag.image = [UIImage imageNamed:@"Haiti"];
        } else {
            self.teamBStatsFlag.image = [UIImage imageNamed:self.match.visitor];
        }
        if(self.match.visitor_pos != NULL){
        self.visitor_posLabel.text = [NSString stringWithFormat: @"%@ %%",self.match.visitor_pos];
        }
        self.visitor_sotLabel.text = self.match.visitor_sot;
        self.visitor_sonLabel.text = self.match.visitor_son;
        if (self.match.visitor_off != NULL){
            self.visitor_soffLabel.text =[NSString stringWithFormat:@"%@" , self.match.visitor_off];
        }
        if (self.match.visitor_frk == nil) {
            self.visitor_frkLabel.text = @"0";
        } else {
            self.visitor_frkLabel.text = self.match.visitor_frk;
        }
        self.visitor_blkSaves.text = self.match.visitor_blk;
        if (self.match.visitor_yc == nil) {
            self.visitor_ycLabel.text = @"0";
        } else {
            self.visitor_ycLabel.text = self.match.visitor_yc;
        }
        self.visitor_cor.text = self.match.visitor_cor;
        if (self.match.visitor_rc != NULL){
            self.visitor_rcLabel.text = [NSString stringWithFormat:@"%@", self.match.visitor_rc];
        }
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
        
        if ([self.match.local isEqualToString:@"Haití"]) {
            cell.eventsTeamFlag.image = [UIImage imageNamed:@"Haiti"];
        } else {
            cell.eventsTeamFlag.image = [UIImage imageNamed: self.match.local];
        }
    } else if ([[event valueForKey:@"team"] isEqualToString: @"visitor"]) {
        
        if ([self.match.visitor isEqualToString:@"Haití"]) {
            cell.eventsTeamFlag.image = [UIImage imageNamed:@"Haiti"];
        } else {
            cell.eventsTeamFlag.image = [UIImage imageNamed: self.match.visitor];
        }
    } else{
        cell.eventsTeamFlag.image = [UIImage imageNamed:@""];
    }
    
    BOOL isPLayer = [event objectForKey:@"player"];
    
    if(isPLayer){
        cell.playerLabel.text = [event valueForKey:@"player"];
    } else if ([[event valueForKey:@"minute"] isEqualToString:@"0"]){
        cell.playerLabel.text = @"Kickoff!";
    }else {
        cell.playerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"replaced by", nil)];
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


- (IBAction)onEventButtonTapped:(UIButton *)sender {
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted){
                [self ifUserAllowsCalendarPermission:eventStore];
            }
            else
            {
                [self ifUserDontAllowCallendarPermission];
            }
        }];
    }
}

- (void)ifUserAllowsCalendarPermission:(EKEventStore*)eventStore {
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        UIAlertController *modalAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Save game to calendar?", nil)]
                                                                            message:[NSString stringWithFormat:NSLocalizedString(@"You will be notified 1 hour before the match starts", nil)]
                                                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *saveDate = [UIAlertAction actionWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Save", nil)]
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               [self saveMatchInCalendar:eventStore];
                                                           }];//save data block end
        
        UIAlertAction *dontSaveDate = [UIAlertAction actionWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Cancel", nil)]
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   NSLog(@"date dont saved");
                                                                   
                                                               }];
        [modalAlert addAction:saveDate];
        [modalAlert addAction:dontSaveDate];
        [self presentViewController:modalAlert animated:YES completion:nil];
    });//end dispatch
}

- (void)saveMatchInCalendar:(EKEventStore *)eventStore {
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = [NSString stringWithFormat:@"%@ vs %@" , self.match.local_abbr, self.match.visitor_abbr];
    event.notes = [NSString stringWithFormat:NSLocalizedString(@"Open the app to track this game", nil)];
    event.startDate = self.match.nsdate;
    event.endDate   = [[NSDate alloc] initWithTimeInterval:5400 sinceDate:event.startDate];
    event.URL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/copa-club-copa-america-live/id1111302609?mt=8"];
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    EKAlarm *alarm=[EKAlarm alarmWithRelativeOffset:-3600];
    [event addAlarm:alarm];
    
    [self checkIfEventExists:eventStore :event];
    
    if(!self.eventExists){
        NSError *err;
        BOOL save =  [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        self.eventSavedId = event.eventIdentifier;
        if (save) {
            NSLog(@"event saved this is the id %@" , self.eventSavedId);
            [self alertUserThatMatchIsSaved];
        }
    }else{
        NSLog(@"this event is already saved %@ ", event.title);
        [self alertUserThatMatchWasAlreadySaved];
    }
}

- (void)checkIfEventExists:(EKEventStore*)eventStore :(EKEvent*)event {
    
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:event.startDate endDate:event.endDate calendars:nil];
    NSArray *eventsOnDate = [eventStore eventsMatchingPredicate:predicate];
    self.eventExists  = NO;
    [eventsOnDate enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EKEvent *eventToCheck = (EKEvent*)obj;
        if([event.title isEqualToString:eventToCheck.title])
        {
            self.eventExists = YES;
            *stop = YES;
        }
    }];
}

- (void)alertUserThatMatchIsSaved {
    
    NSString *match = [NSString stringWithFormat:@"%@ vs %@", self.match.local_abbr , self.match.visitor_abbr];
    NSString *extraString = [NSString stringWithFormat:NSLocalizedString(@"added to your calendar", nil)];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: [NSString stringWithFormat:NSLocalizedString(@"Saved!", nil)]
                                                                   message: [NSString stringWithFormat:@"%@ %@", match, extraString]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)alertUserThatMatchWasAlreadySaved {
    
    NSString *match = [NSString stringWithFormat:@"%@ vs %@", self.match.local_abbr , self.match.visitor_abbr];
    NSString *extraString = [NSString stringWithFormat:NSLocalizedString(@"was already saved in your calendar", nil)];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: nil
                                                                   message: [NSString stringWithFormat:@"%@ %@", match, extraString]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)ifUserDontAllowCallendarPermission {
    
    NSLog(@"Permission not allowed");
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIAlertController *settingAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Please go to your app settings and allow Copa Club to acces your calendar", nil)]
                                                                              message:[NSString stringWithFormat:NSLocalizedString(@"You don't want to miss this game, do you?", nil)]
                                                                       preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Cancel", nil)]
                                                         style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                             NSLog(@"ill do it later");
                                                         }];
        UIAlertAction *go = [UIAlertAction actionWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Go", nil)]
                                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                     }];
        
        [settingAlert addAction:cancel];
        [settingAlert addAction:go];
        [self presentViewController:settingAlert animated:YES completion:nil];
    });
}
@end


