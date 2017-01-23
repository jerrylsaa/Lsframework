//
//  DescribeView.h
//  FamilyPlatForm
//
//  Created by lichen on 16/3/30.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescribeView : UIView

@property(nonatomic,retain) UILabel* titleLabel;

@property(nonatomic,retain) UILabel* describeLabel;

@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* detail;



@end
