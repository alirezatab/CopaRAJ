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

@interface GroupVC ()<UITableViewDelegate, UITableViewDataSource>
@property NSManagedObjectContext *moc;
@property NSMutableArray *teams;
@property NSMutableArray *groups;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation GroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.moc = appDelegate.managedObjectContext;

    [self pullTeamsFromCoreData];
    [self pullGroupsFromCoreData];
  
    for (Group *group in self.groups) {
      [self conductJsonSearchForGroup:group];
    }
  
    //self.tableView.alwaysBounceVertical = NO;
}

- (void)pullTeamsFromCoreData {
  
  NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Team"];
  NSError *error;
  NSMutableArray *coreDataArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
  
  if (error == nil) {
    self.teams = [[NSMutableArray alloc]initWithArray:coreDataArray];
  } else {
    NSLog(@"%@", error);
  }
  
  if (self.teams.count == 0) {
    NSLog(@"Core data doesn't have any teams");
  }
}

- (void)pullGroupsFromCoreData {
  
  NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Group"];
  NSError *error;
  NSMutableArray *coreDataArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
  
  if (error == nil) {
    self.groups = [[NSMutableArray alloc]initWithArray:coreDataArray];
  } else {
    NSLog(@"%@", error);
  }
  
  if (self.groups.count == 0) {
    NSLog(@"Core data doesn't have any Groups");
    [self setupDefaultGroups];
  } else {
    [self.tableView reloadData];
  }
}

- (void)setupDefaultGroups {
  [self createGroups];
  [self assignTeamsToGroups];
  [self.tableView reloadData];
  
}

- (void) createGroups {
  
  NSArray *groupNames = @[@"A", @"B", @"C"];
  self.groups = [NSMutableArray new];
  
  for (NSString *groupName in groupNames) {
    Group *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:self.moc];
    group.groupID = groupName;
    [self.groups addObject:group];
  }
}

- (void) assignTeamsToGroups{
  
  for (Team *team in self.teams) {
    
    if ([team.countryName isEqualToString:@"Chile"] ||
        [team.countryName isEqualToString:@"Bolivia"] ||
        [team.countryName isEqualToString:@"Ecuador"] ||
        [team.countryName isEqualToString:@"Mexico"]) {
      
      team.group = [self.groups objectAtIndex:0];
      
    } else if ([team.countryName isEqualToString:@"Argentina"] ||
               [team.countryName isEqualToString:@"Paraguay"] ||
               [team.countryName isEqualToString:@"Uruguay"] ||
               [team.countryName isEqualToString:@"Jamaica"]) {
      
      team.group = [self.groups objectAtIndex:1];
      
    } else if ([team.countryName isEqualToString:@"Brazil"] ||
               [team.countryName isEqualToString:@"Peru"] ||
               [team.countryName isEqualToString:@"Colombia"] ||
               [team.countryName isEqualToString:@"Venezuela"]) {
      
      team.group = [self.groups objectAtIndex:2];
      
    } else {
      //for later
    }
  }
  
  NSError *error;
  if ([self.moc save:&error]) {
    NSLog(@"Groups and their relationships to teams should be saved in Core Data");
  } else {
    NSLog(@"failed because %@", error);
  }

}

- (void) conductJsonSearchForGroup: (Group *)group {
  
  NSMutableArray *groupTeams = [NSMutableArray new];
  for (Team *team in group.teams) {
    [groupTeams addObject:team];
  }
  
  NSString *searchVariable = [self returnGroupNameAsNumberForSearchFromName:group.groupID];
  
  NSString *urlString = [NSString stringWithFormat:@"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=tables&format=json&tz=America/Chicago&lang=en&league=177&group=%@&year=2015", searchVariable];
  NSURL *url = [NSURL URLWithString: urlString];
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
      NSMutableArray *table = dictionary[@"table"];
    
      for (NSDictionary *team in table) {
        NSLog(@"The team from  Json is %@", team[@"team"]);
        [self updateTeamFromTeamArray:groupTeams WithLatestDictionary:team];
        //[self updateMatchsArray: <your match array> withDictionary:<jsonDictionaryforIndividualMatch>]
      }
    
    NSError *saveError;
    if ([self.moc save:&saveError]) {
      NSLog(@"Teams updated");
      [self.tableView reloadData];
    } else {
      NSLog(@"Team updates resulted in the following error: %@", saveError);
    }
    }];
  
  [task resume];
}

- (void)updateTeamFromTeamArray:(NSMutableArray *)teams WithLatestDictionary:(NSDictionary *)dictionary {
  
  NSString *teamNameFromDictionary = dictionary[@"team"];
  Team *teamForDictionary;
  
  for (Team *team in teams) {
    if ([team.countryName isEqualToString:teamNameFromDictionary]) {
      teamForDictionary = team;
    }
  }
  teamForDictionary.wins = dictionary[@"wins"];
  teamForDictionary.points = dictionary[@"points"];
  teamForDictionary.losses = dictionary[@"losses"];
  teamForDictionary.id = dictionary[@"id"];
  teamForDictionary.goalsFor = dictionary[@"gf"];
  teamForDictionary.goalsAgainst = dictionary[@"ga"];
  teamForDictionary.gamesPlayed = dictionary[@"round"];
  teamForDictionary.position = dictionary[@"pos"];
  teamForDictionary.draws = dictionary[@"draws"];
  
  NSLog(@"The team that will be updated is %@", teamForDictionary.countryName);
  
}

-(NSString *)returnGroupNameAsNumberForSearchFromName: (NSString *)groupName{
  
  NSString *groupNumber = @"";
  
  if ([groupName  isEqualToString: @"A"]) {
    groupNumber = @"1";
  } else if ([groupName  isEqualToString: @"B"]){
    groupNumber = @"2";
  } else {
    groupNumber = @"3";
  }
  
  return groupNumber;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  GroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teamCell" forIndexPath:indexPath];

  cell.teamCountry.text = @"test";
  
  return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return self.groups.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  Group *group = [self.groups objectAtIndex:section];
  return group.groupID;
}




@end
