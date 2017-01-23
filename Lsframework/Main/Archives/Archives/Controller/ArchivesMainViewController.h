//
//  ArchivesMainViewController.h
//  FamilyPlatForm
//
//  Created by tom on 16/5/9.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BaseViewController.h"


@interface ArchivesMainViewController : BaseViewController

@property (nonatomic) Class poptoClass;
@property (nonatomic,strong) NSString *pageType;
@property (weak, nonatomic) IBOutlet UILabel *labelNOOne;
@property (weak, nonatomic) IBOutlet UILabel *labelNOTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelOneXPosition;
@property (weak, nonatomic) IBOutlet UILabel *labelNOThree;
@property (weak, nonatomic) IBOutlet UILabel *labelNOFour;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTwoXPosition;

@end
