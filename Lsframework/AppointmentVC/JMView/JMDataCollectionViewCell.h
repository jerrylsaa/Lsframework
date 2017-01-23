//
//  JMDataCollectionViewCell.h
//  doctors
//
//  Created by 梁继明 on 16/4/2.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMDataModel.h"

@interface JMDataCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) JMDataModel *dateModel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
