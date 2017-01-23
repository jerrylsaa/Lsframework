//
//  CircleTableViewCell.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleEntity.h"

@protocol CircleTableViewCellDelegate <NSObject>
@optional
/*  点击baby头像*/
- (void)clickBabyIconWithCircleEntity:(CircleEntity* _Nonnull) circleEntity;
/*  点击照片*/
- (void)clickPhotoWallWithCircleEntity:(CircleEntity* _Nonnull) circleEntity currentPhoto:(UIImageView* _Nonnull) imageView photoDataSource:(NSArray<UIImageView*>* _Nonnull) photoDataSource photoURLDataSource:(NSArray<NSString*> * _Nonnull) photoURL;
/*  点击语音按钮*/
- (void)clickAudioButton:(UIButton* _Nonnull) voiceBt circleEntity:(CircleEntity* _Nonnull) circleEntity currentCell:(UITableViewCell* _Nonnull) currentCell;
//赞
- (void)praiseAtIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type;
- (void)cancelPraiseAtIndexPath:(NSIndexPath *)indexPath type:(NSInteger)type;

-(void)deleButtonWithIndexPath:(UITableViewCell *)indexPath;

@end


@interface CircleTableViewCell : UITableViewCell

@property(nullable,nonatomic,weak) id<CircleTableViewCellDelegate> delegate;

@property(nullable,nonatomic,retain) CircleEntity* circleEntity;
@property(nonatomic)int voicebtIsSelect;//语音按钮是否选中,0,未选中，1，选中


@end
