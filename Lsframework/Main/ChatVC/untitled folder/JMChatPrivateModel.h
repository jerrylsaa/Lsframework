//
//  JMChatPrivateModel.h
//  doctors
//
//  Created by 梁继明 on 16/4/19.
//  Copyright © 2016年 zhonghong. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface JMChatPrivateModel : JSONModel


@property (nonatomic, copy) NSString <Optional>*UserID;

@property (nonatomic, copy) NSString  <Optional>*Disease;

@property (nonatomic, copy) NSString  <Optional>*AppState;

@property (nonatomic, assign) NSInteger HoldingTime;

@property (nonatomic, copy) NSString <Optional> *Phone;

@property (nonatomic, copy) NSString  <Optional>*DiseaseInfo;

@property (nonatomic, copy) NSString  <Optional>*Name;

@property (nonatomic, copy) NSString <Optional> *TalkTime;

@property (nonatomic, copy) NSString  <Optional>*Image;



@end
