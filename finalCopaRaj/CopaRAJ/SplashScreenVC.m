//
//  SplashScreenVC.m
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 5/4/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "SplashScreenVC.h"

@interface SplashScreenVC ()
@property (weak, nonatomic) IBOutlet UIImageView *logoAnimationImageView;

@end

@implementation SplashScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arrayOfLogoImages = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"LaunchScreen0.png"], [UIImage imageNamed:@"LaunchScreen1.png"], [UIImage imageNamed:@"LaunchScreen2.png"], [UIImage imageNamed:@"LaunchScreen3.png"], [UIImage imageNamed:@"LaunchScreen4.png"], [UIImage imageNamed:@"LaunchScreen5.png"], [UIImage imageNamed:@"LaunchScreen6.png"], [UIImage imageNamed:@"LaunchScreen7.png"], [UIImage imageNamed:@"LaunchScreen8.png"], [UIImage imageNamed:@"LaunchScreen9.png"], [UIImage imageNamed:@"LaunchScreen10.png"], [UIImage imageNamed:@"LaunchScreen11.png"], [UIImage imageNamed:@"LaunchScreen12.png"], [UIImage imageNamed:@"LaunchScreen13.png"], [UIImage imageNamed:@"LaunchScreen14.png"], [UIImage imageNamed:@"LaunchScreen15.png"], [UIImage imageNamed:@"LaunchScreen16.png"], [UIImage imageNamed:@"LaunchScreen17.png"], [UIImage imageNamed:@"LaunchScreen18.png"], [UIImage imageNamed:@"LaunchScreen19.png"], [UIImage imageNamed:@"LaunchScreen20.png"], [UIImage imageNamed:@"LaunchScreen21.png"], [UIImage imageNamed:@"LaunchScreen22.png"], [UIImage imageNamed:@"LaunchScreen23.png"], [UIImage imageNamed:@"LaunchScreen24.png"], [UIImage imageNamed:@"LaunchScreen23.png"], [UIImage imageNamed:@"LaunchScreen22.png"], [UIImage imageNamed:@"LaunchScreen21.png"], [UIImage imageNamed:@"LaunchScreen20.png"], [UIImage imageNamed:@"LaunchScreen19.png"], [UIImage imageNamed:@"LaunchScreen18.png"], [UIImage imageNamed:@"LaunchScreen17.png"], [UIImage imageNamed:@"LaunchScreen16.png"], [UIImage imageNamed:@"LaunchScreen15.png"], [UIImage imageNamed:@"LaunchScreen14.png"], [UIImage imageNamed:@"LaunchScreen13.png"], [UIImage imageNamed:@"LaunchScreen12.png"], [UIImage imageNamed:@"LaunchScreen11.png"], [UIImage imageNamed:@"LaunchScreen10.png"], [UIImage imageNamed:@"LaunchScreen9.png"], [UIImage imageNamed:@"LaunchScreen8.png"], [UIImage imageNamed:@"LaunchScreen7.png"], [UIImage imageNamed:@"LaunchScreen6.png"], [UIImage imageNamed:@"LaunchScreen5.png"], [UIImage imageNamed:@"LaunchScreen4.png"], [UIImage imageNamed:@"LaunchScreen3.png"], [UIImage imageNamed:@"LaunchScreen2.png"], [UIImage imageNamed:@"LaunchScreen1.png"], [UIImage imageNamed:@"LaunchScreen0.png"], nil];
    
    [self.logoAnimationImageView setAnimationImages:arrayOfLogoImages];
    [self.logoAnimationImageView setAnimationDuration:3];
    [self.logoAnimationImageView setAnimationRepeatCount:0];
    [self.logoAnimationImageView startAnimating];
    [self performSelector:@selector(goToMatches) withObject:nil afterDelay:3];
}

- (void)goToMatches {
    [self performSegueWithIdentifier:@"AnimationSegue" sender:self];
    [self.logoAnimationImageView stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

@end
