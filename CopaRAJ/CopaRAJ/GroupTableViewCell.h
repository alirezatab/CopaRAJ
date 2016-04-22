//
//  GroupTableViewCell.h
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface GroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *teamImage;
@property (weak, nonatomic) IBOutlet UILabel *teamCountry;
@property (weak, nonatomic) IBOutlet UILabel *teamGoals;
@property (weak, nonatomic) IBOutlet UILabel *teamWins;
@property (weak, nonatomic) IBOutlet UILabel *teamTies;
@property (weak, nonatomic) IBOutlet UILabel *teamLosses;
@property (weak, nonatomic) IBOutlet UILabel *teamPoints;
@property (nonatomic, strong) Team *team;


@end
