//
//  BracketCell.m
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 4/20/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "BracketCell.h"

@implementation BracketCell


//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
////        self.homeTeamLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/3, frame.size.height)];
////        self.homeTeamScore = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
////        self.homeTeamImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
////        
////      
////        
////        self.visitorTeamLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/3, frame.size.height)];
////        self.visitorTeamScore = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
////        self.visitorTeamImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
////        
////        
////        self.winnerTeamLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/3, frame.size.height)];
////        self.winnerTeamImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//    }
//    return self;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    //changing the fonts for the groupVC
    self.homeTeamLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.homeTeamScore.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.visitorTeamLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.visitorTeamScore.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.winnerTeamLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
}

//-(void)setMatch:(Match *)match{
//    //NSLog(@"Set match was called");
//    _match = match;
//    
//    //NSString *scoreString = match.score;
//    NSArray *seperatedScore = [match.score componentsSeparatedByString:@"-"];
//-(void)setFBMatch:(FBMatch *)FBMatch{
//    _FBMatch = FBMatch;
//  
//    //NSLog(@"%@", FBMatch.local_abbr);
//    self.homeTeamImageView.image = [UIImage imageNamed:FBMatch.local_abbr];
//    self.homeTeamLabel.text = FBMatch.local;
//    self.homeTeamPenalty.text = FBMatch.pen1;
//    if ([FBMatch.local_goals isEqualToString: @"x"]){
//        FBMatch.local_goals = @"";
//    }
//    self.homeTeamScore.text = FBMatch.local_goals;
//    
//    self.visitorTeamImageView.image = [UIImage imageNamed:FBMatch.visitor_abbr];
//    self.visitorTeamLabel.text = FBMatch.visitor;
//    self.visitorTeamPenalty.text = FBMatch.pen2;
//    if ([FBMatch.visitor_goals isEqualToString: @"x"]){
//        FBMatch.visitor_goals = @"";
//    }
//    self.visitorTeamScore.text = FBMatch.visitor_goals;
//}
@end

//NSString *scoreString = match.score;
//NSArray *seperatedScore = [match.score componentsSeparatedByString:@"-"];
//NSLog(@"THIS IS THE SCORE %@", seperatedScore[0]);
//self.homeTeamScore.text = seperatedScore[0];

//NSLog(@"THIS IS THE SCORE %@", seperatedScore[1]);
//self.visitorTeamScore.text = seperatedScore[1];
