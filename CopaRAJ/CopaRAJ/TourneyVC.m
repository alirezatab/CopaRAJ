//
//  TourneyVC.m
//  CopaRAJ
//
//  Created by Richard Velazquez on 4/18/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

#import "TourneyVC.h"
#import "BracketCell.h"

@interface TourneyVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation TourneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - CollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BracketCell *cell = (BracketCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    BracketCell *cellFinal = (BracketCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CellFinal" forIndexPath:indexPath];
    
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [[UIColor whiteColor]CGColor];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.homeTeamLabel.text = @"1A";
            cell.homeTeamScore.text = @"";
            cell.visitorTeamLabel.text = @"2B";
            cell.visitorTeamScore.text = @"";
        } else if (indexPath.row == 1){
            cell.homeTeamLabel.text = @"1B";
            cell.homeTeamScore.text = @"";
            cell.visitorTeamLabel.text = @"2A";
            cell.visitorTeamScore.text = @"";
        } else if (indexPath.row == 2){
            cell.homeTeamLabel.text = @"1D";
            cell.homeTeamScore.text = @"";
            cell.visitorTeamLabel.text = @"2C";
            cell.visitorTeamScore.text = @"";
        } else if (indexPath.row == 3){
            cell.homeTeamLabel.text = @"1C";
            cell.homeTeamScore.text = @"";
            cell.visitorTeamLabel.text = @"2D";
            cell.visitorTeamScore.text = @"";
        }
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.homeTeamLabel.text = @"TBD";
            cell.homeTeamScore.text = @"";
            cell.visitorTeamLabel.text = @"TBD";
            cell.visitorTeamScore.text = @"";
        } else if (indexPath.row == 1){
            cell.homeTeamLabel.text = @"TBD";
            cell.homeTeamScore.text = @"";
            cell.visitorTeamLabel.text = @"TBD";
            cell.visitorTeamScore.text = @"";
        }
    } else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.homeTeamLabel.text = @"TBD";
            cell.homeTeamScore.text = @"";
            cell.visitorTeamLabel.text = @"TBD";
            cell.visitorTeamScore.text = @"";
        }
    } else if (indexPath.section == 3){
        cellFinal.winnerTeamLabel.text = @"CHAMPION";
    }

    if (indexPath.section == 3) {
        return cellFinal;
    } else{
        return cell;
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    } else if (section == 1){
        return 2;
    } else if (section == 2){
        return 1;
    } else {
        return 1;
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //inse
    return CGSizeMake(self.view.frame.size.width/1.5, ((self.view.frame.size.height - 60)/5));
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (section == 0) {
        //self.view.frame.size.height/9
        return UIEdgeInsetsMake(0, 20, 0, 0);
        //return  UIEdgeInsetsMake((self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/9, 10, 0, 10);
    } else if (section == 1){
        return UIEdgeInsetsMake(((self.view.frame.size.height - 60)/5)/2+20, 50, 70, 10);
    } else if (section == 2){
        return UIEdgeInsetsMake((self.view.frame.size.height)/3, 50, 50, 10);
    } else {
        return UIEdgeInsetsMake((self.view.frame.size.height)/3, 50, 0, self.view.frame.size.width/4);
    }
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return ((self.view.frame.size.height - 60)/5);
    } else {
        return 1;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index path: %@", indexPath);
}

#pragma mark - Json
-(void) getPlayOffMatchesFromJson{
    
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
