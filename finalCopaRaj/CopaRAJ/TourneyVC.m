//
//  TourneyVC.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "TourneyVC.h"
#import "BracketCell.h"
#import "AppDelegate.h"
#import "Group.h"
#import "Team.h"
#import "Match.h"
#import <Firebase/Firebase.h>
#import "FBMatch.h"
#import "GameVC.h"

@interface TourneyVC () <UICollectionViewDelegate, UICollectionViewDataSource>

//plug back in when everyone merges
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property NSManagedObjectContext *moc;
@property NSMutableArray *teams;
@property NSMutableArray *groups;

@property NSMutableArray *playoffTeams;
@property NSArray *sortedPlayoffTeams;

@property NSMutableArray *matchesData;
@property NSMutableArray *matchesObject;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tourneyButton;

@property NSMutableArray *playOffMatchesFromPlist;
@property NSMutableArray *miniArray;

@property FBMatch *matchA1B2;
@property FBMatch *matchB1A2;
@property FBMatch *matchD1C2;
@property FBMatch *matchC1D2;
@property FBMatch *matchW25W27;
@property FBMatch *matchW26W28;
@property FBMatch *matchL29L30;
@property FBMatch *matchW29W30;

@property BOOL isPlayOff;

//@property Match *match;
//@property Team *team;

@end

@implementation TourneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view did load");
    self.navigationItem.hidesBackButton = YES;
    [self.tourneyButton setTintColor:[UIColor redColor]];
  
    self.playoffTeams = [[NSMutableArray alloc]init];
    self.matchesObject = [[NSMutableArray alloc]init];
    
    self.matchA1B2 = [[FBMatch alloc]init];
    self.matchB1A2 = [[FBMatch alloc]init];
    self.matchD1C2 = [[FBMatch alloc]init];
    self.matchC1D2 = [[FBMatch alloc]init];
    self.matchW25W27 = [[FBMatch alloc]init];
    self.matchW26W28 = [[FBMatch alloc]init];
    self.matchL29L30 = [[FBMatch alloc]init];
    self.matchW29W30 = [[FBMatch alloc]init];
    
    [self createDefaultPlayoffMatches];
    
    [self.matchesObject addObjectsFromArray:@[@[self.matchA1B2, self.matchB1A2, self.matchD1C2, self.matchC1D2], @[self.matchW25W27, self.matchW26W28], @[self.matchL29L30, self.matchW29W30], @[]]];
    
    NSLog(@"%lu", self.matchesObject.count);
    
    // URL that fire base accesses
//    Firebase *ref = [[Firebase alloc]initWithUrl:@"https://fiery-inferno-5799.firebaseio.com/matches"];
    Firebase *ref = [[Firebase alloc]initWithUrl:@"https://fiery-inferno-5799.firebaseio.com/tests/matches"];
    // FireBase Listener
    [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
//    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSNumber *isPlayoffs = snapshot.value[@"playoffs"];
        self.isPlayOff = isPlayoffs.boolValue;
        NSLog(@"%d", self.isPlayOff);
        NSMutableArray *playoffTeams = [NSMutableArray new];
        if (self.isPlayOff == 1) {
            if ([self.matchA1B2.schedule isEqualToString: snapshot.value[@"schedule"]]) {
                self.matchA1B2.matchID = snapshot.value[@"id"];
                
                self.matchA1B2.local = snapshot.value[@"local"];
                self.matchA1B2.local_abbr = snapshot.value[@"local_abbr"];
                self.matchA1B2.local_goals = snapshot.value[@"local_goals"];
                
                self.matchA1B2.visitor = snapshot.value[@"visitor"];
                self.matchA1B2.visitor_abbr = snapshot.value[@"visitor_abbr"];
                self.matchA1B2.visitor_goals = snapshot.value[@"visitor_goals"];
                
                [self.collectionView reloadData];
            } else if ([self.matchB1A2.schedule isEqualToString: snapshot.value[@"schedule"]]){
                self.matchB1A2.matchID = snapshot.value[@"id"];
                
                self.matchB1A2.local = snapshot.value[@"local"];
                self.matchB1A2.local_abbr = snapshot.value[@"local_abbr"];
                self.matchB1A2.local_goals = snapshot.value[@"local_goals"];
                
                self.matchB1A2.visitor = snapshot.value[@"visitor"];
                self.matchB1A2.visitor_abbr = snapshot.value[@"visitor_abbr"];
                self.matchB1A2.visitor_goals = snapshot.value[@"visitor_goals"];
                
                [self.collectionView reloadData];
            } else if ([self.matchD1C2.schedule isEqualToString: snapshot.value[@"schedule"]]){
                self.matchD1C2.matchID = snapshot.value[@"id"];
                
                self.matchD1C2.local = snapshot.value[@"local"];
                self.matchD1C2.local_abbr = snapshot.value[@"local_abbr"];
                self.matchD1C2.local_goals = snapshot.value[@"local_goals"];
                
                self.matchD1C2.visitor = snapshot.value[@"visitor"];
                self.matchD1C2.visitor_abbr = snapshot.value[@"visitor_abbr"];
                self.matchD1C2.visitor_goals = snapshot.value[@"visitor_goals"];
                
                [self.collectionView reloadData];
            } else if ([self.matchC1D2.schedule isEqualToString: snapshot.value[@"schedule"]]){
                
                
                self.matchC1D2.local = snapshot.value[@"local"];
                
                self.matchC1D2.visitor = snapshot.value[@"visitor"];
                
                [self.collectionView reloadData];
            } else if ([self.matchW25W27.schedule isEqualToString: snapshot.value[@"schedule"]]){
                //NSLog(@"Match ID: %@\n is at: %@", snapshot.value[@"id"], snapshot.value[@"schedule"]);
            } else if ([self.matchW26W28.schedule isEqualToString: snapshot.value[@"schedule"]]){
                //NSLog(@"Match ID: %@\n is at: %@", snapshot.value[@"id"], snapshot.value[@"schedule"]);
            } else if ([self.matchW29W30.schedule isEqualToString: snapshot.value[@"schedule"]]){
                //NSLog(@"Match ID: %@\n is at: %@", snapshot.value[@"id"], snapshot.value[@"schedule"]);
            }
            NSLog(@"%@", snapshot.value[@"id"]);
            [playoffTeams addObject:snapshot.value[@"id"]];
            NSLog(@"%lu", (unsigned long)self.playoffTeams.count);
        }
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];

//    NSLog(@"%lu", self.matchesObject.count);
}

#pragma mark - CollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BracketCell *cell = (BracketCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    BracketCell *cellFinal = (BracketCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CellFinal" forIndexPath:indexPath];
    
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [[UIColor whiteColor]CGColor];

    switch (indexPath.section) {
        case 0:{
            self.miniArray = [[NSMutableArray alloc]init];
            self.miniArray = [self.matchesObject objectAtIndex:0];
            cell.FBMatch = [self.miniArray objectAtIndex:indexPath.row];
            return cell;
        }
        case 1:{
            self.miniArray = [[NSMutableArray alloc]init];
            self.miniArray = [self.matchesObject objectAtIndex:1];
            cell.FBMatch = [self.miniArray objectAtIndex:indexPath.row];
            return cell;
        }
        case 2:{
            self.miniArray = [[NSMutableArray alloc]init];
            self.miniArray = [self.matchesObject objectAtIndex:2];
            FBMatch *cellMatch = [self.miniArray objectAtIndex:indexPath.row+1];
            cell.FBMatch = cellMatch;
            return cell;
        }
        case 3:{
            cellFinal.winnerTeamLabel.text = @"CHAMPION";
            return cellFinal;
        }
        default:
            break;
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    } else if (section == 1){
        return 2;
    } else if (section == 2){
        return 1;
    } else {
        return 1;
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.matchesObject.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width/1.5, ((self.view.frame.size.height - 60)/5));
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        //self.view.frame.size.height/9
        return UIEdgeInsetsMake(0, 20, 0, 0);
        //return  UIEdgeInsetsMake((self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/9, 10, 0, 10);
    } else if (section == 1){
        return UIEdgeInsetsMake(((self.view.frame.size.height - 60)/5)/2+20, 50, 70, 10);
    } else if (section == 2){
        return UIEdgeInsetsMake((self.view.frame.size.height)/3, 50, 50, 10);
    } else {
        return UIEdgeInsetsMake((self.view.frame.size.height)/3, 50, 0, self.view.frame.size.width/4);
    }
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return ((self.view.frame.size.height - 60)/5);
    } else {
        return 1;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index path: %@", indexPath);
    NSLog(@"%@", self.matchA1B2.matchID);
   // [self performSegueWithIdentifier:@"TournamentToDetail" sender:self];
}
     
-(void) createDefaultPlayoffMatches{
         Firebase *ref = [[Firebase alloc]initWithUrl:@"https://fiery-inferno-5799.firebaseio.com/Playoff_Schedule"];
         // FireBase Listener
         [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
             self.matchA1B2.local = @"A1";
             self.matchA1B2.visitor = @"B2";
             NSLog(@"%@", snapshot.value);
             self.matchA1B2.schedule = [snapshot.value objectForKey:@"A1B2"];
             
             self.matchB1A2.local = @"B1";
             self.matchB1A2.visitor = @"A2";
             self.matchB1A2.schedule = [snapshot.value objectForKey:@"B1A2"];
             
             self.matchD1C2.local = @"D1";
             self.matchD1C2.visitor = @"C2";
             self.matchD1C2.schedule = [snapshot.value objectForKey:@"D1C2"];
              
             self.matchC1D2.local = @"C1";
             self.matchC1D2.visitor = @"D2";
             self.matchC1D2.schedule = [snapshot.value objectForKey:@"C1D2"];
              
             self.matchW25W27.local = @"W25";
             self.matchW25W27.visitor = @"W27";
             self.matchW25W27.schedule = [snapshot.value objectForKey:@"W25W27"];
              
             self.matchW26W28.local = @"W26";
             self.matchW26W28.visitor = @"W28";
             self.matchW26W28.schedule = [snapshot.value objectForKey:@"W26W28"];
              
             self.matchW29W30.local = @"W290";
             self.matchW29W30.visitor = @"W30";
             self.matchW29W30.schedule = [snapshot.value objectForKey:@"W29W30"];
             
             //not best way cause of the lag
             [self.collectionView reloadData];
         } withCancelBlock:^(NSError *error) {
              NSLog(@"%@", error.description);
         }];
}
//-(FBMatch *) createPlayOffMatch:(NSDictionary *)dictionary{
//    FBMatch *matchObject = [FBMatch new];
//    
//    matchObject.matchID = dictionary[@"id"];
//    //NSLog(@"local Team: %@", matchObject.matchID);
//    matchObject.local = dictionary[@"local"];
//    //NSLog(@"local Team: %@", matchObject.local);
//    matchObject.local_abbr = dictionary[@"local_abbr"];
//    //NSLog(@"local Team_abbr: %@", matchObject.local_abbr);
//    matchObject.local_goals = dictionary[@"local_goals"];
//    //NSLog(@"local Team goals: %@", matchObject.local_goals);
//    matchObject.pen1 = dictionary[@"pen1"];
//    //NSLog(@"local Team penalty: %@", matchObject.pen1);
//    
//    matchObject.visitor = dictionary[@"visitor"];
//    //NSLog(@"visitor Team: %@", matchObject.visitor);
//    matchObject.visitor_abbr = dictionary[@"visitor_abbr"];
//    //NSLog(@"visitor Team_abbr: %@", matchObject.visitor_abbr);
//    matchObject.visitor_goals = dictionary[@"visitor_goals"];
//    //NSLog(@"visitor Team goals: %@", matchObject.visitor_goals);
//    matchObject.pen2 = dictionary[@"pen2"];
//    //NSLog(@"visitor Team penalty: %@", matchObject.pen2);
//    
//    return matchObject;
//}
#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    GameVC *desVC = segue.destinationViewController;
//    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
//    NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
//    Match *cellMatch = [self.arrayOfPlayOffMatches objectAtIndex:indexPath];
//    desVC.match = cellMatch;
//    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
//    NSLog(@"%@", cellMatch);
}
@end