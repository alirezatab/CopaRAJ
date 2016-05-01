//
//  GameVC.h
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"
#import "FBMatch.h"

@interface GameVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *teamOneImage;
@property (weak, nonatomic) IBOutlet UILabel *teamOneName;
@property (weak, nonatomic) IBOutlet UILabel *versusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teamTwoImage;
@property (weak, nonatomic) IBOutlet UILabel *teamTwoName;
@property (weak, nonatomic) IBOutlet UILabel *teamTwoScore;
@property (weak, nonatomic) IBOutlet UILabel *teamOneScore;
@property (weak, nonatomic) IBOutlet UILabel *matchDateLabel;



//team A LineUp
@property (weak, nonatomic) IBOutlet UIImageView *teamAFlag;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer1;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer2;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer3;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer4;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer5;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer6;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer7;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer8;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer9;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer10;
@property (weak, nonatomic) IBOutlet UILabel *teamAPlayer11;

//teamB LineUp
@property (weak, nonatomic) IBOutlet UIImageView *teamBFlag;
@property (weak, nonatomic) IBOutlet UILabel *teamBPLayer1;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer2;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer3;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer4;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer5;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer6;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer7;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer8;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer9;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer10;
@property (weak, nonatomic) IBOutlet UILabel *teamBPlayer11;

//teamA stats
@property (weak, nonatomic) IBOutlet UIImageView *teamAStatsFlag;
@property (weak, nonatomic) IBOutlet UILabel *local_posLabel;
@property (weak, nonatomic) IBOutlet UILabel *local_sotLabel;
@property (weak, nonatomic) IBOutlet UILabel *local_sonLabel;
@property (weak, nonatomic) IBOutlet UILabel *local_soffLabel;
@property (weak, nonatomic) IBOutlet UILabel *local_frkLabel;
@property (weak, nonatomic) IBOutlet UILabel *local_blkLabel;
@property (weak, nonatomic) IBOutlet UILabel *local_ycLabel;
@property (weak, nonatomic) IBOutlet UILabel *local_rcLabel;

//teamB stats
@property (weak, nonatomic) IBOutlet UIImageView *teamBStatsFlag;
@property (weak, nonatomic) IBOutlet UILabel *visitor_posLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitor_sotLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitor_sonLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitor_soffLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitor_frkLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitor_blkSaves;
@property (weak, nonatomic) IBOutlet UILabel *visitor_ycLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitor_rcLabel;

//stats outlets
@property (weak, nonatomic) IBOutlet UILabel *posessionLabel;
@property (weak, nonatomic) IBOutlet UILabel *shotsLabel;
@property (weak, nonatomic) IBOutlet UILabel *shotsTargetLabel;
@property (weak, nonatomic) IBOutlet UILabel *offSideLabel;
@property (weak, nonatomic) IBOutlet UILabel *freeKickLabel;
@property (weak, nonatomic) IBOutlet UILabel *savesLabel;
@property (weak, nonatomic) IBOutlet UILabel *yellowCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *redCardLabel;



@property NSNumber *matchID;
@property FBMatch *match;
@end








