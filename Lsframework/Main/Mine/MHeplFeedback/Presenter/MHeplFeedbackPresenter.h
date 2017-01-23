//
//  MHeplFeedbackPresenter.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"

@protocol uploadFileDelegate <NSObject>

- (void)sendMessage:(NSString *)message;

@end

@interface MHeplFeedbackPresenter : BasePresenter

@property (nonatomic, weak) id<uploadFileDelegate>delegate;

- (void)requestWithDescriptionStr:(NSString *)description withVoicePathStr:(NSString *)voice withPhotoPathArary:(NSArray *)photoArray withPhoneNum:(NSString *)phone withVoiceCurrentTime:(NSInteger) currentTime;

@end
