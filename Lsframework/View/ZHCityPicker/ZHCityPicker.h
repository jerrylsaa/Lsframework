//
//  ZHCityPicker.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/4/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityEntity.h"


@protocol ZHCityPickerDelegate <NSObject>

- (void)selected:(CityEntity *)city;

@end

@interface ZHCityPicker : UIView

@property (nonatomic ,strong)CityEntity *city;

@property (nonatomic ,weak)id<ZHCityPickerDelegate> delegate;

- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
