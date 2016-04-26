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


@end

@implementation GroupVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.hidesBackButton = YES;
  self.groups = [NSMutableArray new];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
  return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return self.groups.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  FBGroup *group = [self.groups objectAtIndex:section];
  NSString *sectionHeader = [NSString stringWithFormat:@"Group: %@                  GP       W        T         L        PTS ", group.groupLetter];
  
  return sectionHeader;
}


//////////////////////////////////////////////////////////////////////////////////////////////////
//************************************ OLD ********************************************************


//groups is my array of sections
//Now I need an array of teams for each group

//deleted after merge
//- (void)setupDefaultGroups {
//  [self createGroups];
//  [self assignTeamsToGroups];
//  [self.tableView reloadData];
//}

//deleted after merge
//- (void) createGroups {
//
//  NSArray *groupNames = @[@"A", @"B", @"C"];
//  self.groups = [NSMutableArray new];
//
//  for (NSString *groupName in groupNames) {
//    Group *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:self.moc];
//    group.groupID = groupName;
//    [self.groups addObject:group];
//  }
//}

//deted after merge
//- (void) assignTeamsToGroups{
//
//  for (Team *team in self.teams) {
//
//    if ([team.countryName isEqualToString:@"Chile"] ||
//        [team.countryName isEqualToString:@"Bolivia"] ||
//        [team.countryName isEqualToString:@"Ecuador"] ||
//        [team.countryName isEqualToString:@"Mexico"]) {
//
//      team.group = [self.groups objectAtIndex:0];
//
//    } else if ([team.countryName isEqualToString:@"Argentina"] ||
//               [team.countryName isEqualToString:@"Paraguay"] ||
//               [team.countryName isEqualToString:@"Uruguay"] ||
//               [team.countryName isEqualToString:@"Jamaica"]) {
//
//      team.group = [self.groups objectAtIndex:1];
//
//    } else if ([team.countryName isEqualToString:@"Brazil"] ||
//               [team.countryName isEqualToString:@"Peru"] ||
//               [team.countryName isEqualToString:@"Colombia"] ||
//               [team.countryName isEqualToString:@"Venezuela"]) {
//
//      team.group = [self.groups objectAtIndex:2];
//
//    } else {
//      //for later
//    }
//  }

//  NSError *error;
//  if ([self.moc save:&error]) {
//    NSLog(@"Groups and their relationships to teams should be saved in Core Data");
//  } else {
//    NSLog(@"failed because %@", error);
//  }
//
//}

//- (void) conductJsonSearchForGroup: (Group *)group {
//
//  NSMutableArray *groupTeams = [NSMutableArray new];
//  for (Team *team in group.teams) {
//    [groupTeams addObject:team];
//  }
//
//  NSString *searchVariable = [Group returnGroupNameAsNumberForSearchFromName:group.groupID];
//
//  NSString *urlString = [NSString stringWithFormat:@"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=tables&format=json&tz=America/Chicago&lang=en&league=177&group=%@&year=2015", searchVariable];
//  NSURL *url = [NSURL URLWithString: urlString];
//  NSURLSession *session = [NSURLSession sharedSession];
//
//  NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//      NSMutableArray *table = dictionary[@"table"];
//
//      for (NSDictionary *team in table) {
//        NSLog(@"The team from  Json is %@", team[@"team"]);
//        [Team updateTeamFromTeamArray:groupTeams WithLatestDictionary:team];
//        //[self updateMatchsArray: <your match array> withDictionary:<jsonDictionaryforIndividualMatch>]
//      }
//
//    dispatch_async(dispatch_get_main_queue(), ^(void){
//      NSError *saveError;
//      if ([self.moc save:&saveError]) {
//        NSLog(@"Teams updated");
//        [self.tableView reloadData];
//      } else {
//        NSLog(@"Team updates resulted in the following error: %@", saveError);
//      }
//    });
//  }];
//
//  [task resume];
//}

//- (void)pullGroupsFromCoreData {
//
//  NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Group"];
//  NSError *error;
//  NSMutableArray *coreDataArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
//
//  if (error == nil) {
//    self.groups = [NSMutableArray new];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupID" ascending:YES];
//    self.groups = [[coreDataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
//  } else {
//    NSLog(@"%@", error);
//  }
//
//  if (self.groups.count == 0) {
////   ******** [self setupDefaultGroups];
//    //NSLog(@"Core data doesn't have any Groups");
//  }
//}

//- (void)pullTeamsFromCoreData {
//
//  NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Team"];
//  NSError *error;
//  NSMutableArray *coreDataArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
//
//  if (error == nil) {
//    self.teams = [[NSMutableArray alloc]initWithArray:coreDataArray];
//  } else {
//    NSLog(@"%@", error);
//  }
//}

@end
