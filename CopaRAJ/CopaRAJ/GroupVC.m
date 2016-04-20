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

@interface GroupVC ()
@property NSManagedObjectContext *moc;
@property NSMutableArray *teams;
@property NSMutableArray *groups;


@end

@implementation GroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.moc = appDelegate.managedObjectContext;

    [self pullTeamsFromCoreData];
    [self pullGroupsFromCoreData];
    [self conductJsonSearchForGroup:[self.groups objectAtIndex:0]];
    [self conductJsonSearchForGroup:[self.groups objectAtIndex:1]];
    [self conductJsonSearchForGroup:[self.groups objectAtIndex:2]];
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
    //[self.tableview reloadData];
  } else {
    NSLog(@"%@", error);
  }
  
  if (self.groups.count == 0) {
    NSLog(@"Core data doesn't have any Groups");
    [self setupDefaultGroups];
  }
}

- (void)setupDefaultGroups {
  [self createGroups];
  [self assignTeamsToGroups];
  
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
  
  for (Group *group in self.groups) {
    [group createTeamNamesForGroup:group];
  }
  
  NSError *error;
  if ([self.moc save:&error]) {
    NSLog(@"Groups and their relationships to teams should be saved in Core Data");
  } else {
    NSLog(@"failed because %@", error);
  }

}

- (void) conductJsonSearchForGroup: (Group *)group {
  NSString *searchVariable = [self returnGroupNameAsNumberForSearchFromName:group.groupID];
  
  NSString *urlString = [NSString stringWithFormat:@"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=tables&format=json&tz=America/Chicago&lang=en&league=177&group=%@&year=2015", searchVariable];
  NSURL *url = [NSURL URLWithString: urlString];
  
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSMutableArray *table = dictionary[@"table"];
    
    for (NSDictionary *team in table) {
      NSLog(@"%@", team[@"team"]);
    }
  }];
  
  [task resume];
  
}

-(NSString *)returnGroupNameAsNumberForSearchFromName: (NSString *)groupName{
  
  NSString *groupNumber = @"";
  if ([groupName  isEqualToString: @"A"]) {
    groupNumber = @"1";
  }else if ([groupName  isEqualToString: @"B"]){
    groupNumber = @"2";
  } else {
    groupNumber = @"3";
  }
  
  return groupNumber;

}



- (void)getGroupInfoFromAPIForGroup: (NSString *)groupName {
  
  NSString *group = [self returnGroupNameAsNumberForSearchFromName:groupName];
  
  NSString *urlString = [NSString stringWithFormat:@"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=tables&format=json&tz=America/Chicago&lang=en&league=177&group=%@&year=2015", group];
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLSession *session = [NSURLSession sharedSession];
  
  
  NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    NSArray *table = dictionary[@"table"];
    
    //create group objects setup relationships to teams and give teams their values
    
    
  }];
  
  
}

@end
