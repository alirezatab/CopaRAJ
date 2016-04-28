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

@interface TourneyVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@property NSManagedObjectContext *moc;
@property NSMutableArray *teams;
@property NSMutableArray *groups;
@property Team *team;
@property NSMutableArray *playoffTeams;
@property NSMutableArray *matchesData;
@property NSMutableArray *matchesObject;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tourneyButton;


@end

@implementation TourneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self.tourneyButton setTintColor:[UIColor redColor]];
    self.playoffTeams = [[NSMutableArray alloc]init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.moc = appDelegate.managedObjectContext;
    
    [self pullTeamsFromCoreData];
    [self pullGroupsFromCoreData];
    
    for (Group *group in self.groups) {
        [self conductJsonSearchForGroup:group];
    }
    NSLog(@"sqlite dir = \n%@", appDelegate.applicationDocumentsDirectory);
}

#pragma mark - CollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Cell for row was called");
    BracketCell *cell = (BracketCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    BracketCell *cellFinal = (BracketCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CellFinal" forIndexPath:indexPath];
    
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [[UIColor whiteColor]CGColor];
//    Match *cellMatch = [self.arrayOfPlayOffMatches objectAtIndex:indexPath.section];
//    cell.match = cellMatch;
//    return cell;
    switch (indexPath.section) {
        case 0:{
            Match *cellMatch = [self.arrayOfPlayOffMatches objectAtIndex:indexPath.row];
            cell.match = cellMatch;
                return cell;
        }
        case 1:{
            Match *cellMatch = [self.arrayOfPlayOffMatches objectAtIndex:indexPath.row+4];
            cell.match = cellMatch;
            return cell;
        }
        case 2:{
            Match *cellMatch = [self.arrayOfPlayOffMatches objectAtIndex:indexPath.row+7];
            cell.match = cellMatch;
            return cell;
        }
        case 3:{
            cellFinal.winnerTeamLabel.text = @"CHAMPION";
            return cellFinal;
        }
        default:
            break;
    }
//    for (int i = 0; i<3; i++) {
//        [self testLabelMatches:i withArrayIndex:0];
//        [self testLabelMatches:i withArrayIndex:1];
//    }
    
//    if (indexPath.section == 0) {
//        Match *match = [self.matchesObject objectAtIndex:indexPath.row];
//        cell.homeTeamLabel.text = match.localAbbr;
//        cell.homeTeamScore.text = match.score;
//        cell.homeTeamImageView.image = [UIImage imageNamed:match.localAbbr];
//        
//        cell.visitorTeamLabel.text = match.visitorAbbr;
//        cell.visitorTeamScore.text = match.score;
//        cell.visitorTeamImageView.image = [UIImage imageNamed:match.visitorAbbr];
//    } else if (indexPath.section == 1){
//        if (indexPath.row == 0) {
//            cell.homeTeamLabel.text = @"TBD";
//            cell.homeTeamScore.text = @"";
//            cell.visitorTeamLabel.text = @"TBD";
//            cell.visitorTeamScore.text = @"";
//        } else if (indexPath.row == 1){
//            cell.homeTeamLabel.text = @"TBD";
//            cell.homeTeamScore.text = @"";
//            cell.visitorTeamLabel.text = @"TBD";
//            cell.visitorTeamScore.text = @"";
//        }
//    } else if (indexPath.section == 2){
//        if (indexPath.row == 0) {
//            cell.homeTeamLabel.text = @"TBD";
//            cell.homeTeamScore.text = @"";
//            cell.visitorTeamLabel.text = @"TBD";
//            cell.visitorTeamScore.text = @"";
//        }
//    }
    
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
    return 4;
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
}

#pragma mark - Core Data
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
            //NSLog(@"The team from  Json is %@", team[@"team"]);
            [self updateTeamFromTeamArray:groupTeams WithLatestDictionary:team];
            //[self updateMatchsArray: <your match array> withDictionary:<jsonDictionaryforIndividualMatch>]
        }
//        NSError *saveError;
//        if ([self.moc save:&saveError]) {
//            NSLog(@"Teams updated");
//            [self.tableView reloadData];
//        } else {
//            NSLog(@"Team updates resulted in the following error: %@", saveError);
//        }
    }];
    [task resume];
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
    
    //NSLog(@"The team that will be updated is %@", teamForDictionary.countryName);
}

- (void)testLabelMatches:(int)index withArrayIndex:(int)newindex{
    Group *group = [self.groups objectAtIndex:index];
    NSLog(@"this is the new  %@", group);
    NSArray *sortedArray = [group returnGroupTeamsOrderedByPointsForGroup:group];
    Team *team = [sortedArray objectAtIndex:newindex];
    NSLog(@"this is the team %@", team.countryName);
    [self.playoffTeams addObject:team];
    NSLog(@"%@", team.abbreviationName);
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
//if (indexPath.section == 0) {
//    if (indexPath.row == 0) {
//        cell.homeTeamLabel.text = [self.playoffTeams objectAtIndex:0];
//        cell.homeTeamScore.text = @"";
//        cell.homeTeamImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.playoffTeams objectAtIndex:0]]];
//        cell.visitorTeamLabel.text = [self.playoffTeams objectAtIndex:3];
//        cell.visitorTeamScore.text = @"";
//    } else if (indexPath.row == 1){
//        cell.homeTeamLabel.text = @"1B";
//        cell.homeTeamScore.text = @"";
//        cell.visitorTeamLabel.text = @"2A";
//        cell.visitorTeamScore.text = @"";
//    } else if (indexPath.row == 2){
//        cell.homeTeamLabel.text = @"1D";
//        cell.homeTeamScore.text = @"";
//        cell.visitorTeamLabel.text = @"2C";
//        cell.visitorTeamScore.text = @"";
//    } else if (indexPath.row == 3){
//        cell.homeTeamLabel.text = @"1C";
//        cell.homeTeamScore.text = @"";
//        cell.visitorTeamLabel.text = @"2D";
//        cell.visitorTeamScore.text = @"";
//    }
//} else if (indexPath.section == 1){
//    if (indexPath.row == 0) {
//        cell.homeTeamLabel.text = @"TBD";
//        cell.homeTeamScore.text = @"";
//        cell.visitorTeamLabel.text = @"TBD";
//        cell.visitorTeamScore.text = @"";
//    } else if (indexPath.row == 1){
//        cell.homeTeamLabel.text = @"TBD";
//        cell.homeTeamScore.text = @"";
//        cell.visitorTeamLabel.text = @"TBD";
//        cell.visitorTeamScore.text = @"";
//    }
//} else if (indexPath.section == 2){
//    if (indexPath.row == 0) {
//        cell.homeTeamLabel.text = @"TBD";
//        cell.homeTeamScore.text = @"";
//        cell.visitorTeamLabel.text = @"TBD";
//        cell.visitorTeamScore.text = @"";
//    }
//} else if (indexPath.section == 3){
//    cellFinal.winnerTeamLabel.text = @"CHAMPION";
//}
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
