//
//  PublicPostPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/9/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "FormData.h"
#import "UIImage+Category.h"

@protocol PublicPostPresenterDelegate <NSObject>

- (void)publicPostOnCompletion;

-(void)data:(NSMutableArray *)dataArr title:(NSString *)title twoTitle:(NSString *)twoTitle;

@end

@interface PublicPostPresenter : BasePresenter

@property(nullable,nonatomic,weak) id<PublicPostPresenterDelegate> delegate;

- (void)publicPost:(NSMutableArray* _Nonnull) imageDataSorce title:(NSString* _Nonnull) title consultation:(NSString* _Nonnull) consultation;

- (void)commitConsultation:(NSString* _Nonnull) uploadPath title:(NSString* _Nonnull) title consultation:(NSString* _Nonnull) consultation;

- (void)loadArr:(NSMutableArray*)uploadArrPath title:(NSString*) title consultation:(NSString*) consultation;

@end
