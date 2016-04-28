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
#import "GameVC.h"



@interface HomeVC ()<UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray *matchesData;
@property NSMutableArray *matchesObject;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSManagedObjectContext *moc;
@property NSMutableArray *teams;
@property Team *team;
@property NSMutableArray *groups;
@property NSMutableArray *playOffMatchesFromPlist;
@property NSMutableArray *playOffTeamsTest;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeButton;


@property NSArray *matchDatesWithNoDuplicates;
@property NSMutableArray *finalArray;
@property NSMutableArray *m0;
@property NSMutableArray *m1;
@property NSMutableArray *m2;
@property NSMutableArray *m3;
@property NSMutableArray *m4;
@property NSMutableArray *m5;
@property NSMutableArray *m6;
@property NSMutableArray *m7;
@property NSMutableArray *m8;
@property NSMutableArray *m9;
@property NSMutableArray *m10;
@property NSMutableArray *m11;
@property NSMutableArray *m12;
@property NSMutableArray *m13;
@property NSMutableArray *m14;
@property NSMutableArray *m15;
@property NSMutableArray *m16;
@property NSMutableArray *m17;
@property NSMutableArray *m18;

@property (weak, nonatomic) IBOutlet UIView *slideView;
@property (weak, nonatomic) IBOutlet UIImageView *sliderImage;



@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self navigationBarSetting];
    //color button toolbar
    [self.homeButton setTintColor:[UIColor whiteColor]];
    
 
    
    CGFloat f = (CGFloat)0;
    [UIView animateWithDuration:10.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect r = CGRectMake(f, f, self.sliderImage.frame.size.height, self.sliderImage.frame.size.width);
        CGRect r1 = CGRectMake(self.slideView.frame.size.width, f, self.sliderImage.frame.size.height, self.sliderImage.frame.size.width);
        [self.sliderImage setFrame:r];

        [self.sliderImage setFrame:r1];
    } completion:^(BOOL finished) {

    }];

    


    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    self.moc = appDelegate.managedObjectContext;
    self.matchesData = [NSMutableArray new];
    self.matchesObject = [NSMutableArray new];
    self.playOffTeamsTest = [NSMutableArray new];
    
    self.m0 = [NSMutableArray new];
    self.m1 = [NSMutableArray new];
    self.m2 = [NSMutableArray new];
    self.m3 = [NSMutableArray new];
    self.m4 = [NSMutableArray new];
    self.m5 = [NSMutableArray new];
    self.m6 = [NSMutableArray new];
    self.m7 = [NSMutableArray new];
    self.m8 = [NSMutableArray new];
    self.m9 = [NSMutableArray new];
    self.m10 = [NSMutableArray new];
    self.m11 = [NSMutableArray new];
    self.m12 = [NSMutableArray new];
    self.m13 = [NSMutableArray new];
    self.m14 = [NSMutableArray new];
    self.m15 = [NSMutableArray new];
    self.m16 = [NSMutableArray new];
    self.m17 = [NSMutableArray new];
    self.m18 = [NSMutableArray new];
    
    self.finalArray = [NSMutableArray new];
    
//check fonts available
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
    
    [self pullMatchesFromCoreData];
    
    [self getMatchesFromJsonAndSaveInCoreData];
    //I have to figure it out how to switch between this method
    
//    [self getPlayOffsFromJsonAndSaveInCoreData];
    
    //and this one
    [self getMatchesFromPlist];
    
    //based on the date of the match etc.
    ///////////////////////////////////////////////////
    [self storingDatesinAnArray];
    
    [self pullTeamsFromCoreData];
    
    [self pullGroupsFromCoreData];
    
    for (Group *group in self.groups){
        [self conductJsonSearchForGroup:group];
    }
    
    NSLog(@"sqlite dir = \n%@", appDelegate.applicationDocumentsDirectory);
    
}



- (void)navigationBarSetting {
    //////setup formatting
    
    //image
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"stadium"] forBarMetrics:UIBarMetricsDefault];
    
    //font color
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
 
    //set the appereance and font
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"GothamMedium" size:21.0], NSFontAttributeName, nil]];

}

- (UIStatusBarStyle)preferredStatusBar {
    return UIStatusBarStyleLightContent;
}

//user gets the matches from the API
- (void)getMatchesFromJsonAndSaveInCoreData {
    
    for (int i = 1; i< 4; i++) {
        
        NSString *urlBase = @"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=matchs&format=json&tz=America/Chicago&lang=en&league=177&group=all&round=";

       
        NSString *urlString = [NSString stringWithFormat:@"%@%i",urlBase, i];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
   
            NSMutableArray *matchesData = [NSMutableArray new];
            matchesData = dictionary[@"match"];
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
            NSMutableArray *sortedMatchesData = [NSMutableArray new];
            sortedMatchesData = [[matchesData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]mutableCopy];
            
            
            for (NSDictionary *matchData in sortedMatchesData) {
                [self updateMatchesWithMatchData: matchData];
            }
            NSError *mocError;
            if([self.moc save:&mocError]){
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


- (void)getPlayOffsFromJsonAndSaveInCoreData {
    
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
                NSLog(@"this was saved and there are %lu matches", (unsigned long)self.matchesObject.count);
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
    
    BOOL matchesAlreadyExist = [self checkIfMatchesAlreadyExist:dictionary];
    
    if(matchesAlreadyExist){
        [self updateExistingMatchWithDictionary: dictionary];
    } else {
        [self createNewMatch: dictionary];
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
    matchObject.localScore = dictionary[@"local_goals"];
    matchObject.visitorScore = dictionary[@"visitor_goals"];
    matchObject.penalties1 = [NSString stringWithFormat:@"%@", dictionary[@"penaltis1"]];
    matchObject.penalties2 = [NSString stringWithFormat:@"%@", dictionary[@"penaltis2"]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [dateFormat dateFromString:dictionary[@"date"]];
    matchObject.date = date;
    
    //testing
    matchObject.groupCode = dictionary[@"round"];
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
            matchingMatch.score = dictionary[@"result"];
            matchingMatch.hour = dictionary[@"hour"];
            matchingMatch.minute = dictionary[@"minute"];
            matchingMatch.localAbbr = dictionary[@"local_abbr"];
            matchingMatch.visitorAbbr = dictionary[@"visitor_abbr"];
            matchingMatch.matchId = dictionary[@"id"];
            matchingMatch.localTeam = dictionary[@"local"];
            matchingMatch.visitingTeam = dictionary[@"visitor"];
            matchingMatch.localScore = dictionary[@"local_goals"];
            matchingMatch.visitorScore = dictionary[@"visitor_goals"];
            matchingMatch.penalties1 = [NSString stringWithFormat:@"%@", dictionary[@"penaltis1"]];
            matchingMatch.penalties2 = [NSString stringWithFormat:@"%@", dictionary[@"penaltis2"]];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"yyyy/MM/dd"];
            NSDate *date = [dateFormat dateFromString:dictionary[@"date"]];
            matchingMatch.date = date;
            //testing
            matchingMatch.groupCode = dictionary[@"round"];
        }
    }
}

- (void)getMatchesFromPlist {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"playOffMatches" ofType:@"plist"];
    
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
                [self.matchesObject addObject:playOffMatch];
            }else{
                NSLog(@"an error has occurred,...%@", error);
            }
            
        }
    }
    NSLog(@"self.matchesObject.count : %lu", (unsigned long)self.matchesObject.count);
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



////////////////tableview stuff/////////////////////////////////////////


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.finalArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 32)];
    [label setFont:[UIFont fontWithName:@"GothamMedium" size:13]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor colorWithWhite:0.600 alpha:1.000]];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateStyle:NSDateFormatterFullStyle];
    
    NSDate *date = [self.matchDatesWithNoDuplicates  objectAtIndex:section];
    NSString *sectionTitle = [dateFormat stringFromDate:date];    /* Section header is in 0th index... */
    
    
    [label setText:sectionTitle];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithWhite:0.969 alpha:1.000]]; //your background
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections =[self.finalArray objectAtIndex:section];
    return sections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //arr its a array of matches sorted by dates
    NSArray *arr = [self.finalArray objectAtIndex:indexPath.section];
    
    Match *match = [arr objectAtIndex:indexPath.row];
    
    cell.teamOneName.text = match.localAbbr;
    cell.teamTwoName.text = match.visitorAbbr;
    cell.teamOneImage.image = [UIImage imageNamed:match.localTeam];
    cell.teamTwoImage.image = [UIImage imageNamed:match.visitingTeam];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ : %@", match.hour, match.minute];
    cell.teamOneScore.text = match.localScore;
    cell.teamTwoScore.text = match.visitorScore;
    cell.penaltiesLabel.text = [NSString stringWithFormat:@"(%@-%@)", match.penalties1, match.penalties2];
    

    //testing
    cell.locationLabel.text = [NSString stringWithFormat:@"Levi's Stadium %@",  match.groupCode];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TournamentSegue"]) {
        TourneyVC *desVC = segue.destinationViewController;
        for (int i = 24; i < 32; i++ ){
            [self.playOffTeamsTest addObject:self.matchesObject[i]];
        }
        desVC.arrayOfPlayOffMatches = self.playOffTeamsTest;
    } else if ([segue.identifier isEqualToString:@"GameSegue"]){
       // NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        //GameVC *desVC = segue.destinationViewController;
       // Match *match = [self.matchesObject objectAtIndex:indexPath.row];
        //desVC.match = match;
    }
}

- (void)storingDatesinAnArray {
    //storing all the dates in an array
    NSMutableArray *matchDates = [NSMutableArray new];
    
    for (Match *matchDate in self.matchesObject) {
        [matchDates addObject:matchDate.date];
    }
    //taking out duplicate dates
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:matchDates];
    self.matchDatesWithNoDuplicates = [orderedSet array];
    
    //dividing the matches by dates in separate arrays based on dates
    for (Match *match in self.matchesObject) {
        if ([match.date compare:self.matchDatesWithNoDuplicates[0]]  == NSOrderedSame){
            [self.m0 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[1]] == NSOrderedSame){
            [self.m1 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[2]] == NSOrderedSame){
            [self.m2 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[3]] == NSOrderedSame){
            [self.m3 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[4]] == NSOrderedSame){
            [self.m4 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[5]] == NSOrderedSame){
            [self.m5 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[6]] == NSOrderedSame){
            [self.m6 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[7]] == NSOrderedSame){
            [self.m7 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[8]] == NSOrderedSame){
            [self.m8 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[9]] == NSOrderedSame){
            [self.m9 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[10]] == NSOrderedSame){
            [self.m10 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[11]] == NSOrderedSame){
            [self.m11 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[12]] == NSOrderedSame){
            [self.m12 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[13]] == NSOrderedSame){
            [self.m13 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[14]] == NSOrderedSame){
            [self.m14 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[15]] == NSOrderedSame){
            [self.m15 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[16]] == NSOrderedSame){
            [self.m16 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[17]] == NSOrderedSame){
            [self.m17 addObject:match];
        }else if ([match.date compare:self.matchDatesWithNoDuplicates[18]] == NSOrderedSame){
            [self.m18 addObject:match];
        }
    }
    
    [self.finalArray addObject:self.m0];
    [self.finalArray addObject:self.m1];
    [self.finalArray addObject:self.m2];
    [self.finalArray addObject:self.m3];
    [self.finalArray addObject:self.m4];
    [self.finalArray addObject:self.m5];
    [self.finalArray addObject:self.m6];
    [self.finalArray addObject:self.m7];
    [self.finalArray addObject:self.m8];
    [self.finalArray addObject:self.m9];
    [self.finalArray addObject:self.m10];
    [self.finalArray addObject:self.m11];
    [self.finalArray addObject:self.m12];
    [self.finalArray addObject:self.m13];
    [self.finalArray addObject:self.m14];
    [self.finalArray addObject:self.m15];
    [self.finalArray addObject:self.m16];
    [self.finalArray addObject:self.m17];
    [self.finalArray addObject:self.m18];
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



- (void) conductJsonSearchForGroup: (Group *)group {
    NSMutableArray *groupTeams = [NSMutableArray new];
    for (Team *team in group.teams) {
        [groupTeams addObject:team];
    }
    
    NSString *searchVariable = [Group returnGroupNameAsNumberForSearchFromName:group.groupID];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.resultados-futbol.com/scripts/api/api.php?key=40b2f1fd2a56cbd88df8b2c9b291760f&req=tables&format=json&tz=America/Chicago&lang=en&league=177&group=%@&year=2015", searchVariable];
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





    























@end
