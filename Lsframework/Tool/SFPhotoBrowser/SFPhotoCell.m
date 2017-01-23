//
//  SFPhotoCell.m
//
//
//  Created by laoshifu on 15/11/24.
//  Copyright (c) 2015年 laoshifu All rights reserved.
//

#import "SFPhotoCell.h"

@implementation SFPhotoCell
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _photoView = [[SFPhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) - kPhotoImageEdgeSize, CGRectGetHeight(self.frame))];
        [self.contentView addSubview:_photoView];
    }
    return self;
}

- (void)setPhoto:(SFPhoto *)photo{
    _photo = photo;
    _photoView.photo = _photo;
}
@end
