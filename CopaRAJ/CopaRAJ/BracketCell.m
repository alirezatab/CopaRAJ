//
//  BracketCell.m
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 4/20/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "BracketCell.h"

@implementation BracketCell

-(void)setFBMatch:(FBMatch *)FBMatch{
    _FBMatch = FBMatch;
    
    //NSLog(@"%@", FBMatch.local_abbr);
    self.homeTeamImageView.image = [UIImage imageNamed:FBMatch.local_abbr];
    self.homeTeamLabel.text = FBMatch.local;
    self.homeTeamPenalty.text = FBMatch.pen1;
    if ([FBMatch.local_goals isEqualToString: @"x"]){
        FBMatch.local_goals = @"";
    }
    self.homeTeamScore.text = FBMatch.local_goals;
    
    self.visitorTeamImageView.image = [UIImage imageNamed:FBMatch.visitor_abbr];
    self.visitorTeamLabel.text = FBMatch.visitor;
    self.visitorTeamPenalty.text = FBMatch.pen2;
    if ([FBMatch.visitor_goals isEqualToString: @"x"]){
        FBMatch.visitor_goals = @"";
    }
    self.visitorTeamScore.text = FBMatch.visitor_goals;
}
@end

//NSString *scoreString = match.score;
//NSArray *seperatedScore = [match.score componentsSeparatedByString:@"-"];
//NSLog(@"THIS IS THE SCORE %@", seperatedScore[0]);
//self.homeTeamScore.text = seperatedScore[0];

//NSLog(@"THIS IS THE SCORE %@", seperatedScore[1]);
//self.visitorTeamScore.text = seperatedScore[1];
