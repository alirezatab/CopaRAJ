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

@interface GroupVC ()
@property NSManagedObjectContext *moc;
@property NSMutableArray *teams;

@end

@implementation GroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.moc = appDelegate.managedObjectContext;
  
    [self pullTeamsFromCoreData];
  
  if (self.teams.count == 0) {
    [self createTournamentTeams];
  }
  
    NSLog(@"%lu is how many teams are in our array",(unsigned long)self.teams.count);
  
    NSLog(@"sqlite dir = \n%@", appDelegate.applicationDocumentsDirectory);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    [self createTournamentTeams];
    
  }
}

- (void)createTournamentTeams {
  
  NSArray *teamsIntournament = @[@"Argentina", @"Bolivia", @"Brazil", @"Chile", @"Columbia", @"Costa Rica", @"Ecuador", @"Haiti", @"Jamaica", @"Mexico", @"Panama", @"Paraguay", @"Peru", @"Uruguay", @"USA", @"Venezuela"];
  
  NSArray *teamAbbrevs = @[@"ARG", @"BOL", @"BRA", @"CHI", @"COL", @"CRC", @"ECU", @"HAI", @"JAM", @"MEX", @"PAN", @"PAR", @"PER", @"URU", @"USA", @"VEN"];
  
  self.teams = [NSMutableArray new];
  int index = 0;
  for (NSString *teamName in teamsIntournament) {
    Team *newTeam = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.moc];
    [newTeam createDefaultTeamSettingsForTeam:newTeam andName:teamName];
    
    NSString *abr = [teamAbbrevs objectAtIndex:index];
    newTeam.abbreviationName = abr;
    index++;
    
    NSLog(@"%@", newTeam.abbreviationName);
    [self.teams addObject:newTeam];
  }
  
  NSError *error;
  if ([self.moc save:&error]) {
    NSLog(@"Teams were saved to core Data");
  } else {
    NSLog(@"failed because %@", error);
  }
  
}




@end
