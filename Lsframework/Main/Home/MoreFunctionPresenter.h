//
//  MoreFunctionPresenter.h
//  FamilyPlatForm
//
//  Created by jerry on 16/11/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "MoreFunction.h"
@protocol MoreFunctionPresenterDelegate <NSObject>

@optional
- (void)LoadMoreFunctionComplete:(BOOL) success info:(NSString*) info;

@end
typedef void(^haveOtherPWD)(BOOL haveOtherPWD, NSString *message);
typedef void(^createOtherPWD)(BOOL createOtherPWD, NSString *message);

@interface MoreFunctionPresenter : BasePresenter

@property(nonatomic,weak) id<MoreFunctionPresenterDelegate> delegate;

@property(nonatomic,retain) NSMutableArray<MoreFunction* >* MoreFunctionSource;



-(void)loadMoreFunction;


- (void)getOtherPWDByUserID:(haveOtherPWD) block;
- (void)createOtherPWDRequest:(createOtherPWD) block;

@end
