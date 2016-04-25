//
//  HomeVC.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "HomeVC.h"
#import "HomeTableViewCell.h"
#import "Match.h"
#import "AppDelegate.h"
#import "Team.h"
#import "TourneyVC.h"
#import "Group.h"
#import "TourneyVC.h"

@interface HomeVC ()<UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray *matchesData;
@property NSMutableArray *matchesObject;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;
@property NSMutableArray *teams;
@property Team *team;
@property NSMutableArray *groups;
@property NSMutableArray *playOffMatchesFromPlist;
@property NSMutableArray *playOffMatches;

@property NSMutableArray *playOffTeamsTest;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;

    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;
    self.matchesData = [NSMutableArray new];
    self.matchesObject = [NSMutableArray new];
    self.playOffMatches = [NSMutableArray new];
    
    self.playOffTeamsTest = [NSMutableArray new];
    
    
    [self pullMatchesFromCoreData];
    
    [self getMatchesFromJsonAndSaveInCoreData];
    
    
    //I have to figure it out how to switch between this method
    
//    [self getPlayOffsFromJsonAndSaveInCoreData];
    
    //and this one
    [self getMatchesFromPlist];
    
    //based on the date of the match etc.
    
    ///////////////////////////////////////////////////
    
    [self pullTeamsFromCoreData];
    
    [self pullGroupsFromCoreData];
    
    for (Group *group in self.groups){
        [self conductJsonSearchForGroup:group];
    }
    
//    [self firstGroup:0 withFirstTeam:0 secondGroup:1 withSecondTeam:1];

//    NSLog(@"there are %lu groups", self.groups.count);
    
    NSLog(@"sqlite dir = \n%@", appDelegate.applicationDocumentsDirectory);
  
  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

//user gets the matches from the API
- (void)getMatchesFromJsonAndSaveInCoreData {
    
    for (int i = 1; i< 4; i++) {
        
        NSString *urlBase = @"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=matchs&format=json&tz=America/Chicago&lang=en&league=177&round=";
       
        NSString *urlString = [NSString stringWithFormat:@"%@%i",urlBase, i];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSMutableArray *matchesData = [NSMutableArray new];
            matchesData = dictionary[@"match"];
            
            for (NSDictionary *matchData in matchesData) {
                [self updateMatchesWithMatchData: matchData];
            }
            NSError *mocError;
            if([self.moc save:&mocError]){
//                NSLog(@"this was saved and there are %lu", (unsigned long)self.matchesObject.count);
            }else{
                NSLog(@"an error has occurred,...%@", error);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [self.tableView reloadData];
            });
        }];
        [task resume];
    }
}

- (void)updateMatchesWithMatchData:(NSDictionary *)dictionary {
    
    BOOL matchesExist = [self checkIfMatchesExist];
    
    if(!matchesExist){
        [self createNewMatch:dictionary];
    } else if ([self checkIfMatchesAlreadyExist: dictionary]) {
        [self updateExistingMatchWithDictionary: dictionary];
    } else {
        [self createNewMatch: dictionary];
    }
}

- (BOOL) checkIfMatchesExist {
    if (self.matchesObject.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)createNewMatch:(NSDictionary *)dictionary {
    
    Match *matchObject = [NSEntityDescription insertNewObjectForEntityForName:@"Match" inManagedObjectContext:self.moc];
    matchObject.score = dictionary[@"result"];
    matchObject.matchId = dictionary[@"id"];
    matchObject.hour = dictionary[@"hour"];
    matchObject.minute = dictionary[@"minute"];
    matchObject.localAbbr = dictionary[@"local_abbr"];
    matchObject.visitorAbbr = dictionary[@"visitor_abbr"];
    matchObject.localTeam = dictionary[@"local"];
    matchObject.visitingTeam = dictionary[@"visitor"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [dateFormat dateFromString:dictionary[@"date"]];
    matchObject.date = date;
    
    //testing
    matchObject.groupCode = dictionary[@"round"];
        
    [self.matchesObject addObject:matchObject];
    
//    NSLog(@"self.matchesObject.count : %lu in the create method ", self.matchesObject.count);

}


- (BOOL) checkIfMatchesAlreadyExist:(NSDictionary *)dictionary {
    NSMutableArray *matchIds = [NSMutableArray new];
    
    for (Match *match in self.matchesObject) {
        [matchIds addObject:match.matchId];
    }
    
    NSString *dictionaryMatchId = dictionary[@"id"];
    
    if ([matchIds containsObject:dictionaryMatchId]) {
        return YES;
    } else {
        return NO;
    }
    
}

- (void)updateExistingMatchWithDictionary:(NSDictionary *)dictionary {
    
    for (Match *match in self.matchesObject) {
        if([match.matchId isEqualToString:dictionary[@"id"]]) {
            
            Match *matchingMatch = match;
            matchingMatch.score = dictionary[@"result"];
            matchingMatch.hour = dictionary[@"hour"];
            matchingMatch.minute = dictionary[@"minute"];
            matchingMatch.localAbbr = dictionary[@"local_abbr"];
            matchingMatch.visitorAbbr = dictionary[@"visitor_abbr"];
            matchingMatch.matchId = dictionary[@"id"];
            matchingMatch.localTeam = dictionary[@"local"];
            matchingMatch.visitingTeam = dictionary[@"visitor"];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSDate *date = [dateFormat dateFromString:dictionary[@"date"]];
            matchingMatch.date = date;
            //testing
            matchingMatch.groupCode = dictionary[@"round"];
            
        }
    }
//    NSLog(@"self.matchesObject.count : %lu in the update method ", self.matchesObject.count);

}


- (void)pullMatchesFromCoreData {
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Match"];
    NSError *error;
    NSMutableArray *coreDataArray = [NSMutableArray new];
    coreDataArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
    
    if(error == nil){
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        NSMutableArray *arr = [NSMutableArray new];
        arr = [[coreDataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
        [self.matchesObject addObjectsFromArray:arr];
        [self.tableView reloadData];

    }else{
        NSLog(@"Error: %@", error);
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchesObject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Match *match = [self.matchesObject objectAtIndex:indexPath.row];
    cell.teamOneName.text = match.localAbbr;
    cell.teamTwoName.text = match.visitorAbbr;
    cell.teamOneImage.image = [UIImage imageNamed:match.localAbbr];
    cell.teamTwoImage.image = [UIImage imageNamed:match.visitorAbbr];
    
    //testing
    cell.locationLabel.text = match.groupCode;
    

    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
        [self createTournamentTeams];
    }
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

- (void)pullGroupsFromCoreData {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Group"];
    
    NSError *error;
    NSMutableArray *coreDataArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
    
    if (error == nil) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"groupID" ascending:YES];
        self.groups = [[coreDataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
    } else {
        NSLog(@"%@", error);
    }
    if (self.groups.count == 0) {
        NSLog(@"Core data doesn't have any groups");
        [self setupDefaultGroups];
    }
}

- (void)setupDefaultGroups {
    [self createGroups];
    [self assignTeamsToGroups];
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
//        NSLog(@"Groups and their relationships to teams should be saved in Core Data");
    } else {
        NSLog(@"failed because %@", error);
    }
    
}

- (void)createTournamentTeams {
    
    NSArray *teamsIntournament = @[@"Argentina", @"Bolivia", @"Brazil", @"Chile", @"Colombia", @"Costa Rica", @"Ecuador", @"Haiti", @"Jamaica", @"Mexico", @"Panama", @"Paraguay", @"Peru", @"Uruguay", @"USA", @"Venezuela"];
    
    NSArray *teamAbbrevs = @[@"ARG", @"BOL", @"BRA", @"CHI", @"COL", @"CRC", @"ECU", @"HAI", @"JAM", @"MEX", @"PAN", @"PAR", @"PER", @"URU", @"USA", @"VEN"];
    
    self.teams = [NSMutableArray new];
    int index = 0;
    for (NSString *teamName in teamsIntournament) {
        NSString *abr = [teamAbbrevs objectAtIndex:index];
      
        self.team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:self.moc];

        self.team.abbreviationName = abr;
        
        [self.team createDefaultTeamSettingsForTeam:self.team andName:teamName];
        self.team.flagImageName = self.team.abbreviationName;
        self.team.flagImageName = self.team.abbreviationName;
        index++;

        [self.teams addObject:self.team];
    }
    
    NSError *error;
    if ([self.moc save:&error]) {
//        NSLog(@"teams was saved to coredata");
    } else {
        NSLog(@"failed because %@", error);
    }
}

- (IBAction)refreshData:(UIBarButtonItem *)sender {
    [self getMatchesFromJsonAndSaveInCoreData];
    NSLog(@"the data is updated");
}

- (void)getPlayOffsFromJsonAndSaveInCoreData {
    
    for (int i = 1; i< 4; i++) {
        
        NSString *urlBase = @"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=matchs&format=json&tz=America/Chicago&lang=en&year=2015&league=177&round=";
        
        NSString *urlString = [NSString stringWithFormat:@"%@%i",urlBase, i];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            NSMutableArray *matchesData = [NSMutableArray new];
            matchesData = dictionary[@"match"];
            
            for (NSDictionary *matchData in matchesData) {
                
                [self updateMatchesWithMatchData: matchData];
            }
            NSError *mocError;
            if([self.moc save:&mocError]){
                NSLog(@"this was saved and there are %lu matches", self.matchesObject.count);
            }else{
                NSLog(@"an error has occurred,...%@", error);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [self.tableView reloadData];
            });
        }];
        [task resume];
    }
}

- (void) conductJsonSearchForGroup: (Group *)group {
    NSMutableArray *groupTeams = [NSMutableArray new];
    for (Team *team in group.teams) {
        [groupTeams addObject:team];
    }
    
    NSString *groupID = [Group returnGroupNameAsNumberForSearchFromName:group.groupID];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=tables&format=json&tz=America/Chicago&lang=en&league=177&group=%@&year=2015", groupID];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSMutableArray *table = dictionary[@"table"];
        
        for (NSDictionary *team in table) {
//            NSLog(@"The team from  Json is %@", team[@"team"]);
            [self updateTeamFromTeamArray:groupTeams WithLatestDictionary:team];
        }

        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            NSError *saveError;
            if ([self.moc save:&saveError]) {
                NSLog(@"Teams updated");
                [self.tableView reloadData];
            } else {
                NSLog(@"Team updates resulted in the following error: %@", saveError);
            }
        });
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
}

- (void)getMatchesFromPlist {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"playOffMatches" ofType:@"plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"The file exists");
    } else {
        NSLog(@"The file does not exist");
    }
    
    self.playOffMatchesFromPlist = [[[NSArray alloc] initWithContentsOfFile:path]mutableCopy];
    
    for (NSDictionary *match in self.playOffMatchesFromPlist) {
        
        if (![self checkIfMatchesAlreadyExist:match]){
            Match *playOffMatch = [NSEntityDescription insertNewObjectForEntityForName:@"Match" inManagedObjectContext:self.moc];
            playOffMatch.matchId = [match valueForKey:@"id"];
            playOffMatch.localAbbr = [match valueForKey:@"local"];
            NSLog(@"%@ is p list local team", playOffMatch.localAbbr);
            playOffMatch.visitorAbbr = [match valueForKey:@"visitor"];
            playOffMatch.location = [match valueForKey:@"location"];
            playOffMatch.hour = [match valueForKey:@"time"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSDate *date = [dateFormat dateFromString:[match valueForKey:@"date"]];
            playOffMatch.date = date;
            
            NSError *error;
            
            if([self.moc save:&error]){
                NSLog(@"HI");
                [self.playOffMatches addObject:playOffMatch];
            }else{
                NSLog(@"an error has occurred,...%@", error);
            }
            
        }
    }
    
    [self.matchesObject addObjectsFromArray:self.playOffMatches];
    
    NSLog(@"self.playOfmatches.count : %lu", self.playOffMatches.count);
    NSLog(@"self.matchesObject.count : %lu", self.matchesObject.count);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TournamentSegue"]) {
        TourneyVC *desVC = segue.destinationViewController;
        for (int i = 24; i < 32; i++ ){
            [self.playOffTeamsTest addObject:self.matchesObject[i]];
        }
      
        NSLog(@"%lu", (unsigned long)self.playOffTeamsTest.count);
        for (Match *match in self.playOffTeamsTest) {
            NSLog(@"%@  against %@", [match valueForKey:@"localAbbr"] , [match valueForKey:@"visitorAbbr"]);
        }
        
        desVC.arrayOfPlayOffMatches = self.playOffTeamsTest;
        //self.playOffMatches;
    }
}


//for Ricky for later. This is the early stages of the auto scroll animation
//dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//  NSLog(@"row 2");
//  [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//  
//  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    NSLog(@"row 3");
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//      NSLog(@"row 4");
//      [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//      
//      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"row 5");
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//      });
//      
//    });
//  });
//  
//});

















@end
