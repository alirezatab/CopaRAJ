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
#import "GameVC.h"
#import "CopaRAJ-Swift.h"

@interface TourneyVC () <UICollectionViewDelegate, UICollectionViewDataSource, UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSManagedObjectContext *moc;
@property NSMutableArray *teams;
@property NSMutableArray *groups;
@property NSMutableArray *playoffTeams;
@property NSArray *sortedPlayoffTeams;
@property NSMutableArray *matchesData;
@property NSMutableArray *matchesObject;
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
@property double cellHeight;
@property double cellWidth;
@property double minimumInteritemSpacing;
@property int cellsForSection0;
@property int cellsForSection1;
@property int cellsForSection2;
@property CGFloat topInset;
@property CGFloat bottomInset;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeMatchesButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tourneyButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playOffMatchesButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *challengeButton;

@end


@implementation TourneyVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidesWhenStopped:true];
    
    self.topInset = 10;
    self.bottomInset = 10;
    
    self.cellsForSection0 = 4;
    self.cellsForSection1 = 2;
    self.cellsForSection2 = 1;
    
    self.navigationItem.hidesBackButton = YES;
    
    UIColor *unselectedButtonColor =  [UIColor colorWithWhite:0.606 alpha:1.000];
    
    [self.homeMatchesButton setImage: [UIImage imageNamed:NSLocalizedString(@"imageName", nil)]];
    [self.homeMatchesButton setTintColor:unselectedButtonColor];
    [self.tourneyButton setTintColor:unselectedButtonColor];
    [self.challengeButton setTintColor:unselectedButtonColor];
    [self.playOffMatchesButton setTintColor:[UIColor whiteColor]];
   
    
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
    
    [self.matchesObject addObjectsFromArray:@[@[self.matchA1B2, self.matchD1C2, self.matchB1A2, self.matchC1D2], @[self.matchW25W27, self.matchW26W28], @[self.matchL29L30, self.matchW29W30], @[]]];
    
    NSLog(@"%lu", (unsigned long)self.matchesObject.count);
}

#pragma mark - CollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    BracketCell *cell = (BracketCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    BracketCell *cellFinal = (BracketCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CellFinal" forIndexPath:indexPath];

    cell.layer.cornerRadius = 10.0;
    cell.contentView.layer.masksToBounds = YES;
    //cell.layer.borderWidth = 1.5;
    //cell.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    cellFinal.layer.cornerRadius = 10.0;
    cellFinal.contentView.layer.masksToBounds = YES;
    //cellFinal.layer.borderWidth = 1.5;
    //cellFinal.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    
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
        if ([self.matchW29W30.status isEqual: @1]) {
            NSInteger localScore = self.matchW29W30.local_goals.integerValue;
            NSInteger localPenalty = self.matchW29W30.pen1.integerValue;
            NSInteger visitorScore = self.matchW29W30.visitor_goals.integerValue;
            NSInteger visitorPenalty = self.matchW29W30.pen2.integerValue;
            
            if ((localScore > visitorScore) ||
                localPenalty > visitorPenalty) {
                cellFinal.winnerTeamLabel.text = self.matchW29W30.local;
                cellFinal.winnerTeamImageView.image = [UIImage imageNamed:self.matchW29W30.local];
                return cellFinal;
            } else {
                cellFinal.winnerTeamLabel.text = self.matchW29W30.visitor;
                cellFinal.winnerTeamImageView.image = [UIImage imageNamed:self.matchW29W30.visitor];
                return cellFinal;
            }
        } else {
            cellFinal.winnerTeamLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Tournament Champion", nil)];
            return cellFinal;
        }
    }
    default:
      break;
    }
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
    return self.cellsForSection0;
    } else if (section == 1){
    return self.cellsForSection1;
    } else if (section == 2){
    return self.cellsForSection2;
    } else {
    return self.cellsForSection2;
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.matchesObject.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    self.cellWidth = self.collectionView.frame.size.width/1.5;
    self.cellHeight = (self.collectionView.frame.size.height-self.topInset-self.bottomInset-60)/4;
    return CGSizeMake(self.cellWidth, self.cellHeight);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(self.topInset, 30, self.bottomInset, 0);
    } else if (section == 1){
        NSLog(@"%f", self.minimumInteritemSpacing);
        return UIEdgeInsetsMake((self.topInset+(self.cellHeight/2)+self.minimumInteritemSpacing), 50, self.bottomInset + self.cellHeight/2 + self.minimumInteritemSpacing, 0);
    } else if (section == 2){
        return UIEdgeInsetsMake(self.view.frame.size.height/3, 50, 50, 0);
    } else {
        return UIEdgeInsetsMake(self.view.frame.size.height/3, 50, 50, 50);
    }
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    if (section == 0) {
        NSLog(@"cell Height: %f", self.cellHeight);
        self.minimumInteritemSpacing = 10;
        return self.minimumInteritemSpacing;
    } else if (section == 1){
        self.minimumInteritemSpacing = self.cellHeight-50;
        return self.minimumInteritemSpacing;
    } else {
        self.minimumInteritemSpacing = 10;
        return self.minimumInteritemSpacing;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
  if (indexPath.section != 3 && indexPath.section != 2) {
    
    FBMatch *match = [[self.matchesObject objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self segueToMatchVCWithMatch:match];
    
  } else if (indexPath.section == 2){
    
    FBMatch *match = [[self.matchesObject objectAtIndex:indexPath.section] objectAtIndex:indexPath.row + 1];
    [self segueToMatchVCWithMatch:match];

    }
}
- (void)segueToMatchVCWithMatch: (FBMatch *)match{
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Game" bundle: [NSBundle mainBundle]];
  GameVC *viewController = (GameVC *)[storyboard instantiateViewControllerWithIdentifier:@"game"];
  viewController.match = match;
  self.navigationController.navigationBarHidden = false;
  [self.navigationController pushViewController:viewController animated:YES];
}

-(void) populatePlayoffTeams{
        Firebase *ref = [[Firebase alloc]initWithUrl:@"https://fiery-inferno-5799.firebaseio.com/matches"];
        [ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            NSNumber *isPlayoffsNum = snapshot.value[@"playoffs"];
            self.isPlayOff = isPlayoffsNum.boolValue;
            NSLog(@"%d", self.isPlayOff);
            NSMutableArray *playoffTeams = [NSMutableArray new];
            
            if (self.isPlayOff) {
                NSLog(@"%@", snapshot.value[@"schedule"]);
                NSLog(@"%@", self.matchA1B2.schedule);
                if ([self.matchA1B2.schedule isEqualToString: snapshot.value[@"schedule"]]) {
                    self.matchA1B2.matchID = snapshot.value[@"id"];
                    self.matchA1B2.status = snapshot.value[@"status"];
                    self.matchA1B2.stadium = snapshot.value[@"stadium"];

                    self.matchA1B2.local = snapshot.value[@"local"];
                    self.matchA1B2.local_abbr = snapshot.value[@"local_abbr"];
                    self.matchA1B2.local_goals = snapshot.value[@"local_goals"];
                    self.matchA1B2.pen1 = snapshot.value[@"pen1"];
                    
                    self.matchA1B2.visitor = snapshot.value[@"visitor"];
                    self.matchA1B2.visitor_abbr = snapshot.value[@"visitor_abbr"];
                    self.matchA1B2.visitor_goals = snapshot.value[@"visitor_goals"];
                    self.matchA1B2.pen2 = snapshot.value[@"pen2"];
               
                    
                } else if ([self.matchB1A2.schedule isEqualToString: snapshot.value[@"schedule"]]){
                    self.matchB1A2.matchID = snapshot.value[@"id"];
                    self.matchB1A2.status = snapshot.value[@"status"];
                    self.matchB1A2.stadium = snapshot.value[@"stadium"];

                    self.matchB1A2.local = snapshot.value[@"local"];
                    self.matchB1A2.local_abbr = snapshot.value[@"local_abbr"];
                    self.matchB1A2.local_goals = snapshot.value[@"local_goals"];
                    self.matchB1A2.pen1 = snapshot.value[@"pen1"];
                    
                    self.matchB1A2.visitor = snapshot.value[@"visitor"];
                    self.matchB1A2.visitor_abbr = snapshot.value[@"visitor_abbr"];
                    self.matchB1A2.visitor_goals = snapshot.value[@"visitor_goals"];
                    self.matchB1A2.pen2 = snapshot.value[@"pen2"];
             
                    
                } else if ([self.matchD1C2.schedule isEqualToString: snapshot.value[@"schedule"]]){
                    self.matchD1C2.matchID = snapshot.value[@"id"];
                    self.matchD1C2.status = snapshot.value[@"status"];
                    self.matchD1C2.stadium = snapshot.value[@"stadium"];
                    
                    self.matchD1C2.local = snapshot.value[@"local"];
                    self.matchD1C2.local_abbr = snapshot.value[@"local_abbr"];
                    self.matchD1C2.local_goals = snapshot.value[@"local_goals"];
                    self.matchD1C2.pen1 = snapshot.value[@"pen1"];
                    
                    self.matchD1C2.visitor = snapshot.value[@"visitor"];
                    self.matchD1C2.visitor_abbr = snapshot.value[@"visitor_abbr"];
                    self.matchD1C2.visitor_goals = snapshot.value[@"visitor_goals"];
                    self.matchD1C2.pen2 = snapshot.value[@"pen2"];
               
                    
                } else if ([self.matchC1D2.schedule isEqualToString: snapshot.value[@"schedule"]]){
                    self.matchC1D2.matchID = snapshot.value[@"id"];
                    self.matchC1D2.status = snapshot.value[@"status"];
                    self.matchC1D2.stadium = snapshot.value[@"stadium"];
                    
                    self.matchC1D2.local = snapshot.value[@"local"];
                    self.matchC1D2.local_abbr = snapshot.value[@"local_abbr"];
                    self.matchC1D2.local_goals = snapshot.value[@"local_goals"];
                    self.matchC1D2.pen1 = snapshot.value[@"pen1"];
                    
                    self.matchC1D2.visitor = snapshot.value[@"visitor"];
                    self.matchC1D2.visitor_abbr = snapshot.value[@"visitor_abbr"];
                    self.matchC1D2.visitor_goals = snapshot.value[@"visitor_goals"];
                    self.matchC1D2.pen2 = snapshot.value[@"pen2"];

                    
                } else if ([self.matchW25W27.schedule isEqualToString: snapshot.value[@"schedule"]]){
                    self.matchW25W27.matchID = snapshot.value[@"id"];
                    self.matchW25W27.status = snapshot.value[@"status"];
                    self.matchW25W27.stadium = snapshot.value[@"stadium"];
                    
                    self.matchW25W27.local = snapshot.value[@"local"];
                    self.matchW25W27.local_abbr = snapshot.value[@"local_abbr"];
                    self.matchW25W27.local_goals = snapshot.value[@"local_goals"];
                    self.matchW25W27.pen1 = snapshot.value[@"pen1"];
                    
                    self.matchW25W27.visitor = snapshot.value[@"visitor"];
                    self.matchW25W27.visitor_abbr = snapshot.value[@"visitor_abbr"];
                    self.matchW25W27.visitor_goals = snapshot.value[@"visitor_goals"];
                    self.matchW25W27.pen2 = snapshot.value[@"pen2"];
               
                
                } else if ([self.matchW26W28.schedule isEqualToString: snapshot.value[@"schedule"]]){
                    self.matchW26W28.matchID = snapshot.value[@"id"];
                    self.matchW26W28.status = snapshot.value[@"status"];
                    self.matchW26W28.stadium = snapshot.value[@"stadium"];
                    
                    self.matchW26W28.local = snapshot.value[@"local"];
                    self.matchW26W28.local_abbr = snapshot.value[@"local_abbr"];
                    self.matchW26W28.local_goals = snapshot.value[@"local_goals"];
                    self.matchW26W28.pen1 = snapshot.value[@"pen1"];
                    
                    self.matchW26W28.visitor = snapshot.value[@"visitor"];
                    self.matchW26W28.visitor_abbr = snapshot.value[@"visitor_abbr"];
                    self.matchW26W28.visitor_goals = snapshot.value[@"visitor_goals"];
                    self.matchW26W28.pen2 = snapshot.value[@"pen2"];
             
                
                } else if ([self.matchW29W30.schedule isEqualToString: snapshot.value[@"schedule"]]){
                    self.matchW29W30.matchID = snapshot.value[@"id"];
                    self.matchW29W30.status = snapshot.value[@"status"];
                    self.matchW29W30.stadium = snapshot.value[@"stadium"];
                    
                    self.matchW29W30.local = snapshot.value[@"local"];
                    self.matchW29W30.local_abbr = snapshot.value[@"local_abbr"];
                    self.matchW29W30.local_goals = snapshot.value[@"local_goals"];
                    self.matchW29W30.pen1 = snapshot.value[@"pen1"];
                    BOOL isStrig = [self.matchW29W30.pen1 isKindOfClass:[NSNumber class]];
                    NSLog(@"%d", isStrig);
                    NSLog(@"FireBase gave pen1: %@", self.matchW29W30.pen1);
                    
                    self.matchW29W30.visitor = snapshot.value[@"visitor"];
                    self.matchW29W30.visitor_abbr = snapshot.value[@"visitor_abbr"];
                    self.matchW29W30.visitor_goals = snapshot.value[@"visitor_goals"];
                    self.matchW29W30.pen2 = snapshot.value[@"pen2"];
                    BOOL strig = [self.matchW29W30.pen2 isKindOfClass:[NSNumber class]];
                    NSLog(@"%d", strig);
                    NSLog(@"FireBase gave pen2: %@", self.matchW29W30.pen2);
                }
              
                
                NSLog(@"%@", snapshot.value[@"id"]);
                [playoffTeams addObject:snapshot.value[@"id"]];
                NSLog(@"%lu", (unsigned long)self.playoffTeams.count);
                [self.collectionView reloadData];
              [self.activityIndicator stopAnimating];
            }
            
        } withCancelBlock:^(NSError *error) {
            NSLog(@"%@", error.description);
        }];
}

-(void) createDefaultPlayoffMatches{
    //dispatch_queue_t playoffReached = dispatch_queue_create("createDefaultTeams", NULL);
    //dispatch_async(playoffReached, ^{
    Firebase *ref = [[Firebase alloc]initWithUrl:@"https://fiery-inferno-5799.firebaseio.com/Playoff_Schedule"];
    // FireBase Listener
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
      
      self.matchA1B2.local = @"A1";
      self.matchA1B2.visitor = @"B2";
      self.matchA1B2.schedule = [snapshot.value objectForKey:@"A1B2"];
      self.matchA1B2.local_abbr = @"A1";
      self.matchA1B2.visitor_abbr = @"B2";
      self.matchA1B2.status = @"-1";
      self.matchA1B2.stadium = @"CenturyLink Field";
      [self addNSDateForMatch:self.matchA1B2];
      
      self.matchB1A2.local = @"B1";
      self.matchB1A2.visitor = @"A2";
      self.matchB1A2.schedule = [snapshot.value objectForKey:@"B1A2"];
      self.matchB1A2.local_abbr = @"B1";
      self.matchB1A2.visitor_abbr = @"A2";
      self.matchB1A2.stadium = @"MetLife Stadium";
      self.matchB1A2.status = @"-1";
      
      //NSLog(@"b1: %@ a2: %@ schedule: %@", self.matchB1A2.local, self.matchB1A2.visitor, self.matchB1A2.schedule);
      [self addNSDateForMatch:self.matchB1A2];
      
      self.matchD1C2.local = @"D1";
      self.matchD1C2.visitor = @"C2";
      self.matchD1C2.schedule = [snapshot.value objectForKey:@"D1C2"];
      self.matchD1C2.local_abbr = @"D1";
      self.matchD1C2.visitor_abbr = @"C2";
      self.matchD1C2.status = @"-1";
      self.matchD1C2.stadium = @"Gillette Stadium";
      [self addNSDateForMatch:self.matchD1C2];
      
      
      self.matchC1D2.local = @"C1";
      self.matchC1D2.visitor = @"D2";
      self.matchC1D2.schedule = [snapshot.value objectForKey:@"C1D2"];
      self.matchC1D2.local_abbr = @"C1";
      self.matchC1D2.visitor_abbr = @"D2";
      self.matchC1D2.status = @"-1";
      self.matchC1D2.stadium = @"Levi's Stadium";
      [self addNSDateForMatch:self.matchC1D2];
      
      
      self.matchW25W27.local = @"W25";
      self.matchW25W27.visitor = @"W27";
      self.matchW25W27.schedule = [snapshot.value objectForKey:@"W25W27"];
      self.matchW25W27.local_abbr = @"W25";
      self.matchW25W27.visitor_abbr = @"W27";
      self.matchW25W27.status = @"-1";
      self.matchW25W27.stadium = @"NRG Stadium";
      [self addNSDateForMatch:self.matchW25W27];
      
      
      self.matchW26W28.local = @"W26";
      self.matchW26W28.visitor = @"W28";
      self.matchW26W28.schedule = [snapshot.value objectForKey:@"W26W28"];
      self.matchW26W28.local_abbr = @"W26";
      self.matchW26W28.visitor_abbr = @"W28";
      self.matchW26W28.status = @"-1";
      self.matchW26W28.stadium =@"Soldier Field";
      [self addNSDateForMatch:self.matchW26W28];
      
      
      self.matchW29W30.local = @"W29";
      self.matchW29W30.visitor = @"W30";
      self.matchW29W30.schedule = [snapshot.value objectForKey:@"W29W30"];
      self.matchW29W30.local_abbr = @"W29";
      self.matchW29W30.visitor_abbr = @"W30";
      self.matchW29W30.status = @"-1";
      self.matchW29W30.stadium = @"MetLife Stadium";
      [self addNSDateForMatch:self.matchW29W30];
      //NSLog(@"%lu is the playoff match count", (unsigned long)self.playoffMatches.count);
      
      self.matchL29L30.local = @"L29";
      self.matchL29L30.visitor = @"L30";
      self.matchL29L30.schedule = [snapshot.value objectForKey:@"L29L30"];
      self.matchL29L30.local_abbr = @"L29";
      self.matchL29L30.visitor_abbr = @"L30";
      self.matchL29L30.status = @"-1";
      self.matchL29L30.stadium = @"University of Phoenix Stadium";
      [self addNSDateForMatch:self.matchL29L30];
      
      //not best way cause of the lag
        [self populatePlayoffTeams];
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    //});
}

- (void) addNSDateForMatch: (FBMatch *)match {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Madrid"];
    match.nsdate = [formatter dateFromString:match.schedule];
  
    NSDateFormatter *eastern = [[NSDateFormatter alloc]init];
    eastern.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    eastern.timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
    NSString *easternTime =  [eastern stringFromDate:match.nsdate];
    NSArray *scheduleSeparated = [easternTime componentsSeparatedByString:@" "];
    match.date = scheduleSeparated[0];
    NSString *time = scheduleSeparated[1];
    NSArray *timeSeparated = [time componentsSeparatedByString:@":"];
    match.hour = timeSeparated[0];
    match.minute = timeSeparated[1];
  
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

 #pragma mark - UnwindSegue
- (IBAction)prepareForUnwind:(UIStoryboard *)segue{
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

//- (IBAction)goToChallengeVC:(UIBarButtonItem *)sender {
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Challenge" bundle:nil];
//    ChallengeLogInVC *vc = [sb instantiateViewControllerWithIdentifier:@"Login"];
//    [self.navigationController pushViewController:vc animated:YES];
//}








@end