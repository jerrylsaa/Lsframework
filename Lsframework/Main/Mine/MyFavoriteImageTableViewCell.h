//
//  MyFavoriteImageTableViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/12/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFavoriteEntity.h"

@interface MyFavoriteImageTableViewCell : UITableViewCell

@property(nullable,nonatomic,strong)UIImageView *Image1;
@property(nullable,nonatomic,strong)UILabel *ConsultationContentLb;
@property(nullable,nonatomic,strong)UIImageView *ICONImageView;
@property(nullable,nonatomic,strong)UIView* containerView;
@property(nullable,nonatomic,strong)UILabel     *CreatTimelb;
@property(nullable,nonatomic,strong)UILabel     *NickName;


@property(nullable,nonatomic,retain) MyFavoriteEntity* MyFavoriteImage;


@end
