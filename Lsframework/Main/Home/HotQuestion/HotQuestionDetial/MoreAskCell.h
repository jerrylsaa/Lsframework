//
//  MoreAskCell.h
//  FamilyPlatForm
//
//  Created by 中弘科技 on 2016/10/21.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HEAParentQuestionEntity.h"

@protocol PraiseDelegate <NSObject>

- (void)praiseAtIndexPath:(NSIndexPath *)indexPath;
- (void)cancelPraiseAtIndexPath:(NSIndexPath *)indexPath;

- (void)WordContentClickAtIndexPath:(NSIndexPath *)indexPath;
@end

typedef void (^ ClickAudioButtonBlock) (UIButton* bt);
typedef void (^ ClickWordContentBlock) (UIButton* bt);

@interface MoreAskCell : UITableViewCell
@property(nonatomic,retain) HEAParentQuestionEntity* question;
@property (nonatomic, weak) id<PraiseDelegate> delegate;
@property (nonatomic, weak) id<PraiseDelegate> searchDelegate;

@property(nonatomic) int isSelect;//播放按钮是否选中,0,为选中，1，选中
@property(nonatomic,strong) UIImageView *QuestionImageView1;
@property(nonatomic,strong) UIImageView *QuestionImageView2;
@property(nonatomic,strong) UIImageView *QuestionImageView3;
@property(nonatomic,strong) UIImageView *QuestionImageView4;
@property(nonatomic,strong) UIImageView *QuestionImageView5;
@property(nonatomic,strong) UIImageView *QuestionImageView6;
@property(nonatomic,strong) UIImageView *rightImage;
@property(nonatomic,strong) UIImageView *midImage;
@property(nonatomic,strong) UIImageView *leftImage;
@property(nonatomic,strong) UIView *containerView;
@property(nonatomic,strong) UIView *HaveImageView;

@property(nonatomic,strong) UIButton *voicebt;
@property(nonatomic,strong) UILabel *voiceTimeLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *hearCount;
@property(nonatomic,strong) UILabel *priceLabel;


//文字补充回答
@property (nonatomic, strong) UIView *WordBackView;
@property (nonatomic, strong) UIButton *WordContentBtn;
@property (nonatomic, strong) UIView *WordContentView;
@property (nonatomic, strong) UILabel  *WordContentMessage;
@property(nonatomic) int isWordContentSelect;//播放按钮是否选中,0,为选中，1，选中

@property(nonatomic) BOOL isFree;

@property(nonatomic) BOOL  isFreeQusetion;
@property(nonatomic) BOOL  isMainFreeQusetion;  //主问题是否限时免费
@property(nonatomic,retain) UIActivityIndicatorView* activityIndicator;


- (void)clickAudionButtonOnCompletion:(ClickAudioButtonBlock) block;

-(void)clickWordContentButtonOnCompletion:(ClickWordContentBlock)block;

- (void)changeStyle;
@end
