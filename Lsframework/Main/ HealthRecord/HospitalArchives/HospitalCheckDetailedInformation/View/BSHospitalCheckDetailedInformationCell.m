//
//  BSHospitalCheckDetailedInformationCell.m
//  FamilyPlatForm
//
//  Created by Shuai on 16/4/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "BSHospitalCheckDetailedInformationCell.h"
#import "UIImageView+WebCache.h"
#import "ApiMacro.h"

@implementation BSHospitalCheckDetailedInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(HospitalFileDetails *)model {
    
    _model = model;
    
    [self.casesImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,model.imageUrl]]];
    self.casesImageView.contentMode = UIViewContentModeScaleToFill;
    
//    self.dateTimeLabel = ?;// 不知道是否需要时间
    
}

@end
