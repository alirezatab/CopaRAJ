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
    
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    
    NSLog(@"%f width and , %f height", screenWidth , screenHeight );

    NSLog(@"%f tableview width ", self.view.frame.size.width);
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
    NSString *groupLetter = [NSString stringWithFormat: @"Group %@", group.groupLetter];
    
    [groupLabel setText: groupLetter];
    [gpLabel setText: @"GP"];
    [wLabel setText:@"W"];
    [tLabel setText:@"T"];
    [lLabel setText:@"L"];
    [ptsLabel setText:@"PTS"];
    
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






