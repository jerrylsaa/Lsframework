//
//  LCChatToolBarView.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicPostTextView.h"
#import "EmotionTextAttachment.h"
#import "LCImagebgView.h"

typedef void (^ Complete)(NSMutableArray* _Nonnull imageDataSource);

@protocol LCChatToolBarViewDelegate <NSObject>

@optional
- (void)clickAddPhotoCompleteHandler:(Complete _Nonnull) complete;
- (void)sendCommitPostWith:(BOOL) isNeedUploadPImage content:(NSString* _Nonnull) consultation imageDataSource:(NSMutableArray* _Nonnull) imageDataSource;


@end

@interface LCChatToolBarView : UIView<UIScrollViewDelegate,LCImagebgViewDelegate,UITextViewDelegate>

@property(nullable,nonatomic,weak) id<LCChatToolBarViewDelegate> delegate;

@property(nullable,nonatomic,retain) PublicPostTextView* textView;
@property(nullable,nonatomic,retain) UITextView* unUsedTextView;
@property(nullable,nonatomic,retain) UIButton* sendButton;

@property(nonatomic) NSInteger emotionColumn;//表情列数
@property(nonatomic) NSInteger emotionRow;//表情行数

@property(nonatomic) BOOL hiddenAddButton;//隐藏添加按钮

@property(nullable,nonatomic,retain) NSMutableArray* imageDataSource;


@end
