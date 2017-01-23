//
//  HSTextView.m
//  FamilyPlatForm
//
//  Created by laoshifu on 16/11/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "HSTextView.h"

@interface HSTextView (){
    
    
    UILabel* _showTextSizeLabel;
    NSString  *textViewText;
}

@end

@implementation HSTextView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
    }
    return self ;
}

-(instancetype)init{
    self= [super init];
    if(self){
        
        self.backgroundColor= [UIColor whiteColor];
        
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    _placeholderLabel=[UILabel  new];
    _placeholderLabel.backgroundColor=[UIColor clearColor];
//    _placeholderLabel.font = self.font;
    [self addSubview:_placeholderLabel];
    
    _textView =[UITextView new];
    [self addSubview:_textView];

    
    _placeholderLabel.sd_layout.topSpaceToView(self,12).leftSpaceToView(self,10).widthIs(60);
    

    _textView.sd_layout.topSpaceToView(self,0).leftSpaceToView(_placeholderLabel,5).rightSpaceToView(self,5).bottomSpaceToView(self,5);
}


- (void)setAttPlaceholderStr:(NSMutableAttributedString *)attPlaceholderStr{

    _placeholderLabel.attributedText =attPlaceholderStr;
    
    [self updateLayout];
    
}





@end
