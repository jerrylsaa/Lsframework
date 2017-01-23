//
//  CircleEntity.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/20.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "CircleEntity.h"

@implementation CircleEntity

+(NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
    
    if([propertyName isEqualToString:@"uuid"]){
        return @"uuid";
    }
    if([propertyName isEqualToString:@"expertID"]){
        return @"Expert_ID";
    }
    if([propertyName isEqualToString:@"childImg"]){
        return @"CHILD_IMG";
    }
    if ([propertyName isEqualToString:@"isPraise"]) {
        return @"isPraise";
    }
    return [propertyName mj_firstCharUpper];
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSDate class] && ![oldValue isKindOfClass:[NSNull class]]) {
        NSTimeInterval time = [oldValue doubleValue];
        return [NSDate dateWithTimeIntervalSince1970:time];
    }
    
    if (property.type.typeClass == [NSString class] &&  [oldValue isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    return oldValue;
}


+(HEAParentQuestionEntity *)convertCircleEntityToHEAParentQuestionEntity:(CircleEntity *)circleEntity{

    /*
     @property(nonatomic) NSInteger uuID;
     @property(nonatomic) NSInteger userID;
     @property(nonatomic,copy) NSString* consultationContent;
     @property(nonatomic,copy) NSString* voiceUrl;
     @property(nonatomic) NSInteger hearCount;
     @property(nonatomic) NSInteger consultationStatus;
     @property(nonatomic) CGFloat expertPrice;
     @property(nonatomic) NSInteger isTop;
     @property(nonatomic,copy) NSString* createUser;
     @property(nonatomic,copy) NSString* createTime;
     @property(nonatomic,assign) long VoiceTime;
    @property(nonatomic,copy) NSString* userImageURL;
    @property(nonatomic,retain) NSString* imageUrl;
    @property(nonatomic) NSInteger praiseCount;
    @property(nonatomic,copy) NSString* questionTime;//提问题时间
    @property(nonatomic,retain) NSString* audioUrl;//音频url
    
    @property(nonatomic) int isListen;//是否已经偷听过,0没有，1偷听了
    @property(nonatomic) NSInteger expertID;//医生id
    @property(nonatomic,copy) NSString *Image1;
    @property(nonatomic,copy) NSString *Image2;
    @property(nonatomic,copy) NSString *Image3;
    @property(nonatomic,retain) NSNumber *IsOpenImage;
    @property(nonatomic,retain) NSNumber *IsFree;  //是否免费

     
     */
    
    HEAParentQuestionEntity* questionEntity = [HEAParentQuestionEntity new];
    
    questionEntity.uuID = [circleEntity.uuid integerValue];
    questionEntity.userID = circleEntity.userID;
    questionEntity.consultationContent = circleEntity.consultationContent;
    questionEntity.voiceUrl = circleEntity.voiceUrl;
    questionEntity.hearCount = [circleEntity.hearCount integerValue];
    questionEntity.consultationStatus = circleEntity.consultationStatus;
    questionEntity.expertPrice = [circleEntity.expertPrice floatValue];
    questionEntity.isTop = circleEntity.isTop;
    questionEntity.createUser = circleEntity.createUser;
    
//    questionEntity.createTime = [circleEntity.createTime format2String:@"yyyy-MM-dd HH:mm:ss"];
    questionEntity.createTime = circleEntity.createTime;
    questionEntity.VoiceTime = circleEntity.voiceTime;
    questionEntity.imageUrl = circleEntity.doctorImageUrl;

    questionEntity.isListen = [circleEntity.isListen intValue];
    questionEntity.expertID = [circleEntity.expertID integerValue];

    questionEntity.Image1 = circleEntity.image1;
    questionEntity.Image2 = circleEntity.image2;
    questionEntity.Image3 = circleEntity.image3;
    
    questionEntity.IsOpenImage = circleEntity.isOpenImage;
    questionEntity.IsFree = circleEntity.isFree;
    
//    NSLog(@"hello====%@",questionEntity.createTime);
    
    
    return questionEntity;
}

@end
