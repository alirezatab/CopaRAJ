//
//  BracketCell.m
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 4/20/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "BracketCell.h"

@implementation BracketCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.homeTeamLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/3, frame.size.height)];
        self.homeTeamScore = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.homeTeamImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
      
        
        self.visitorTeamLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/3, frame.size.height)];
        self.visitorTeamScore = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.visitorTeamImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        
        self.winnerTeamLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/3, frame.size.height)];
        self.winnerTeamImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    }
    return self;
}

@end
