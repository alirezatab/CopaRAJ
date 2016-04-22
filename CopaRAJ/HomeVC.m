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


@interface HomeVC ()<UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray *matchesData;
@property NSMutableArray *matchesObject;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;
@property NSMutableArray *teams;
@property Team *team;


@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;
    self.matchesData = [NSMutableArray new];
    self.matchesObject = [NSMutableArray new];
    
    [self pullMatchesFromCoreData];
    
    [self getMatchesFromJsonAndSaveInCoreData];
    
    [self pullTeamsFromCoreData];
    if (self.teams.count == 0) {
        [self createTournamentTeams];
    }
    
    NSLog(@"sqlite dir = \n%@", appDelegate.applicationDocumentsDirectory);
}

//user gets the matches from the API
- (void)getMatchesFromJsonAndSaveInCoreData {
    
    for (int i = 1; i< 4; i++) {
        
        NSString *urlBase = @"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=matchs&format=json&tz=America/Chicago&lang=en&league=177&round=";
       
        NSString *urlString = [NSString stringWithFormat:@"%@%i",urlBase, i];
        
//        NSString *urlString = [NSString stringWithFormat:@"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=matchs&format=json&tz=America/Chicago&lang=en&league=177&round=%i",i];
        

        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSString *url = response.URL.absoluteString;
            int index = [url characterAtIndex:urlBase.length] - '0';
            NSLog(@"index %i from %@", index, url);
            
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            NSMutableArray *matchesData = [NSMutableArray new];
            matchesData = dictionary[@"match"];
            
            for (NSDictionary *matchData in matchesData) {
                
                [self updateMatchesWithMatchData: matchData];
            }
            
            [self pullTeamsFromCoreData];
            
            NSError *mocError;
            if([self.moc save:&mocError]){
                NSLog(@"this was saved and there are %lu", (unsigned long)self.matchesObject.count);
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
    matchObject.score = dictionary[@"score"];
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
    
    [matchObject addTeamsObject:self.team];
    
    [self.matchesObject addObject:matchObject];
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
            matchingMatch.score = dictionary[@"score"];
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
}


- (void)pullMatchesFromCoreData {
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Match"];
    
    NSError *error;
    
    NSMutableArray *coreDataArray = [NSMutableArray new];
    coreDataArray = [[self.moc executeFetchRequest:request error:&error]mutableCopy];
    
    if(error == nil){
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        self.matchesObject = [[coreDataArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
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
      
        
        index++;

        [self.teams addObject:self.team];
    }
    
    NSError *error;
    if ([self.moc save:&error]) {
        NSLog(@"teams was saved to coredata");
    } else {
        NSLog(@"failed because %@", error);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshData:(UIBarButtonItem *)sender {
    [self getMatchesFromJsonAndSaveInCoreData];
    NSLog(@"the data is updated");
}




@end
