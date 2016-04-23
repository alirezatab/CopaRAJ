//
//  BracketCell.h
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 4/20/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"

@interface BracketCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *homeTeamImageView;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeTeamScore;

@property (weak, nonatomic) IBOutlet UIImageView *visitorTeamImageView;
@property (weak, nonatomic) IBOutlet UILabel *visitorTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitorTeamScore;

@property (weak, nonatomic) IBOutlet UIImageView *winnerTeamImageView;
@property (weak, nonatomic) IBOutlet UILabel *winnerTeamLabel;

@property (nonatomic, strong) Match *match;

@end
