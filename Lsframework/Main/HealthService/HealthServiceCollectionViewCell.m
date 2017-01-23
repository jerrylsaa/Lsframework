//
//  HealthServiceCollectionViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/7/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HealthServiceCollectionViewCell.h"
#define xSpace 20
#define ySpace  20
#define  k_width  ([[UIScreen mainScreen] bounds].size.width-3*xSpace)/2
#define  k_height  3*k_width/4

@implementation HealthServiceCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    if (self=[super  initWithFrame:frame]) {
        
           [self setupSubviews];
    }
    return self;
    
}
-(void)setupSubviews{
    self.imageView = [UIImageView new];
    self.imageView.frame = CGRectMake(0, 0, k_width, k_height);
    self.imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.imageView];

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
