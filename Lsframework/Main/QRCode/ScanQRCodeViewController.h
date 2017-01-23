//
//  ScanQRCodeViewController.h
//  EyeHealthForDoctor
//
//  Created by tom on 16/4/15.
//  Copyright © 2016年 eyevision. All rights reserved.
//

#import "BaseViewController.h"

@protocol ScanQRCodeViewControllerDelegate <NSObject>

-(void)onScanDone:(NSString*)qrCode;

@end

@interface ScanQRCodeViewController : BaseViewController

@property (nonatomic, weak) id<ScanQRCodeViewControllerDelegate> delegate;

@end
