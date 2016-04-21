//
//  BracketCell.h
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 4/20/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BracketCell : UICollectionViewCell

@property (retain, nonatomic) IBOutlet UIImageView *homeTeamImageView;
@property (retain, nonatomic) IBOutlet UILabel *homeTeamLabel;
@property (retain, nonatomic) IBOutlet UILabel *homeTeamScore;

@property (retain, nonatomic) IBOutlet UIImageView *visitorTeamImageView;
@property (retain, nonatomic) IBOutlet UILabel *visitorTeamLabel;
@property (retain, nonatomic) IBOutlet UILabel *visitorTeamScore;

@property (retain, nonatomic) IBOutlet UIImageView *winnerTeamImageView;
@property (retain, nonatomic) IBOutlet UILabel *winnerTeamLabel;



@end
