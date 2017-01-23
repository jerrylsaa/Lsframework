//
//  ChartViewController.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, ChartType) {
    ChartTypeBreastFeeding,
    ChartTypeFormulaFeeding,
    ChartTypeSleeping,
    ChartTypeShit,
    ChartTypeNutritionalSupplement,
};

@interface ChartViewController : BaseViewController

@property (nonatomic ,assign) ChartType chartType;

@end
