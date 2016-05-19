////
////  PickGroupVC.m
////  CopaRAJ
////
////  Created by Richard Velazquez on 5/18/16.
////  Copyright © 2016 AR-T.com, Inc. All rights reserved.
////
//
//#import "working.h"
//#import "Team.h"
//#import "AppDelegate.h"
//#import "Group.h"
//#import "GroupTableViewCell.h"
//#import "FBGroup.h"
//#import <Firebase/Firebase.h>
//
//@interface working ()<UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate>
//@property NSManagedObjectContext *moc;
//@property NSMutableArray *teams;
//@property NSMutableArray *groups;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//
//
//
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
//
//
//
//@end
//
//@implementation PickGroupVC
//
//-(void)viewWillAppear:(BOOL)animated{
//  [super viewWillAppear:NO];
//  self.navigationController.navigationBar.hidden = NO;
//
//}
//
//- (void)viewDidLoad {
//  
//  [super viewDidLoad];
//  self.title = [NSString stringWithFormat:NSLocalizedString(@"Pick Group Standings", nil)];
//  self.navigationItem.hidesBackButton = YES;
//  [self.activityIndicator startAnimating];
//  [self.activityIndicator setHidesWhenStopped:YES];
//  self.groups = [NSMutableArray new];
//  
//  [self createListeners];
//  self.tableView.allowsSelection = YES;
//  [self.tableView setEditing:true];
//  self.tableView.userInteractionEnabled = true;
//
//}
//
//#pragma FireBase
//-(void)createListeners {
//  
//  Firebase *ref = [[Firebase alloc]initWithUrl:@"https://fiery-inferno-5799.firebaseio.com/Groups"];
//  [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//    
//    NSMutableArray *groupData = snapshot.value;
//    [self updateGroupsArray:groupData];
//    
//  } withCancelBlock:^(NSError *error) {
//    
//    NSLog(@"%@", error.description);
//    //tell user to reconnect to internet
//  }];
//}
//
//
//
//-(void)updateGroupsArray: (NSMutableArray *)array{
//  
//  NSDictionary *group1Data = [array objectAtIndex:1];
//  NSDictionary *group2Data = [array objectAtIndex:2];
//  NSDictionary *group3Data = [array objectAtIndex:3];
//  NSDictionary *group4Data = [array objectAtIndex:4];
//  
//  NSMutableArray *group1table = group1Data[@"table"];
//  NSMutableArray *group2table = group2Data[@"table"];
//  NSMutableArray *group3table = group3Data[@"table"];
//  NSMutableArray *group4table = group4Data[@"table"];
//  
//  FBGroup *groupOne = [FBGroup createGroupFromTable:group1table];
//  FBGroup *groupTwo = [FBGroup createGroupFromTable:group2table];
//  FBGroup *groupThree = [FBGroup createGroupFromTable:group3table];
//  FBGroup *groupFour = [FBGroup createGroupFromTable:group4table];
//  
//  [self.groups addObject:groupOne];
//  [self.groups addObject:groupTwo];
//  [self.groups addObject:groupThree];
//  [self.groups addObject:groupFour];
//  
//  if (self.groups.count > 0) {
//    [self.tableView reloadData];
//    [self.activityIndicator stopAnimating];
//  }
//}
//
//#pragma TableView
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//  
//  GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"team" forIndexPath:indexPath];
//  FBGroup *group = [self.groups objectAtIndex:indexPath.section];
//  
//  if (indexPath.row == 0) {
//    cell.teamImage.image = [UIImage imageNamed:group.team1Team];
//    cell.teamGoals.text = group.team1Round;
//    
//    if ([group.team1Team isEqualToString:@"United States"]) {
//      cell.teamCountry.text = [NSString stringWithFormat:NSLocalizedString(@"United States", nil)];
//    } else {
//      cell.teamCountry.text = group.team1Team;
//    }
//    
//    cell.teamWins.text = [NSString stringWithFormat:@"%@", group.team1Wins];
//    cell.teamTies.text = [NSString stringWithFormat:@"%@", group.team1Draws];
//    cell.teamLosses.text = [NSString stringWithFormat:@"%@", group.team1Losses];
//    cell.teamPoints.text = [NSString stringWithFormat:@"%@", group.team1Points];
//    
//  } else if (indexPath.row == 1) {
//    if ([group.team2Team isEqualToString:@"United States"]) {
//      cell.teamCountry.text = [NSString stringWithFormat:NSLocalizedString(@"United States", nil)];
//    } else {
//      cell.teamCountry.text = group.team2Team;
//    }
//    cell.teamImage.image = [UIImage imageNamed:group.team2Team];
//    cell.teamGoals.text = group.team2Round;
//    cell.teamWins.text = [NSString stringWithFormat:@"%@", group.team2Wins];
//    cell.teamTies.text = [NSString stringWithFormat:@"%@", group.team2Draws];
//    cell.teamLosses.text = [NSString stringWithFormat:@"%@", group.team2Losses];
//    cell.teamPoints.text = [NSString stringWithFormat:@"%@", group.team2Points];
//    
//  } else if (indexPath.row == 2){
//    if ([group.team3Team isEqualToString:@"United States"]) {
//      cell.teamCountry.text = [NSString stringWithFormat:NSLocalizedString(@"United States", nil)];
//    } else {
//      cell.teamCountry.text = group.team3Team;
//    }
//    cell.teamImage.image = [UIImage imageNamed:group.team3Team];
//    cell.teamGoals.text = group.team3Round;
//    cell.teamWins.text = [NSString stringWithFormat:@"%@", group.team3Wins];
//    cell.teamTies.text = [NSString stringWithFormat:@"%@", group.team3Draws];
//    cell.teamLosses.text = [NSString stringWithFormat:@"%@", group.team3Losses];
//    cell.teamPoints.text = [NSString stringWithFormat:@"%@", group.team3Points];
//    
//  } else {
//    if ([group.team4Team isEqualToString:@"United States"]) {
//      cell.teamCountry.text = [NSString stringWithFormat:NSLocalizedString(@"United States", nil)];
//    } else {
//      cell.teamCountry.text = group.team4Team;
//    }
//    cell.teamImage.image = [UIImage imageNamed:group.team4Team];
//    cell.teamGoals.text = group.team4Round;
//    cell.teamWins.text = [NSString stringWithFormat:@"%@", group.team4Wins];
//    cell.teamTies.text = [NSString stringWithFormat:@"%@", group.team4Draws];
//    cell.teamLosses.text = [NSString stringWithFormat:@"%@", group.team4Losses];
//    cell.teamPoints.text = [NSString stringWithFormat:@"%@", group.team4Points];
//  }
//  
//  return cell;
//}
//
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//  return self.groups.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//  return 4;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//  
//  CGRect screenBound = [[UIScreen mainScreen] bounds];
//  CGSize screenSize = screenBound.size;
//  CGFloat screenWidth = screenSize.width;
//  
//  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
//  
//  /* Create custom view to display section header... */
//  UILabel *groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,5,screenWidth/3.9, 45)];
//
//  
//  //setting the font, color &alignment for groupLabel
//  [groupLabel setFont:[UIFont fontWithName:@"GothamMedium" size:15]];
//  [groupLabel setTextColor:[UIColor colorWithWhite:0.600 alpha:1.000]];
//  [groupLabel setTextAlignment:NSTextAlignmentCenter];
//  
//  //set the color of the view
//  [view setBackgroundColor:[UIColor colorWithWhite:0.969 alpha:1.000]];//your background
//  
//  //getting the Group
//  FBGroup *group = [self.groups objectAtIndex:section];
//  
//  //set the strings for the header labels
//  
//  NSString *groupSpanish = [NSString stringWithFormat:NSLocalizedString(@"Group", nil)];
//  NSString *groupLetter = [NSString stringWithFormat: @"%@ %@", groupSpanish, group.groupLetter];
//  
//  [groupLabel setText: groupLetter];
//  
//  [view addSubview:groupLabel];
//
//  
//  return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//  return 50;
//}
//
//-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//  return YES;
//  
//}
//
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//  return true;
//}
//
//-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//  //captures temporary values
//  
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//  return UITableViewCellEditingStyleNone;
//}
//
//- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//  return NO;
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
//{
//  if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
//    NSInteger row = 0;
//    if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
//      row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
//    }
//    return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
//  }
//  
//  FBGroup *tempGroup = [self.groups objectAtIndex:sourceIndexPath.section];
//  
//  return proposedDestinationIndexPath;
//}
//
//
//
//@end




