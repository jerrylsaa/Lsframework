//
//  HHotConsulationTableViewCell.h
//  FamilyPlatForm
//
//  Created by jerry on 16/9/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsultationCommenList.h"
#import "RegexKitLite.h"
#import "TextSegment.h"
@protocol HHotConsulationTableViewCellDelegate <NSObject>
@optional
/*  点击baby头像*/
- (void)clickBabyIconWithConsultationCommenList:(ConsultationCommenList* _Nonnull) commenList;

@end

@interface HHotConsulationTableViewCell : UITableViewCell

@property(nullable,nonatomic,weak) id<HHotConsulationTableViewCellDelegate> delegate;

@property(nullable,nonatomic,retain) ConsultationCommenList * CommenList;
@property(nullable,nonatomic,strong)UIButton  *AnswerCountBtn;

@property(nullable,nonatomic,strong) UIImageView *leftImage;
@property(nullable,nonatomic,strong) UIImageView *midImage;
@property(nullable,nonatomic,strong) UIImageView *rightImage;

@property(nullable,nonatomic,strong) UIImageView *leftImage1;
@property(nullable,nonatomic,strong) UIImageView *midImage1;
@property(nullable,nonatomic,strong) UIImageView *rightImage1;

@property(nullable,nonatomic,strong) UIView *HaveImageView;


@end
