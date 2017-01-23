//
//  BSCheckProjectCell.h
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckProject.h"

@interface BSCheckProjectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, assign) NSInteger projectID;

@property (nonatomic, strong) CheckProject *model;

@end
