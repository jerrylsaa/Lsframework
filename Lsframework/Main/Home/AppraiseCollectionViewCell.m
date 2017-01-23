//
//  AppraiseCollectionViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/11/22.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "AppraiseCollectionViewCell.h"
@interface AppraiseCollectionViewCell (){
    
    UIView* _contanierView;
    UIImageView* _menuImageView;
    
    
}

@end

@implementation AppraiseCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.contentView.backgroundColor = [UIColor clearColor];
        _contanierView = [UIView new];
        [self.contentView addSubview:_contanierView];
        
        _menuImageView = [UIImageView new];
        _menuImageView.userInteractionEnabled = YES;
        [_contanierView addSubview:_menuImageView];
        
        
        _contanierView.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0);
        
        _menuImageView.sd_layout.topSpaceToView(_contanierView,0).leftSpaceToView(_contanierView,0).rightSpaceToView(_contanierView,0).heightIs(90);
        
        [_contanierView setupAutoHeightWithBottomView:_menuImageView bottomMargin:0];
        
        
    }
    return self ;
}
-(void)setHealthService:(HealthService *)HealthService{
    _HealthService = HealthService;
    
    
  [_menuImageView sd_setImageWithURL:[NSURL URLWithString:self.HealthService.ImageUrl] placeholderImage:[UIImage imageNamed:@"hyperactivityBtn"]];

}

@end
