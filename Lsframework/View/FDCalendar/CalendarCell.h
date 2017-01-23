//
//  CalendarCell.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UICollectionViewCell

@property (nonatomic ,strong)UILabel *titleLabel;

@property (nonatomic ,strong)UILabel *monthLabel;

@property (nonatomic ,assign)BOOL isCurrent;

@end
