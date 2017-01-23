//
//  BSHospitalCheckDetailedInformationCell.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HospitalFileDetails.h"

@interface BSHospitalCheckDetailedInformationCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *casesImageView;
@property (weak, nonatomic) IBOutlet UILabel     *dateTimeLabel;

@property (nonatomic, strong) HospitalFileDetails *model;

@end
