//
//  JMChatUserModel.h
//  FamilyPlatForm
//
//  Created by 梁继明 on 16/6/15.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface JMChatUserModel : JSONModel


@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString<Optional> *Phone;

@property (nonatomic, copy) NSString<Optional> *name;

@property (nonatomic, copy) NSString<Optional> *image;

@property (nonatomic, copy) NSString<Optional> *depart;


@end
