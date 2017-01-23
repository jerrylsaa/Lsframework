//
//  OutPatientAppointViewController.h
//  FamilyPlatForm
//
//  Created by lichen on 16/7/14.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^haveOtherPWD)(BOOL haveOtherPWD, NSString *message);
typedef void(^createOtherPWD)(BOOL createOtherPWD, NSString *message);

@interface OutPatientAppointViewController : BaseViewController

@property(nonatomic,retain) NSString* outPatientURL;
- (void)getOtherPWDByUserID:(haveOtherPWD) block;
- (void)createOtherPWDRequest:(createOtherPWD) block;

@end
