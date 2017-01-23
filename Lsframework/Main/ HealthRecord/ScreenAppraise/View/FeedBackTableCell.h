//
//  FeedBackTableCell.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/5/11.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackTableCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *insertAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *insertTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end
