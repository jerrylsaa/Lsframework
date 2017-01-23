//
//  DiseaseDescribePresenter.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BasePresenter.h"
#import "UploadPath.h"

typedef NS_ENUM(NSInteger, UploadType){
    UploadPictureAndAudio = 0,//上传图片和语音
    UploadPicture,//上传图片
    UploadAudio//上传音频
};


@protocol DiseaseDescribePresenterDelegate <NSObject>

- (void)commitDiseaseDescribeOnComplete:(BOOL) success info:(NSString*) info;

@end


@interface DiseaseDescribePresenter : BasePresenter

@property(nonatomic,weak) id<DiseaseDescribePresenterDelegate> delegate;

@property(nonatomic,retain) NSMutableArray* audioArray;//包括病情语音和药物使用语音
@property(nonatomic,retain) NSString* imageUploadPath;//上传图片路径

@property(nonatomic,copy) NSString* sickAudioPath;
@property(nonatomic,copy) NSString* drugAudioPath;


@property(nonatomic)UploadType uploadType ;

- (void)commitSickDescirbe:(UploadPath*) uploadPath;






@end
