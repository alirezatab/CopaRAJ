//
//  BracketCell.m
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 4/20/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "BracketCell.h"

@implementation BracketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //changing the fonts for the groupVC
    self.homeTeamLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.homeTeamScore.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.homeTeamPenalty.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:11];
    
    self.visitorTeamLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.visitorTeamScore.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:16];
    self.visitorTeamPenalty.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:11];
    
    self.winnerTeamLabel.font = [UIFont fontWithName:@"GOTHAM MEDIUM" size:14];
}

-(void)setFBMatch:(FBMatch *)FBMatch{
    _FBMatch = FBMatch;
  
    //NSLog(@"%@", FBMatch.local_abbr);
    self.homeTeamImageView.image = [UIImage imageNamed:FBMatch.local];
    self.homeTeamLabel.text = FBMatch.local;
    
    self.visitorTeamImageView.image = [UIImage imageNamed:FBMatch.visitor];
    self.visitorTeamLabel.text = FBMatch.visitor;
    
    if ([FBMatch.status isEqual:@1]) {
        if (FBMatch.pen1 == [NSNumber numberWithInteger:0] && FBMatch.pen2 == [NSNumber numberWithInteger:0] ) {
            self.homeTeamPenalty.enabled = NO;
            self.homeTeamPenalty.hidden = YES;
            self.visitorTeamPenalty.enabled = NO;
            self.visitorTeamPenalty.hidden = YES;
        } else {
            self.homeTeamPenalty.enabled = YES;
            self.homeTeamPenalty.hidden = NO;
            self.homeTeamPenalty.text = [NSString stringWithFormat:@"P%@", FBMatch.pen1];
            
            self.visitorTeamPenalty.enabled = YES;
            self.visitorTeamPenalty.hidden = NO;
            self.visitorTeamPenalty.text = [NSString stringWithFormat:@"P%@", FBMatch.pen2];
        }
    } else {
        self.homeTeamPenalty.enabled = NO;
        self.homeTeamPenalty.hidden = YES;
        
        self.visitorTeamPenalty.enabled = NO;
        self.visitorTeamPenalty.hidden = YES;
    }
    if ([FBMatch.local_goals isEqualToString: @"x"]){
        FBMatch.local_goals = @"";
    } else {
        self.homeTeamScore.text = FBMatch.local_goals;
    }
    
    if ([FBMatch.visitor_goals isEqualToString: @"x"]){
        FBMatch.visitor_goals = @"";
    } else {
        self.visitorTeamScore.text = FBMatch.visitor_goals;
    }
}
@end