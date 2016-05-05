//
//  GroupVC.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "GroupVC.h"
#import "Team.h"
#import "AppDelegate.h"
#import "Group.h"
#import "GroupTableViewCell.h"
#import "FBGroup.h"
#import <Firebase/Firebase.h>

@interface GroupVC ()<UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate>
@property NSManagedObjectContext *moc;
@property NSMutableArray *teams;
@property NSMutableArray *groups;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeMatchesButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *groupStandingsButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playOffMatchesButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GroupVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:NSLocalizedString(@"Groups", nil)];
    self.navigationItem.hidesBackButton = YES;
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
    self.groups = [NSMutableArray new];
    
    [self.homeMatchesButton setImage: [UIImage imageNamed:NSLocalizedString(@"imageName", nil)]];
    
    [self.homeMatchesButton setTintColor:[UIColor grayColor]];
    [self.groupStandingsButton setTintColor:[UIColor whiteColor]];
    [self.playOffMatchesButton setTintColor:[UIColor grayColor]];
    
    [self createListeners];
    self.tableView.allowsSelection = NO;
}

#pragma FireBase
-(void)createListeners {
  
  Firebase *ref = [[Firebase alloc]initWithUrl:@"https://fiery-inferno-5799.firebaseio.com/Groups"];
  [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {

    NSMutableArray *groupData = snapshot.value;
    [self updateGroupsArray:groupData];
    
  } withCancelBlock:^(NSError *error) {
    
      NSLog(@"%@", error.description);
      //tell user to reconnect to internet
  }];
}

-(void)updateGroupsArray: (NSMutableArray *)array{
  
  NSDictionary *group1Data = [array objectAtIndex:1];
  NSDictionary *group2Data = [array objectAtIndex:2];
  NSDictionary *group3Data = [array objectAtIndex:3];
  NSDictionary *group4Data = [array objectAtIndex:4];
  
  NSMutableArray *group1table = group1Data[@"table"];
  NSMutableArray *group2table = group2Data[@"table"];
  NSMutableArray *group3table = group3Data[@"table"];
  NSMutableArray *group4table = group4Data[@"table"];
  
  FBGroup *groupOne = [FBGroup createGroupFromTable:group1table];
  FBGroup *groupTwo = [FBGroup createGroupFromTable:group2table];
  FBGroup *groupThree = [FBGroup createGroupFromTable:group3table];
  FBGroup *groupFour = [FBGroup createGroupFromTable:group4table];

  [self.groups addObject:groupOne];
  [self.groups addObject:groupTwo];
  [self.groups addObject:groupThree];
  [self.groups addObject:groupFour];
  
  if (self.groups.count > 0) {
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];
  }
}

#pragma TableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teamCell" forIndexPath:indexPath];
  FBGroup *group = [self.groups objectAtIndex:indexPath.section];
  
  if (indexPath.row == 0) {
    cell.teamImage.image = [UIImage imageNamed:group.team1Team];
    cell.teamGoals.text = group.team1Round;
      
      if ([group.team1Team isEqualToString:@"United States"]) {
          cell.teamCountry.text = [NSString stringWithFormat:NSLocalizedString(@"United States", nil)];
      } else {
          cell.teamCountry.text = group.team1Team;
      }
      
    cell.teamWins.text = [NSString stringWithFormat:@"%@", group.team1Wins];
    cell.teamTies.text = [NSString stringWithFormat:@"%@", group.team1Draws];
    cell.teamLosses.text = [NSString stringWithFormat:@"%@", group.team1Losses];
    cell.teamPoints.text = [NSString stringWithFormat:@"%@", group.team1Points];
    
  } else if (indexPath.row == 1) {
      if ([group.team2Team isEqualToString:@"United States"]) {
          cell.teamCountry.text = [NSString stringWithFormat:NSLocalizedString(@"United States", nil)];
      } else {
          cell.teamCountry.text = group.team2Team;
      }
    cell.teamImage.image = [UIImage imageNamed:group.team2Team];
    cell.teamGoals.text = group.team2Round;
    cell.teamWins.text = [NSString stringWithFormat:@"%@", group.team2Wins];
    cell.teamTies.text = [NSString stringWithFormat:@"%@", group.team2Draws];
    cell.teamLosses.text = [NSString stringWithFormat:@"%@", group.team2Losses];
    cell.teamPoints.text = [NSString stringWithFormat:@"%@", group.team2Points];

} else if (indexPath.row == 2){
    if ([group.team3Team isEqualToString:@"United States"]) {
        cell.teamCountry.text = [NSString stringWithFormat:NSLocalizedString(@"United States", nil)];
    } else {
        cell.teamCountry.text = group.team3Team;
    }
    cell.teamImage.image = [UIImage imageNamed:group.team3Team];
    cell.teamGoals.text = group.team3Round;
    cell.teamWins.text = [NSString stringWithFormat:@"%@", group.team3Wins];
    cell.teamTies.text = [NSString stringWithFormat:@"%@", group.team3Draws];
    cell.teamLosses.text = [NSString stringWithFormat:@"%@", group.team3Losses];
    cell.teamPoints.text = [NSString stringWithFormat:@"%@", group.team3Points];

  } else {
      if ([group.team4Team isEqualToString:@"United States"]) {
          cell.teamCountry.text = [NSString stringWithFormat:NSLocalizedString(@"United States", nil)];
      } else {
          cell.teamCountry.text = group.team4Team;
      }
    cell.teamImage.image = [UIImage imageNamed:group.team4Team];
    cell.teamGoals.text = group.team4Round;
    cell.teamWins.text = [NSString stringWithFormat:@"%@", group.team4Wins];
    cell.teamTies.text = [NSString stringWithFormat:@"%@", group.team4Draws];
    cell.teamLosses.text = [NSString stringWithFormat:@"%@", group.team4Losses];
    cell.teamPoints.text = [NSString stringWithFormat:@"%@", group.team4Points];
  }
  
  return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    int labelWidth = (screenWidth - 150) /5;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    /* Create custom view to display section header... */
    UILabel *groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,5,screenWidth/3.9, 45)];
    UILabel *gpLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, labelWidth, 45)];
    UILabel *wLabel = [[UILabel alloc] initWithFrame:CGRectMake(184, 5, labelWidth, 45)];
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(218, 5, labelWidth, 45)];
    UILabel *lLabel = [[UILabel alloc] initWithFrame:CGRectMake(252, 5, labelWidth, 45)];
    UILabel *ptsLabel = [[UILabel alloc] initWithFrame:CGRectMake(286, 5,labelWidth, 45)];

    //setting the font, color &alignment for groupLabel
    [groupLabel setFont:[UIFont fontWithName:@"GothamMedium" size:15]];
    [groupLabel setTextColor:[UIColor colorWithWhite:0.600 alpha:1.000]];
    [groupLabel setTextAlignment:NSTextAlignmentCenter];
    
    for (UILabel *label in @[gpLabel,wLabel,tLabel,lLabel,ptsLabel] ){
        [label setFont:[UIFont fontWithName:@"Gotham Narrow" size:13]];
        [label setTextColor:[UIColor colorWithWhite:0.600 alpha:1.000]];
        [label setTextAlignment:NSTextAlignmentCenter];
    }
    
    //set the color of the view
    [view setBackgroundColor:[UIColor colorWithWhite:0.969 alpha:1.000]];//your background
    
    //getting the Group
    FBGroup *group = [self.groups objectAtIndex:section];

    //set the strings for the header labels
    
    NSString *groupSpanish = [NSString stringWithFormat:NSLocalizedString(@"Group", nil)];
    NSString *groupLetter = [NSString stringWithFormat: @"%@ %@", groupSpanish, group.groupLetter];
    
    [groupLabel setText: groupLetter];
    [gpLabel setText: [NSString stringWithFormat:NSLocalizedString(@"GP", nil)]];
    [wLabel setText:[NSString stringWithFormat:NSLocalizedString(@"W", nil)]];
    [tLabel setText:[NSString stringWithFormat:NSLocalizedString(@"T", nil)]];;
    [lLabel setText:[NSString stringWithFormat:NSLocalizedString(@"L", nil)]];;
    [ptsLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Pts", nil)]];
    
    [view addSubview:groupLabel];
    [view addSubview:gpLabel];
    [view addSubview:wLabel];
    [view addSubview:tLabel];
    [view addSubview:lLabel];
    [view addSubview:ptsLabel];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
@end






