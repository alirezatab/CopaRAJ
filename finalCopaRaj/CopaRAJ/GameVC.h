//
//  GameVC.h
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"

@interface GameVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *teamOneImage;
@property (weak, nonatomic) IBOutlet UILabel *teamOneName;
@property (weak, nonatomic) IBOutlet UILabel *teamOneScore;
@property (weak, nonatomic) IBOutlet UILabel *versusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teamTwoImage;
@property (weak, nonatomic) IBOutlet UILabel *teamTwoName;
@property (weak, nonatomic) IBOutlet UILabel *teamTwoScore;
@property NSNumber *matchID;
@end