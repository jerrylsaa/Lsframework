//
//  HEAParentQuestionTableViewCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/6/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HEAParentQuestionEntity.h"

@protocol PraiseDelegate <NSObject>
/*  点击用户头像*/
- (void)clickUserIconWithHEAParentQuestionEntity:(HEAParentQuestionEntity* ) heaParentQuestionEntity;
- (void)praiseAtIndexPath:(NSIndexPath *)indexPath;
- (void)cancelPraiseAtIndexPath:(NSIndexPath *)indexPath;

@end

typedef void (^ ClickAudioButtonBlock) (UIButton* bt);


@interface HEAParentQuestionTableViewCell : UITableViewCell

@property(nonatomic,retain) HEAParentQuestionEntity* question;
@property (nonatomic, weak) id<PraiseDelegate> delegate;
@property (nonatomic, weak) id<PraiseDelegate> searchDelegate;

@property(nonatomic) int isSelect;//播放按钮是否选中,0,为选中，1，选中
@property(nonatomic,strong) UIImageView *leftImage;
@property(nonatomic,strong) UIImageView *midImage;
@property(nonatomic,strong) UIImageView *rightImage;

@property(nonatomic,strong) UIImageView *leftImage1;
@property(nonatomic,strong) UIImageView *midImage1;
@property(nonatomic,strong) UIImageView *rightImage1;

@property(nonatomic,strong) UIView *containerView;
@property(nonatomic,strong) UIView *HaveImageView;
@property(nonatomic,strong) UILabel *TraceLabel;

@property(nonatomic) BOOL detalIsFreeQuestion;

@property(nonatomic) BOOL isFree;

@property(nonatomic) BOOL  isFreeQusetion;
@property(nonatomic,retain) UIActivityIndicatorView* activityIndicator;


- (void)clickAudionButtonOnCompletion:(ClickAudioButtonBlock) block;

- (void)changeStyle;

@end
