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
@property NSMutableArray *matchesData;
@property NSMutableArray *matchesObject;
@property NSMutableArray *playOffMatchesFromPlist;

@property FBMatch *matchA1B2;
@property FBMatch *matchB1A2;
@property FBMatch *matchD1C2;
@property FBMatch *matchC1D2;
@property FBMatch *matchW25W27;
@property FBMatch *matchW26W28;
@property FBMatch *matchL29L30;
@property FBMatch *matchW29W30;

//@property Match *match;
//@property Team *team;

@end

@implementation TourneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.playoffTeams = [[NSMutableArray alloc]init];
    self.matchesObject = [[NSMutableArray alloc]init];

    // URL that fire base accesses
    Firebase *ref = [[Firebase alloc]initWithUrl:@"https://fiery-inferno-5799.firebaseio.com/matches"];
    // FireBase Listener
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSDictionary *match1Dictionary = [snapshot.value objectForKey:@"347342"];
        NSDictionary *match2Dictionary = [snapshot.value objectForKey:@"347343"];
        NSDictionary *match3Dictionary = [snapshot.value objectForKey:@"347344"];
        NSDictionary *match4Dictionary = [snapshot.value objectForKey:@"347345"];
        NSDictionary *match5Dictionary = [snapshot.value objectForKey:@"347346"];
        NSDictionary *match6Dictionary = [snapshot.value objectForKey:@"347347"];
        NSDictionary *match7Dictionary = [snapshot.value objectForKey:@"347348"];
        NSDictionary *match8Dictionary = [snapshot.value objectForKey:@"347349"];
        
        //NSLog(@"Firebase match data: %@", matchDictionary);
        
        self.matchA1B2 = [self createPlayOffMatch:match1Dictionary];
        self.matchB1A2 = [self createPlayOffMatch:match2Dictionary];
        self.matchD1C2 = [self createPlayOffMatch:match3Dictionary];
        self.matchC1D2 = [self createPlayOffMatch:match4Dictionary];
        self.matchW25W27 = [self createPlayOffMatch:match5Dictionary];
        self.matchW26W28 = [self createPlayOffMatch:match6Dictionary];
        self.matchL29L30 = [self createPlayOffMatch:match7Dictionary];
        self.matchW29W30 = [self createPlayOffMatch:match8Dictionary];
        
        [self.matchesObject addObjectsFromArray:@[self.matchA1B2, self.matchB1A2, self.matchD1C2, self.matchC1D2, self.matchW25W27, self.matchW26W28, self.matchL29L30, self.matchW29W30]];
        
        [self.collectionView reloadData];
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

#pragma mark - CollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BracketCell *cell = (BracketCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    BracketCell *cellFinal = (BracketCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CellFinal" forIndexPath:indexPath];
    
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [[UIColor whiteColor]CGColor];

    switch (indexPath.section) {
        case 0:{
            FBMatch *cellMatch1 = self.matchA1B2;
            FBMatch *cellMatch2 = self.matchB1A2;
            FBMatch *cellMatch3 = self.matchD1C2;
            FBMatch *cellMatch4 = self.matchC1D2;
            
            cell.FBMatch = cellMatch1;
            cell.FBMatch = cellMatch2;
            cell.FBMatch = cellMatch3;
            cell.FBMatch = cellMatch4;
            return cell;
        }
        case 1:{
            FBMatch *cellMatch5 = self.matchW25W27;
            FBMatch *cellMatch6 = self.matchW26W28;
            cell.FBMatch = cellMatch5;
            cell.FBMatch = cellMatch6;
            return cell;
        }
        case 2:{
            FBMatch *cellMatch = [self.matchesObject objectAtIndex:indexPath.row+7];
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
    return self.matchesObject.count/2;
    
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
   // [self performSegueWithIdentifier:@"TournamentToDetail" sender:self];
}


-(FBMatch *) createPlayOffMatch:(NSDictionary *)dictionary{
    FBMatch *matchObject = [FBMatch new];
    
    matchObject.matchID = dictionary[@"id"];
    
    matchObject.local = dictionary[@"local"];
    //NSLog(@"local Team: %@", matchData1.local);
    matchObject.local_abbr = dictionary[@"local_abbr"];
    //NSLog(@"local Team_abbr: %@", matchObject.local_abbr);
    matchObject.local_goals = dictionary[@"local_goals"];
    //NSLog(@"local Team goals: %@", matchData1.local_goals);
    matchObject.pen1 = dictionary[@"pen1"];
    //NSLog(@"local Team penalty: %@", matchData1.pen1);
    
    matchObject.visitor = dictionary[@"visitor"];
    //NSLog(@"visitor Team: %@", matchData1.visitor);
    matchObject.visitor_abbr = dictionary[@"visitor_abbr"];
    //NSLog(@"visitor Team_abbr: %@", matchData1.visitor_abbr);
    matchObject.visitor_goals = dictionary[@"visitor_goals"];
    //NSLog(@"visitor Team goals: %@", matchData1.visitor_goals);
    matchObject.pen2 = dictionary[@"pen2"];
    //NSLog(@"visitor Team penalty: %@", matchData1.pen2);
    
    return matchObject;
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    self.moc = appDelegate.managedObjectContext;
//
//    [self pullTeamsFromCoreData];
//    [self pullGroupsFromCoreData];

//    for (Group *group in self.groups) {
//        [self conductJsonSearchForGroup:group];
//    }
//NSLog(@"sqlite dir = \n%@", appDelegate.applicationDocumentsDirectory);


//#pragma mark - Core Data
//- (void)pullTeamsFromCoreData {
//    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Team"];
//    NSError *error;
//    NSMutableArray *coreDataArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
//
//    if (error == nil) {
//        self.teams = [[NSMutableArray alloc]initWithArray:coreDataArray];
//    } else {
//        NSLog(@"%@", error);
//    }
//
//    if (self.teams.count == 0) {
//        NSLog(@"Core data doesn't have any teams");
//    }
//}
//
//- (void)pullGroupsFromCoreData {
//
//    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Group"];
//    NSError *error;
//    NSMutableArray *coreDataArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
//
//    if (error == nil) {
//        self.groups = [[NSMutableArray alloc]initWithArray:coreDataArray];
//    } else {
//        NSLog(@"%@", error);
//    }
//
//    if (self.groups.count == 0) {
//        NSLog(@"Core data doesn't have any Groups");
//    }
//}
//
//- (void) conductJsonSearchForGroup: (Group *)group {
//
//    NSMutableArray *groupTeams = [NSMutableArray new];
//    for (Team *team in group.teams) {
//        [groupTeams addObject:team];
//    }
//
//    NSString *searchVariable = [self returnGroupNameAsNumberForSearchFromName:group.groupID];
//
//    NSString *urlString = [NSString stringWithFormat:@"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=tables&format=json&tz=America/Chicago&lang=en&league=177&group=%@&year=2015", searchVariable];
//    NSURL *url = [NSURL URLWithString: urlString];
//    NSURLSession *session = [NSURLSession sharedSession];
//
//    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//        NSMutableArray *table = dictionary[@"table"];
//
//        for (NSDictionary *team in table) {
//            //NSLog(@"The team from  Json is %@", team[@"team"]);
//            [self updateTeamFromTeamArray:groupTeams WithLatestDictionary:team];
//            //[self updateMatchsArray: <your match array> withDictionary:<jsonDictionaryforIndividualMatch>]
//        }
////        NSError *saveError;
////        if ([self.moc save:&saveError]) {
////            NSLog(@"Teams updated");
////            [self.tableView reloadData];
////        } else {
////            NSLog(@"Team updates resulted in the following error: %@", saveError);
////        }
//    }];
//    [task resume];
//}
//
//-(NSString *)returnGroupNameAsNumberForSearchFromName: (NSString *)groupName{
//
//    NSString *groupNumber = @"";
//
//    if ([groupName  isEqualToString: @"A"]) {
//        groupNumber = @"1";
//    } else if ([groupName  isEqualToString: @"B"]){
//        groupNumber = @"2";
//    } else {
//        groupNumber = @"3";
//    }
//    return groupNumber;
//}
//
//- (void)updateTeamFromTeamArray:(NSMutableArray *)teams WithLatestDictionary:(NSDictionary *)dictionary {
//
//    NSString *teamNameFromDictionary = dictionary[@"team"];
//    Team *teamForDictionary;
//
//    for (Team *team in teams) {
//        if ([team.countryName isEqualToString:teamNameFromDictionary]) {
//            teamForDictionary = team;
//        }
//    }
//    teamForDictionary.wins = dictionary[@"wins"];
//    teamForDictionary.points = dictionary[@"points"];
//    teamForDictionary.losses = dictionary[@"losses"];
//    teamForDictionary.id = dictionary[@"id"];
//    teamForDictionary.goalsFor = dictionary[@"gf"];
//    teamForDictionary.goalsAgainst = dictionary[@"ga"];
//    teamForDictionary.gamesPlayed = dictionary[@"round"];
//    teamForDictionary.position = dictionary[@"pos"];
//    teamForDictionary.draws = dictionary[@"draws"];
//
//    //NSLog(@"The team that will be updated is %@", teamForDictionary.countryName);
//}
//- (void)testLabelMatches:(int)index withArrayIndex:(int)newindex{
//    Group *group = [self.groups objectAtIndex:index];
//    NSLog(@"this is the new  %@", group);
//    NSArray *sortedArray = [group returnGroupTeamsOrderedByPointsForGroup:group];
//    Team *team = [sortedArray objectAtIndex:newindex];
//    NSLog(@"this is the team %@", team.countryName);
//    [self.playoffTeams addObject:team];
//    NSLog(@"%@", team.abbreviationName);
//}


