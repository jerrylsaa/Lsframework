//
//  ZHCalendarCell.h
//  Date
//
//  Created by 中弘科技 on 16/4/2.
//  Copyright © 2016年 中弘科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHCalendarCell : UICollectionViewCell

@property (nonatomic ,strong)UILabel *title;
@property (nonatomic ,assign)BOOL enableSelect;
@property (nonatomic ,assign)BOOL isCurrent;

@end
