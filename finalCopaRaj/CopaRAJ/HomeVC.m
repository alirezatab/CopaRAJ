//
//  HomeVC.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "HomeVC.h"
#import "HomeTableViewCell.h"
#import "Match.h"
#import "AppDelegate.h"
#import "Team.h"
#import "TourneyVC.h"
#import "Group.h"
#import "TourneyVC.h"
#import "GameVC.h"
#import "FBMatch.h"
#import <Firebase/Firebase.h>
#import "GroupVC.h"
#import "GameVC.h"
//#import "ChallengeHomeVC.swift"

@interface HomeVC ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeMatchesButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *groupStandingsButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playOffMatchesButton;
@property (weak, nonatomic) IBOutlet UIView *cupView;

@property NSMutableArray *mathches;
@property NSMutableArray *sortedMatches;
@property NSMutableArray *finalArray;
@property NSMutableArray *playoffMatches;
@property NSArray *setMatchIDS;
@property FBMatch *matchA1B2;
@property FBMatch *matchB1A2;
@property FBMatch *matchD1C2;
@property FBMatch *matchC1D2;
@property FBMatch *matchW25W27;
@property FBMatch *matchW26W28;
@property FBMatch *matchL29L30;
@property FBMatch *matchW29W30;
@property NSDictionary *juneDates;
@property BOOL didScrollToDate;
@property UIButton *buttonRight;
@property UIButton *buttonLeft;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property int intCalls;
@end


@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.intCalls = 0;
    self.navigationItem.hidesBackButton = YES;
    
    [self.homeMatchesButton setTintColor:[UIColor whiteColor]];
    [self.homeMatchesButton setImage: [UIImage imageNamed:NSLocalizedString(@"imageName", nil)]];
    [self.groupStandingsButton setTintColor:[UIColor grayColor]];
    [self.playOffMatchesButton setTintColor:[UIColor grayColor]];
    
    [self initNeededObjects];
    [self callFireBase];
    [self.activityIndicator startAnimating];
}

- (IBAction)testButton:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"ChallengeHomeVC" sender:sender];
}


- (void) initNeededObjects {
  self.mathches = [NSMutableArray new];
  self.setMatchIDS = [NSArray new];
  self.setMatchIDS = [NSArray arrayWithObjects:@"347356",@"347351",@"347362",@"347347",@"347358",@"347342",@"347353",@"347364",@"347349",@"347344",@"347355",@"347350",@"347361", @"347346", @"347357", @"347352", @"347363", @"347348", @"347359", @"347343", @"347354", @"347365", @"347360", @"347345", nil];
  self.playoffMatches = [NSMutableArray new];
  self.sortedMatches = [NSMutableArray new];
  self.finalArray = [NSMutableArray new];
  self.juneDates = @{@"2016-06-04":@1, @"2016-06-05":@2, @"2016-06-06":@3, @"2016-06-07":@4, @"2016-06-08":@5, @"2016-06-09":@6, @"2016-06-10":@7, @"2016-06-11":@8, @"2016-06-12":@9, @"2016-06-13":@10, @"2016-06-14":@11, @"2016-06-15":@11, @"2016-06-16":@12, @"2016-06-17":@13, @"2016-06-18":@14, @"2016-06-19":@14, @"2016-06-20":@15, @"2016-06-21":@15, @"2016-06-22":@16, @"2016-06-23":@16, @"2016-06-24":@17, @"2016-06-25":@17, @"2016-06-26":@17, @"2016-06-27":@17, @"2016-06-28":@17};
  self.didScrollToDate = false;
  self.cupView.hidden = true;
  
  [self.tableView addSubview:self.cupView];
  [self.tableView sendSubviewToBack:self.cupView];
  
  self.matchA1B2 = [FBMatch new];
  self.matchB1A2 = [FBMatch new];
  self.matchD1C2 = [FBMatch new];
  self.matchC1D2 = [FBMatch new];
  self.matchW25W27 = [FBMatch new];
  self.matchW26W28 = [FBMatch new];
  self.matchL29L30 = [FBMatch new];
  self.matchW29W30 = [FBMatch new];
  
}

- (void)callFireBase {
    Firebase *ref = [[Firebase alloc]initWithUrl:@"https://fiery-inferno-5799.firebaseio.com/Playoff_Schedule"];
    // FireBase Listener
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        
        
        self.matchA1B2.local = @"A1";
        self.matchA1B2.visitor = @"B2";
        self.matchA1B2.schedule = [snapshot.value objectForKey:@"A1B2"];
        self.matchA1B2.local_abbr = @"A1";
        self.matchA1B2.visitor_abbr = @"B2";
        self.matchA1B2.status = @"-1";
        self.matchA1B2.stadium = @"CenturyLink Field";
        [self addNSDateForMatch:self.matchA1B2];
        [self.playoffMatches addObject:self.matchA1B2];
        
        self.matchB1A2.local = @"B1";
        self.matchB1A2.visitor = @"A2";
        self.matchB1A2.schedule = [snapshot.value objectForKey:@"B1A2"];
        self.matchB1A2.local_abbr = @"B1";
        self.matchB1A2.visitor_abbr = @"A2";
        self.matchB1A2.stadium = @"MetLife Stadium";
        self.matchB1A2.status = @"-1";
      
        //NSLog(@"b1: %@ a2: %@ schedule: %@", self.matchB1A2.local, self.matchB1A2.visitor, self.matchB1A2.schedule);
        [self addNSDateForMatch:self.matchB1A2];
        [self.playoffMatches addObject:self.matchB1A2];
        
        self.matchD1C2.local = @"D1";
        self.matchD1C2.visitor = @"C2";
        self.matchD1C2.schedule = [snapshot.value objectForKey:@"D1C2"];
        self.matchD1C2.local_abbr = @"D1";
        self.matchD1C2.visitor_abbr = @"C2";
        self.matchD1C2.status = @"-1";
        self.matchD1C2.stadium = @"Gillette Stadium";
        [self addNSDateForMatch:self.matchD1C2];
        [self.playoffMatches addObject:self.matchD1C2];
        
        
        self.matchC1D2.local = @"C1";
        self.matchC1D2.visitor = @"D2";
        self.matchC1D2.schedule = [snapshot.value objectForKey:@"C1D2"];
        self.matchC1D2.local_abbr = @"C1";
        self.matchC1D2.visitor_abbr = @"D2";
        self.matchC1D2.status = @"-1";
        self.matchC1D2.stadium = @"Levi's Stadium";
        [self addNSDateForMatch:self.matchC1D2];
        [self.playoffMatches addObject:self.matchC1D2];
        
        
        self.matchW25W27.local = @"W25";
        self.matchW25W27.visitor = @"W27";
        self.matchW25W27.schedule = [snapshot.value objectForKey:@"W25W27"];
        self.matchW25W27.local_abbr = @"W25";
        self.matchW25W27.visitor_abbr = @"W27";
        self.matchW25W27.status = @"-1";
        self.matchW25W27.stadium = @"NRG Stadium";
        [self addNSDateForMatch:self.matchW25W27];
        [self.playoffMatches addObject:self.matchW25W27];
        
        
        self.matchW26W28.local = @"W26";
        self.matchW26W28.visitor = @"W28";
        self.matchW26W28.schedule = [snapshot.value objectForKey:@"W26W28"];
        self.matchW26W28.local_abbr = @"W26";
        self.matchW26W28.visitor_abbr = @"W28";
        self.matchW26W28.status = @"-1";
        self.matchW26W28.stadium =@"Soldier Field";
        [self addNSDateForMatch:self.matchW26W28];
        [self.playoffMatches addObject:self.matchW26W28];
        
        
        self.matchW29W30.local = @"W29";
        self.matchW29W30.visitor = @"W30";
        self.matchW29W30.schedule = [snapshot.value objectForKey:@"W29W30"];
        self.matchW29W30.local_abbr = @"W29";
        self.matchW29W30.visitor_abbr = @"W30";
        self.matchW29W30.status = @"-1";
        self.matchW29W30.stadium = @"MetLife Stadium";
        [self addNSDateForMatch:self.matchW29W30];
        [self.playoffMatches addObject:self.matchW29W30];
        //NSLog(@"%lu is the playoff match count", (unsigned long)self.playoffMatches.count);
        
        self.matchL29L30.local = @"L29";
        self.matchL29L30.visitor = @"L30";
        self.matchL29L30.schedule = [snapshot.value objectForKey:@"L29L30"];
        self.matchL29L30.local_abbr = @"L29";
        self.matchL29L30.visitor_abbr = @"L30";
        self.matchL29L30.status = @"-1";
        self.matchL29L30.stadium = @"University of Phoenix Stadium";
        [self addNSDateForMatch:self.matchL29L30];
        [self.playoffMatches addObject:self.matchL29L30];
        
        for (FBMatch *match in self.playoffMatches) {
            [match createDateInfoForMatch];
        }
        [self getMatchesFromFireBase];
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
        [self presentErrorWithString:error.description];
    }];
}

- (void) addNSDateForMatch: (FBMatch *)match {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Madrid"];
    match.nsdate = [formatter dateFromString:match.schedule];

}

- (void)getMatchesFromFireBase {
  Firebase *ref = [[Firebase alloc]initWithUrl:@"https://fiery-inferno-5799.firebaseio.com/matches"];
  [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
    
    self.sortedMatches = [NSMutableArray new];
    self.finalArray = [NSMutableArray new];
    for (id match in snapshot.value) {
      
      
      NSDictionary *matchData = [snapshot.value valueForKey:match];
      if ([[matchData valueForKey:@"category_id"] isEqualToString:@"177"]) {
        
        if ([self match:matchData alreadyExistsInArray:self.mathches]) {
          //self.intCalls++;
          NSLog(@"%i", self.intCalls);
          [FBMatch updateMatchInArray:self.mathches withData:matchData];
        } else if ([self.setMatchIDS containsObject:match]){
          FBMatch *newFoundMatch = [FBMatch new];
          [newFoundMatch updateMatch:newFoundMatch WithData:matchData];
          [self.mathches addObject:newFoundMatch];
        } else if ([[matchData valueForKey:@"category_id"]isEqualToString:@"177"]) {
          [FBMatch updateMatchInArray:self.playoffMatches withData:matchData];
        }
      }
    }
    
    if (self.mathches.count == 24) {
      [self.mathches addObjectsFromArray:self.playoffMatches];
    }
    
    [self sortMatches];
    //reloading table view!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    [self matchesAreDoneLoading];
    
    
  } withCancelBlock:^(NSError *error) {
    [self presentErrorWithString:error.description];
  }];
}

- (void)createArraysForSectionHeaders {
  
  NSString *matchDate;
  
  for (FBMatch *match  in self.sortedMatches) {
    if (matchDate == nil) {
      matchDate  = match.date;
      [self.finalArray addObject:[@[match]mutableCopy]];
      
    } else if ([matchDate isEqualToString: match.date]){
      
      [self.finalArray[self.finalArray.count - 1] addObject:match];
    } else{
      matchDate = match.date;
      [self.finalArray addObject:[@[match]mutableCopy]];
    }
  }
}

- (void)sortMatches {
  
  NSSortDescriptor *sortDescriptor;
  sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"schedule"
                                               ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
  self.sortedMatches = [[self.mathches sortedArrayUsingDescriptors:sortDescriptors]mutableCopy];
  NSLog(@"count of sorted matches: %lu",(unsigned long)self.sortedMatches.count);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
  self.buttonRight.hidden = true;
  self.buttonLeft.hidden = true;
}

- (void)matchesAreDoneLoading {
  [self.activityIndicator stopAnimating];
  self.activityIndicator.hidden = true;
  [self createArraysForSectionHeaders];
  [self.tableView reloadData];
  
  if (!self.didScrollToDate && self.finalArray.count >= 18) {
    [self scrollToDate];
    self.didScrollToDate = true;
  };
  self.cupView.hidden = false;
}



- (void) scrollToDate {
  
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSString *date = [dateFormatter stringFromDate:[NSDate date]];
  NSLog(@"%@ is the current date", date);
  
   for (id juneDate in self.juneDates) {
     if ([juneDate isEqualToString:date]) {
       NSLog(@"passEd");
       NSInteger section = [[self.juneDates objectForKey:juneDate]integerValue];
       [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]atScrollPosition:UITableViewScrollPositionTop animated:NO];
       [self loadUpButtons];
     }
  }
}
-(void)loadUpButtons {
  self.buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.buttonLeft addTarget:self
                       action:@selector(onUpPressed)
             forControlEvents:UIControlEventTouchUpInside];
  [self.buttonLeft setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
  self.buttonLeft.frame = CGRectMake(30, 75, 16, 16);
  [self.view addSubview:self.buttonLeft];
  
  self.buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.buttonRight addTarget:self
                      action:@selector(onUpPressed)
            forControlEvents:UIControlEventTouchUpInside];
  [self.buttonRight setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
  self.buttonRight.frame = CGRectMake(self.view.frame.size.width - 51, 75, 16, 16);
  [self.view addSubview:self.buttonRight];
}

-(void) onUpPressed {
  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

- (BOOL)match: (NSDictionary *)match alreadyExistsInArray:(NSMutableArray *)array {
  
  NSString *schedule = [match valueForKey:@"schedule"];

  for (FBMatch *game in array) {
    if ([game.schedule isEqualToString:schedule]) {
      return true;
    }
  }
  return false;
  
}

- (void)presentErrorWithString: (NSString *)string {
  UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:string preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    NSLog(@"ok");
  }];
  
  [controller addAction:action];
  
  [self presentViewController:controller animated:NO completion:^{
  }];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"matchDetails"]) {
    GameVC *destVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSArray *arr = [self.finalArray objectAtIndex:indexPath.section];
    destVC.match = [arr objectAtIndex:indexPath.row];
  } else if([segue.identifier isEqualToString:@"ChallengeHomeVC"]) {

  }
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
  
}

//////////////////tableview stuff/////////////////////////////////////////
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.finalArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSArray *sections =[self.finalArray objectAtIndex:section];
  return sections.count;
}


//create setter
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  NSArray *arr = [self.finalArray objectAtIndex:indexPath.section];
  FBMatch *match = [arr objectAtIndex:indexPath.row];
  cell.teamOneName.text = match.local_abbr;
  cell.teamTwoName.text = match.visitor_abbr;
  cell.locationLabel.text = match.stadium;
  
  //freaking Haiti
  if ([match.local isEqualToString:@"Haití"]) {
    cell.teamOneImage.image = [UIImage imageNamed:@"Haiti"];
  } else {
    cell.teamOneImage.image = [UIImage imageNamed:match.local];
  }
  if ([match.visitor isEqualToString:@"Haití"]) {
    cell.teamTwoImage.image = [UIImage imageNamed:@"Haiti"];
  } else {
    cell.teamTwoImage.image = [UIImage imageNamed:match.visitor];
  }
  
  //penalties
  
  
  //time parameters + score logic + penalties
  if ([match.status isEqualToString: @"-1"]) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@:%@", match.hour, match.minute]];
    dateFormatter.dateFormat = @"hh:mm a";
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ ET", dateString];
    cell.teamOneScore.text = @"";
    cell.teamTwoScore.text = @"";
    cell.penaltiesLabel.text = @"";
  } else if ([match.status isEqualToString:@"0"]){
    cell.timeLabel.text = match.live_minute;
    cell.teamOneScore.text = match.local_goals;
    cell.teamTwoScore.text = match.visitor_goals;
      if (match.pen1 == [NSNumber numberWithInteger:0] && match.pen2 == [NSNumber numberWithInteger:0] ) {
        cell.penaltiesLabel.text = @"";
      } else {
      cell.penaltiesLabel.text = [NSString stringWithFormat:@"(%@-%@)", match.pen1, match.pen2];
      }
  } else if ([match.status isEqualToString:@"1"])  {
    cell.timeLabel.text = @"Final";
    cell.teamOneScore.text = match.local_goals;
    cell.teamTwoScore.text = match.visitor_goals;
      if (match.pen1 == [NSNumber numberWithInteger:0] && match.pen2 == [NSNumber numberWithInteger:0] ) {
        cell.penaltiesLabel.text = @"";
      } else {
        cell.penaltiesLabel.text = [NSString stringWithFormat:@"(%@-%@)", match.pen1, match.pen2];
    }
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)initializeRefreshControl
{
 
}
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Leave Alone!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 40;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
  /* Create custom view to display section header... */
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 32)];
  [label setFont:[UIFont fontWithName:@"GothamMedium" size:13]];
  [label setTextAlignment:NSTextAlignmentCenter];
  [label setTextColor:[UIColor colorWithWhite:0.600 alpha:1.000]];
  
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
  [dateFormat setDateStyle:NSDateFormatterFullStyle];
  
  FBMatch *m = [[self.finalArray  objectAtIndex:section] firstObject];
  NSDate *date = m.nsdate;
  
  NSString *sectionTitle = [dateFormat stringFromDate:date];    /* Section header is in 0th index... */
  
  [label setText:sectionTitle];
  [view addSubview:label];
  [view setBackgroundColor:[UIColor colorWithWhite:0.969 alpha:1.000]]; //your background
  
  return view;
}

- (UIStatusBarStyle)preferredStatusBar {
  return UIStatusBarStyleLightContent;
}

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!MAYBE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

//- (void)kickSoccerBall {
//  CGFloat f = (CGFloat)0;
//  [UIView animateWithDuration:10.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//    CGRect r = CGRectMake(f, f, self.sliderImage.frame.size.height, self.sliderImage.frame.size.width);
//    CGRect r1 = CGRectMake(self.slideView.frame.size.width, f, self.sliderImage.frame.size.height, self.sliderImage.frame.size.width);
//    [self.sliderImage setFrame:r];
//    
//    [self.sliderImage setFrame:r1];
//  } completion:^(BOOL finished) {
//    
//  }];
//}
//- (void)storeDatesinAnArray {
//  //storing all the dates in an array
//  NSMutableArray *matchDates = [NSMutableArray new];
//  
//  for (Match *matchDate in self.matchesObject) {
//    [matchDates addObject:matchDate.date];
//  }
//  //taking out duplicate dates
//  NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:matchDates];
//  self.matchDatesWithNoDuplicates = [orderedSet array];
//  
//  //dividing the matches by dates in separate arrays based on dates
//  for (Match *match in self.matchesObject) {
//    if ([match.date compare:self.matchDatesWithNoDuplicates[0]]  == NSOrderedSame){
//      [self.m0 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[1]] == NSOrderedSame){
//      [self.m1 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[2]] == NSOrderedSame){
//      [self.m2 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[3]] == NSOrderedSame){
//      [self.m3 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[4]] == NSOrderedSame){
//      [self.m4 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[5]] == NSOrderedSame){
//      [self.m5 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[6]] == NSOrderedSame){
//      [self.m6 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[7]] == NSOrderedSame){
//      [self.m7 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[8]] == NSOrderedSame){
//      [self.m8 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[9]] == NSOrderedSame){
//      [self.m9 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[10]] == NSOrderedSame){
//      [self.m10 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[11]] == NSOrderedSame){
//      [self.m11 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[12]] == NSOrderedSame){
//      [self.m12 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[13]] == NSOrderedSame){
//      [self.m13 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[14]] == NSOrderedSame){
//      [self.m14 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[15]] == NSOrderedSame){
//      [self.m15 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[16]] == NSOrderedSame){
//      [self.m16 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[17]] == NSOrderedSame){
//      [self.m17 addObject:match];
//    }else if ([match.date compare:self.matchDatesWithNoDuplicates[18]] == NSOrderedSame){
//      [self.m18 addObject:match];
//    }
//  }
//  
//  [self.finalArray addObject:self.m0];
//  [self.finalArray addObject:self.m1];
//  [self.finalArray addObject:self.m2];
//  [self.finalArray addObject:self.m3];
//  [self.finalArray addObject:self.m4];
//  [self.finalArray addObject:self.m5];
//  [self.finalArray addObject:self.m6];
//  [self.finalArray addObject:self.m7];
//  [self.finalArray addObject:self.m8];
//  [self.finalArray addObject:self.m9];
//  [self.finalArray addObject:self.m10];
//  [self.finalArray addObject:self.m11];
//  [self.finalArray addObject:self.m12];
//  [self.finalArray addObject:self.m13];
//  [self.finalArray addObject:self.m14];
//  [self.finalArray addObject:self.m15];
//  [self.finalArray addObject:self.m16];
//  [self.finalArray addObject:self.m17];
//  [self.finalArray addObject:self.m18];
//}

//- (void)updateMatchesWithMatchData:(NSDictionary *)dictionary {
//    
//    BOOL matchesAlreadyExist = [self checkIfMatchesAlreadyExist:dictionary];
//    
//    if(matchesAlreadyExist){
//        [self updateExistingMatchWithDictionary: dictionary];
//    } else {
//        //[self createNewMatch: dictionary];
//    }
//}
//
//- (BOOL) checkIfMatchesAlreadyExist:(NSDictionary *)dictionary {
//    NSMutableArray *matchIds = [NSMutableArray new];
//    
//    for (Match *match in self.matchesObject) {
//        [matchIds addObject:match.matchId];
//    }
//    NSString *dictionaryMatchId = dictionary[@"id"];
//    
//    if ([matchIds containsObject:dictionaryMatchId]) {
//        return YES;
//    } else {
//        return NO;
//    }
//}

//- (void)updateExistingMatchWithDictionary:(NSDictionary *)dictionary {
//    
//    for (Match *match in self.matchesObject) {
//        if([match.matchId isEqualToString:dictionary[@"id"]]) {
//            
//            Match *matchingMatch = match;
//            matchingMatch.score = dictionary[@"result"];
//            matchingMatch.hour = dictionary[@"hour"];
//            matchingMatch.minute = dictionary[@"minute"];
//            matchingMatch.localAbbr = dictionary[@"local_abbr"];
//            matchingMatch.visitorAbbr = dictionary[@"visitor_abbr"];
//            matchingMatch.matchId = dictionary[@"id"];
//            matchingMatch.localTeam = dictionary[@"local"];
//            matchingMatch.visitingTeam = dictionary[@"visitor"];
//            matchingMatch.localScore = dictionary[@"local_goals"];
//            matchingMatch.visitorScore = dictionary[@"visitor_goals"];
//            matchingMatch.penalties1 = [NSString stringWithFormat:@"%@", dictionary[@"penaltis1"]];
//            matchingMatch.penalties2 = [NSString stringWithFormat:@"%@", dictionary[@"penaltis2"]];
//            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
//            [dateFormat setDateFormat:@"yyyy/MM/dd"];
//            NSDate *date = [dateFormat dateFromString:dictionary[@"date"]];
//            matchingMatch.date = date;
//            //testing
//            matchingMatch.groupCode = dictionary[@"round"];
//        }
//    }
//}

//- (void)getMatchesFromPlist {
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"playOffMatches" ofType:@"plist"];
//    
//    self.playOffMatchesFromPlist = [[[NSArray alloc] initWithContentsOfFile:path]mutableCopy];
//    
//    for (NSDictionary *match in self.playOffMatchesFromPlist) {
//        
//        if (![self checkIfMatchesAlreadyExist:match]){
//            Match *playOffMatch = [NSEntityDescription insertNewObjectForEntityForName:@"Match" inManagedObjectContext:self.moc];
//            playOffMatch.matchId = [match valueForKey:@"id"];
//            playOffMatch.localAbbr = [match valueForKey:@"local"];
//            NSLog(@"%@ is p list local team", playOffMatch.localAbbr);
//            playOffMatch.visitorAbbr = [match valueForKey:@"visitor"];
//            playOffMatch.location = [match valueForKey:@"location"];
//            playOffMatch.hour = [match valueForKey:@"time"];
//            
//            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
//            [dateFormat setDateFormat:@"yyyy/MM/dd"];
//            NSDate *date = [dateFormat dateFromString:[match valueForKey:@"date"]];
//            playOffMatch.date = date;
//            
//            NSError *error;
//            if([self.moc save:&error]){
//                NSLog(@"HI");
//                [self.matchesObject addObject:playOffMatch];
//            }else{
//                NSLog(@"an error has occurred,...%@", error);
//            }
//        }
//    }
//    NSLog(@"self.matchesObject.count : %lu", (unsigned long)self.matchesObject.count);
//}
//



//--------------------------------------------OLD--------------------------------------------------
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


//- (void)pullTeamsFromCoreData {
//
//    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Team"];
//    NSError *error;
//    NSMutableArray *coreDataArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
//    
//    if (error == nil) {
//        self.teams = [[NSMutableArray alloc]initWithArray:coreDataArray];
//    } else {
//        NSLog(@"%@", error);
//    }
//    
//    if (self.teams.count == 0) {
//        NSLog(@"Core data doesn't have any teams");
//        [self createTournamentTeams];
//    }
//}

//- (void) createGroups {
//    
//    NSArray *groupNames = @[@"A", @"B", @"C"];
//    self.groups = [NSMutableArray new];
//    for (NSString *groupName in groupNames) {
//        Group *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:self.moc];
//        group.groupID = groupName;
//        [self.groups addObject:group];
//    }
//}

//- (void)pullGroupsFromCoreData {
//    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Group"];
//    
//    NSError *error;
//    NSMutableArray *coreDataArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
//    
//    if (error == nil) {
//        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupID" ascending:YES];
//        self.groups = [[coreDataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
//    } else {
//        NSLog(@"%@", error);
//    }
//    if (self.groups.count == 0) {
//        NSLog(@"Core data doesn't have any groups");
//        [self setupDefaultGroups];
//    }
//}

//- (void)setupDefaultGroups {
//    [self createGroups];
//    [self assignTeamsToGroups];
//}

//- (void) assignTeamsToGroups{
//    
//    for (Team *team in self.teams) {
//        
//        if ([team.countryName isEqualToString:@"Chile"] ||
//            [team.countryName isEqualToString:@"Bolivia"] ||
//            [team.countryName isEqualToString:@"Ecuador"] ||
//            [team.countryName isEqualToString:@"Mexico"]) {
//            
//            team.group = [self.groups objectAtIndex:0];
//            
//        } else if ([team.countryName isEqualToString:@"Argentina"] ||
//                   [team.countryName isEqualToString:@"Paraguay"] ||
//                   [team.countryName isEqualToString:@"Uruguay"] ||
//                   [team.countryName isEqualToString:@"Jamaica"]) {
//            
//            team.group = [self.groups objectAtIndex:1];
//            
//        } else if ([team.countryName isEqualToString:@"Brazil"] ||
//                   [team.countryName isEqualToString:@"Peru"] ||
//                   [team.countryName isEqualToString:@"Colombia"] ||
//                   [team.countryName isEqualToString:@"Venezuela"]) {
//            
//            team.group = [self.groups objectAtIndex:2];
//            
//        } else {
//            //for later
//        }
//    }
//    NSError *error;
//    if ([self.moc save:&error]) {
////        NSLog(@"Groups and their relationships to teams should be saved in Core Data");
//    } else {
//        NSLog(@"failed because %@", error);
//    }
//    
//}

//- (void)createTournamentTeams {
//    
//    NSArray *teamsIntournament = @[@"Argentina", @"Bolivia", @"Brazil", @"Chile", @"Colombia", @"Costa Rica", @"Ecuador", @"Haiti", @"Jamaica", @"Mexico", @"Panama", @"Paraguay", @"Peru", @"Uruguay", @"USA", @"Venezuela"];
//    
//    NSArray *teamAbbrevs = @[@"ARG", @"BOL", @"BRA", @"CHI", @"COL", @"CRC", @"ECU", @"HAI", @"JAM", @"MEX", @"PAN", @"PAR", @"PER", @"URU", @"USA", @"VEN"];
//    
//    self.teams = [NSMutableArray new];
//    int index = 0;
//    for (NSString *teamName in teamsIntournament) {
//        NSString *abr = [teamAbbrevs objectAtIndex:index];
//      
//        self.team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.moc];
//
//        self.team.abbreviationName = abr;
//        
//        [self.team createDefaultTeamSettingsForTeam:self.team andName:teamName];
//        self.team.flagImageName = self.team.abbreviationName;
//        self.team.flagImageName = self.team.abbreviationName;
//        index++;
//
//        [self.teams addObject:self.team];
//    }
//    
//    NSError *error;
//    if ([self.moc save:&error]) {
////        NSLog(@"teams was saved to coredata");
//    } else {
//        NSLog(@"failed because %@", error);
//    }
//}



//- (void) conductJsonSearchForGroup: (Group *)group {
//    NSMutableArray *groupTeams = [NSMutableArray new];
//    for (Team *team in group.teams) {
//        [groupTeams addObject:team];
//    }
//    
//    NSString *searchVariable = [Group returnGroupNameAsNumberForSearchFromName:group.groupID];
//    
//    NSString *urlString = [NSString stringWithFormat:@"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=tables&format=json&tz=America/Chicago&lang=en&league=177&group=%@&year=2015", searchVariable];
//    NSURL *url = [NSURL URLWithString: urlString];
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//        NSMutableArray *table = dictionary[@"table"];
//        
//        for (NSDictionary *team in table) {
////            NSLog(@"The team from  Json is %@", team[@"team"]);
//            [self updateTeamFromTeamArray:groupTeams WithLatestDictionary:team];
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            //Run UI Updates
//            NSError *saveError;
//            if ([self.moc save:&saveError]) {
//                NSLog(@"Teams updated");
//                [self.tableView reloadData];
//            } else {
//                NSLog(@"Team updates resulted in the following error: %@", saveError);
//            }
//        });
//    }];
//    [task resume];
//}

//- (void)updateTeamFromTeamArray:(NSMutableArray *)teams WithLatestDictionary:(NSDictionary *)dictionary {
//    
//    NSString *teamNameFromDictionary = dictionary[@"team"];
//    Team *teamForDictionary;
//    
//    for (Team *team in teams) {
//        if ([team.countryName isEqualToString:teamNameFromDictionary]) {
//            teamForDictionary = team;
//        }
//    }
//    teamForDictionary.wins = dictionary[@"wins"];
//    teamForDictionary.points = dictionary[@"points"];
//    teamForDictionary.losses = dictionary[@"losses"];
//    teamForDictionary.id = dictionary[@"id"];
//    teamForDictionary.goalsFor = dictionary[@"gf"];
//    teamForDictionary.goalsAgainst = dictionary[@"ga"];
//    teamForDictionary.gamesPlayed = dictionary[@"round"];
//    teamForDictionary.position = dictionary[@"pos"];
//    teamForDictionary.draws = dictionary[@"draws"];
//}

//- (void)createNewMatch:(NSDictionary *)dictionary {
//
//    Match *matchObject = [NSEntityDescription insertNewObjectForEntityForName:@"Match" inManagedObjectContext:self.moc];
//    matchObject.score = dictionary[@"result"];
//    matchObject.matchId = dictionary[@"id"];
//    matchObject.hour = dictionary[@"hour"];
//    matchObject.minute = dictionary[@"minute"];
//    matchObject.localAbbr = dictionary[@"local_abbr"];
//    matchObject.visitorAbbr = dictionary[@"visitor_abbr"];
//    matchObject.localTeam = dictionary[@"local"];
//    matchObject.visitingTeam = dictionary[@"visitor"];
//    matchObject.localScore = dictionary[@"local_goals"];
//    matchObject.visitorScore = dictionary[@"visitor_goals"];
//    matchObject.penalties1 = [NSString stringWithFormat:@"%@", dictionary[@"penaltis1"]];
//    matchObject.penalties2 = [NSString stringWithFormat:@"%@", dictionary[@"penaltis2"]];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
//    [dateFormat setDateFormat:@"yyyy/MM/dd"];
//    NSDate *date = [dateFormat dateFromString:dictionary[@"date"]];
//    matchObject.date = date;
//
//    //testing
//    matchObject.groupCode = dictionary[@"round"];
//    [self.matchesObject addObject:matchObject];
//
//}

////user gets the matches from the API
//- (void)getMatchesFromJsonAndSaveInCoreData {
//
//    for (int i = 1; i< 4; i++) {
//
//        NSString *urlBase = @"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=matchs&format=json&tz=America/Chicago&lang=en&league=177&group=all&round=";
//
//
//        NSString *urlString = [NSString stringWithFormat:@"%@%i",urlBase, i];
//
//        NSURL *url = [NSURL URLWithString:urlString];
//
//        NSURLSession *session = [NSURLSession sharedSession];
//
//        NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//
//            NSMutableArray *matchesData = [NSMutableArray new];
//            matchesData = dictionary[@"match"];
//
//            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"schedule" ascending:YES];
//            NSMutableArray *sortedMatchesData = [NSMutableArray new];
//            sortedMatchesData = [[matchesData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
//          NSLog(@"%@", sortedMatchesData);
//          }];
//        [task resume];
//    }
//}

//- (void)getPlayOffsFromJsonAndSaveInCoreData {
//  
//  for (int i = 1; i< 4; i++) {
//    
//    NSString *urlBase = @"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=matchs&format=json&tz=America/Chicago&lang=en&league=177&round=";
//    
//    
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@%i",urlBase, i];
//    
//    NSURL *url = [NSURL URLWithString:urlString];
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//      
//      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//      
//      NSMutableArray *matchesData = [NSMutableArray new];
//      matchesData = dictionary[@"match"];
//      
//      for (NSDictionary *matchData in matchesData) {
//        
//        [self updateMatchesWithMatchData: matchData];
//      }
//      NSError *mocError;
//      if([self.moc save:&mocError]){
//        NSLog(@"this was saved and there are %lu matches", (unsigned long)self.matchesObject.count);
//      }else{
//        NSLog(@"an error has occurred,...%@", error);
//      }
//      
//      dispatch_async(dispatch_get_main_queue(), ^(void){
//        //Run UI Updates
//        [self.tableView reloadData];
//      });
//    }];
//    [task resume];
//  }
//}

//@property NSMutableArray *matchesData;
//@property NSMutableArray *matchesObject;
//@property NSMutableArray *playOffMatchesFromPlist;
//@property NSMutableArray *playOffTeamsTest;
//
//@property NSArray *matchDatesWithNoDuplicates;
//@property NSMutableArray *finalArray;
//@property NSMutableArray *m0;
//@property NSMutableArray *m1;
//@property NSMutableArray *m2;
//@property NSMutableArray *m3;
//@property NSMutableArray *m4;
//@property NSMutableArray *m5;
//@property NSMutableArray *m6;
//@property NSMutableArray *m7;
//@property NSMutableArray *m8;
//@property NSMutableArray *m9;
//@property NSMutableArray *m10;
//@property NSMutableArray *m11;
//@property NSMutableArray *m12;
//@property NSMutableArray *m13;
//@property NSMutableArray *m14;
//@property NSMutableArray *m15;
//@property NSMutableArray *m16;
//@property NSMutableArray *m17;
//@property NSMutableArray *m18;


@end
