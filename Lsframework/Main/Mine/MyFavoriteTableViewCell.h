//
//  MyFavoriteTableViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/12/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyFavoriteEntity.h"

@interface MyFavoriteTableViewCell : UITableViewCell
@property(nullable,nonatomic,retain) MyFavoriteEntity* MyFavorite;

@property(nullable,nonatomic,strong)UIImageView *Image1;
@property(nullable,nonatomic,strong)UILabel *ConsultationContentLb;
@property(nullable,nonatomic,strong)UIImageView *ICONImageView;
@property(nullable,nonatomic,strong)UIView* containerView;
@property(nullable,nonatomic,strong)UILabel     *CreatTimelb;
@property(nullable,nonatomic,strong)UILabel     *NickName;




@end
