//
//  LCPickerView.h
//  省市pickerView
//
//  Created by lichen on 16/4/18.
//  Copyright © 2016年 lichen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityEntity.h"

typedef void (^ LCPickerViewBlock) (NSString* province,NSString* city);

@interface LCPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,retain) UIPickerView* postionPickerView;

@property(nonatomic,retain) NSArray<NSString*> * proArray;
@property(nonatomic,retain) NSArray<NSString*> * cityArray;

@property(nonatomic,copy) NSString* currentProvince;
@property(nonatomic,copy) NSString* currentCity;

- (void)showPickerViewCompletetionHandler:(LCPickerViewBlock) block;

- (void)dismiss;


@end
