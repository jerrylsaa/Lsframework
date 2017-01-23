//
//  ServiceTableViewCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/3.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceTableViewCell : UITableViewCell

@property(nonatomic,retain) NSString* iconName;
@property(nonatomic,retain) UIImageView* iconImage;
@property(nonatomic,retain) UILabel* titleLabel;
@property(nonatomic,retain) UILabel* detailLabel;
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* detail;

@end
