//
//  WeightScrollView.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,WeightAndHeightType){
    TypeHeightText,
    TypeWeightText,
};

@interface WeightScrollView : UIScrollView


//- (void)createWeightScorll:(NSString *)minString  showType:(WeightAndHeightType)showType;

- (void)createWeightScorllMinruler:(NSInteger )minruler   showType:(WeightAndHeightType)showType;

@end
