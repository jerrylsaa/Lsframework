//
//  FFeedBackTableCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/8/3.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFeedBackTableCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *insertAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *insertTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *doctorLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultTimeLabel;

@end
