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
    NSLog(@"%lu",(unsigned long)self.teams.count);
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
  }
}

@end
