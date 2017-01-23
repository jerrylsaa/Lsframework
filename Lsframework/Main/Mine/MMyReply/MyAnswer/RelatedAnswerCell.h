//
//  RelatedAnswerCell.h
//  FamilyPlatForm
//
//  Created by laoshifu on 16/12/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelatedAnswerEntity.h"
@class RelatedAnswerCell;

@protocol RelatedAnswerCellDelegate <NSObject>
@optional

- (void)playVoiceByCell:(RelatedAnswerCell *)cell;



@end

@interface RelatedAnswerCell : UITableViewCell

@property (nonatomic,strong) UIButton *voiceBtn;
@property (nonatomic,strong) UILabel *voiceTimeLabel;

@property(nonatomic,weak) id<RelatedAnswerCellDelegate> delegate;

@property (nonatomic,strong) RelatedAnswerEntity *cellEntity;

@property (nonatomic, strong) UIView *haveImageBgView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *midImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *leftImageView1;
@property (nonatomic, strong) UIImageView *midImageView2;
@property (nonatomic, strong) UIImageView *rightImageView3;
@end
