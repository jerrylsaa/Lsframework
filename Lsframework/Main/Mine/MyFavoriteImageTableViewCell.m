//
//  MyFavoriteImageImageTableViewCell.m
//  FamilyPlatForm
//
//  Created by jerry on 16/12/12.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "MyFavoriteImageTableViewCell.h"
#import "ApiMacro.h"

@implementation MyFavoriteImageTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self setupView];
        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
    return self;
}

-(void)setupView{
    
    
    
    
    _containerView = [UIView new];
    _containerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_containerView];
    
    //头像
    _ICONImageView = [UIImageView   new];
    _ICONImageView.backgroundColor = [UIColor  clearColor];
    [_containerView  addSubview:_ICONImageView];
    
    
    //昵称
    _NickName = [UILabel  new];
    _NickName.backgroundColor = [UIColor  clearColor];
    _NickName.textColor = UIColorFromRGB(0x666666);
    _NickName.font = [UIFont systemFontOfSize:14];
    _NickName.textAlignment = NSTextAlignmentLeft;
    _NickName.numberOfLines = 1;
    [_containerView  addSubview:_NickName];
    
    //时间
    _CreatTimelb = [UILabel  new];
    _CreatTimelb.backgroundColor = [UIColor  clearColor];
    _CreatTimelb.font = [UIFont  systemFontOfSize:12];
    _CreatTimelb.textAlignment = NSTextAlignmentRight;
    _CreatTimelb.textColor = UIColorFromRGB(0x999999);
    _CreatTimelb.numberOfLines = 1;
    [_containerView  addSubview:_CreatTimelb];
    
    
    //时间
    _ConsultationContentLb = [UILabel  new];
    _ConsultationContentLb.backgroundColor = [UIColor  clearColor];
    _ConsultationContentLb.font = _NickName.font;
    _ConsultationContentLb.textAlignment = NSTextAlignmentLeft;
    _ConsultationContentLb.textColor =_NickName.textColor;
    _ConsultationContentLb.numberOfLines = 0;
    [_containerView  addSubview:_ConsultationContentLb];
    
    
    //帖子图片
    _Image1 = [UIImageView   new];
    _Image1.backgroundColor = [UIColor  clearColor];
    [_containerView  addSubview:_Image1];
    
    
    
    
    //添加约束
    _containerView.sd_layout.topSpaceToView(self.contentView,15/2).leftSpaceToView(self.contentView,15/2).rightSpaceToView(self.contentView,15/2);
    
    
    _containerView.sd_cornerRadius = @5;
    
    _ICONImageView.sd_layout.topSpaceToView(_containerView,20/2).leftSpaceToView(_containerView,15/2.0f).heightIs(30).widthIs(30);
    _ICONImageView.sd_cornerRadius = @15;
    
    _NickName.sd_layout.leftSpaceToView(_ICONImageView,10).centerYEqualToView(_ICONImageView).heightIs(15).widthIs(10);
    
    _CreatTimelb.sd_layout.rightSpaceToView(_containerView,15/2).centerYEqualToView(_ICONImageView).heightIs(15).widthIs(10);
    
    _Image1.sd_layout.topSpaceToView(_ICONImageView,20/2).leftEqualToView(_ICONImageView).widthIs(120/2).heightEqualToWidth(0);
    _Image1.sd_cornerRadius = @5;
    
 
    
    _ConsultationContentLb.sd_layout.topSpaceToView(_ICONImageView,20/2).leftSpaceToView(_Image1,15/2).rightEqualToView(_CreatTimelb).autoHeightRatio(0);
    
    
    [_containerView setupAutoHeightWithBottomViewsArray:@[_ConsultationContentLb,_Image1] bottomMargin:20/2];
    
    
   [self setupAutoHeightWithBottomView:_containerView bottomMargin:20/2];

    
    
    
    
}
-(void)setMyFavoriteImage:(MyFavoriteEntity *)MyFavoriteImage{
    
    
    //1.咨询   2.文章  3.帖子
     _MyFavoriteImage = MyFavoriteImage;
    
    //头像
    [_ICONImageView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",ICON_URL,MyFavoriteImage.UserImage]] placeholderImage:[UIImage imageNamed:@"HEAUserIcon"]];
    
    //创建时间
    _CreatTimelb.text = MyFavoriteImage.PraiseTime;
    //图片
    if (MyFavoriteImage.Type == 2 ){
        //    //文字+图片
        //昵称
        _NickName.text = MyFavoriteImage.From;

        [_Image1 sd_setImageWithURL:[NSURL  URLWithString:[NSString stringWithFormat:@"%@",MyFavoriteImage.Photo]]  placeholderImage:nil];
        
         _ConsultationContentLb.text = MyFavoriteImage.Title;
        
        

    }else{
        //昵称
        _NickName.text = MyFavoriteImage.NickName;

       [_Image1 sd_setImageWithURL:[NSURL  URLWithString:[NSString stringWithFormat:@"%@%@",ICON_URL,MyFavoriteImage.Image1]]  placeholderImage:nil];
        
         _ConsultationContentLb.text = MyFavoriteImage.ConsultationContent;
    }
    
    
    _NickName.width = [JMFoundation  calLabelWidth:_NickName];
    _CreatTimelb.width = [JMFoundation  calLabelWidth:_CreatTimelb];
//    _ConsultationContentLb.height = [JMFoundation  calLabelHeght:_ConsultationContentLb];

    [_NickName  updateLayout];
    [_CreatTimelb  updateLayout];
    
//    
//    [_ConsultationContentLb  updateLayout];
//    [_Image1  updateLayout];
//    [_containerView  updateLayout];
//    [self  updateLayout];

    
  
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
