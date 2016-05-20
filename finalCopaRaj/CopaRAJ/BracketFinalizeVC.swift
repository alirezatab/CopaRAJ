//
//  BracketFinalizeVC.swift
//  CopaRAJ
//
//  Created by ALIREZA TABRIZI on 5/20/16.
//  Copyright © 2016 AR-T.com, Inc. All rights reserved.
//

import UIKit

class BracketFinalizeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var BrackeChallangeCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: CollectionView 
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.BrackeChallangeCollectionView.dequeueReusableCellWithReuseIdentifier("ChallangeCell", forIndexPath: indexPath)
        cell.layer.cornerRadius = 10.0
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else if section == 1 {
            return 2
        } else {
            return 1
        }
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
//    optional func collectionView(collectionView: UICollectionView,
//                                   layout collectionViewLayout: UICollectionViewLayout,
//                                          sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
//        
//    }
    //-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    self.cellWidth = self.collectionView.frame.size.width/1.5;
//    self.cellHeight = (self.collectionView.frame.size.height-self.topInset-self.bottomInset-60)/4;
//    return CGSizeMake(self.cellWidth, self.cellHeight);
//}
    
/*-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
 if (section == 0) {
 return UIEdgeInsetsMake(self.topInset, 30, self.bottomInset, 0);
 } else if (section == 1){
 NSLog(@"%f", self.minimumInteritemSpacing);
 return UIEdgeInsetsMake((self.topInset+(self.cellHeight/2)+self.minimumInteritemSpacing), 50, self.bottomInset + self.cellHeight/2 + self.minimumInteritemSpacing, 0);
 } else if (section == 2){
 return UIEdgeInsetsMake(self.view.frame.size.height/3, 50, 50, 0);
 } else {
 return UIEdgeInsetsMake(self.view.frame.size.height/3, 50, 50, 50);
 }
 }
     -(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
     
     if (section == 0) {
     NSLog(@"cell Height: %f", self.cellHeight);
     self.minimumInteritemSpacing = 10;
     return self.minimumInteritemSpacing;
     } else if (section == 1){
     self.minimumInteritemSpacing = self.cellHeight-50;
     return self.minimumInteritemSpacing;
     } else {
     self.minimumInteritemSpacing = 10;
     return self.minimumInteritemSpacing;
     }
     }
 */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("indexPathRow: \(indexPath.row) \n section: \(indexPath.section)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
