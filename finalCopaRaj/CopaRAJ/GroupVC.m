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

@interface GroupVC ()<UITableViewDelegate, UITableViewDataSource>
@property NSManagedObjectContext *moc;
@property NSMutableArray *teams;
@property NSMutableArray *groups;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *groupButton;


@end

@implementation GroupVC

- (void)viewDidLoad {

  [super viewDidLoad];
  self.navigationItem.hidesBackButton = YES;
  self.groups = [NSMutableArray new];
  [self.groupButton setTintColor:[UIColor redColor]];
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
      //tell user to reconnect to unternet
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
  }
  
}

#pragma TableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teamCell" forIndexPath:indexPath];
  FBGroup *group = [self.groups objectAtIndex:indexPath.section];
  
  if (indexPath.row == 0) {
    cell.teamImage.image = [UIImage imageNamed:group.team1Team];
    cell.teamCountry.text = group.team1Team;
    cell.teamGoals.text = group.team1Gf;
    cell.teamWins.text = [NSString stringWithFormat:@"%@", group.team1Wins];
    cell.teamTies.text = [NSString stringWithFormat:@"%@", group.team1Draws];
    
  } else if (indexPath.row == 1) {
    cell.teamImage.image = [UIImage imageNamed:group.team2Team];
    cell.teamCountry.text = group.team2Team;
    cell.teamGoals.text = group.team2Gf;
    cell.teamWins.text = [NSString stringWithFormat:@"%@", group.team2Wins];
    cell.teamTies.text = [NSString stringWithFormat:@"%@", group.team2Draws];
    
  } else if (indexPath.row == 2){
    cell.teamImage.image = [UIImage imageNamed:group.team3Team];
    cell.teamCountry.text = group.team3Team;
    cell.teamGoals.text = group.team3Gf;
    cell.teamWins.text = [NSString stringWithFormat:@"%@", group.team3Wins];
    cell.teamTies.text = [NSString stringWithFormat:@"%@", group.team3Draws];
    
  } else {
    cell.teamImage.image = [UIImage imageNamed:group.team4Team];
    cell.teamCountry.text = group.team4Team;
    cell.teamGoals.text = group.team4Gf;
    cell.teamWins.text = [NSString stringWithFormat:@"%@", group.team4Wins];
    cell.teamTies.text = [NSString stringWithFormat:@"%@", group.team4Draws];
    
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 45)];
    [label setFont:[UIFont fontWithName:@"GothamMedium" size:14]];
    [label setTextAlignment:NSTextAlignmentJustified];
   
    [label setTextColor:[UIColor colorWithWhite:0.600 alpha:1.000]];
      FBGroup *group = [self.groups objectAtIndex:section];
      NSString *sectionHeader = [NSString stringWithFormat:@"Group: %@              GP     W      T      L      PTS ", group.groupLetter];
   
    
    [label setText:sectionHeader];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithWhite:0.969 alpha:1.000]]; //your background
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
@end
