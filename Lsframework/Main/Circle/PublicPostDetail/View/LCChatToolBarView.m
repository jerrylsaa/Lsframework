//
//  LCChatToolBarView.m
//  FamilyPlatForm
//
//  Created by lichen on 16/9/27.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "LCChatToolBarView.h"

#define kAddInputViewHeight (448 / 2.0)
#define kFaceInputViewHeight (264 - 40)
#define kScrollViewHeight (270/2.0)

//(160-10)/2
#define   k_addTop    33/2.0

#define   k_imageTop    10
#define   k_imageSingleHeight  (160- k_imageTop)/2

#define   k_imageXspace  (kScreenWidth-k_imageSingleHeight*3)/4


@interface LCChatToolBarView (){
    BOOL convertToSystemKeyboard;
    BOOL isEmotion;
    BOOL keyboardHidden;
}

@property(nullable,nonatomic,retain) UIView* addInputView;
@property(nullable,nonatomic,retain) UIView* faceInputView;
@property(nullable,nonatomic,retain) UIButton* addButton;
@property(nullable,nonatomic,retain) UIButton* faceButton;
@property(nullable,nonatomic,retain) UIPageControl* pageControl;
@property(nullable,nonatomic,retain) NSMutableArray<NSDictionary*>* defaultEmotionArray;//表情数据源
@property(nullable,nonatomic,retain) LCImagebgView* LCImageView1;
@property(nullable,nonatomic,retain) LCImagebgView* LCImageView2;
@property(nullable,nonatomic,retain) LCImagebgView* LCImageView3;
@property(nullable,nonatomic,retain) LCImagebgView* LCImageView4;
@property(nullable,nonatomic,retain) LCImagebgView* LCImageView5;
@property(nullable,nonatomic,retain) LCImagebgView* LCImageView6;
@property(nullable,nonatomic,retain) UIButton* addPhotoButton;
@property(nullable,nonatomic,retain) UILabel* photoNumLabel;
@end

@implementation LCChatToolBarView

-(instancetype)init{
    self= [super init];
    if(self){
        [self setupView];
        
        [kdefaultCenter addObserver:self selector:@selector(keyboardHidden) name:UIKeyboardWillHideNotification object:nil];
        [kdefaultCenter addObserver:self selector:@selector(keyboardShow) name:UIKeyboardWillShowNotification object:nil];
        [kdefaultCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];


        
    }
    return self;
}

#pragma mark - 加载视图
- (void)setupView{
    //添加按钮
    UIButton* addbt = [UIButton new];
    [addbt setBackgroundImage:[UIImage imageNamed:@"circle_add_nor"] forState:UIControlStateNormal];
    [addbt setBackgroundImage:[UIImage imageNamed:@"circle_add_heigh"] forState:UIControlStateHighlighted];
    [addbt setBackgroundImage:[UIImage imageNamed:@"circle_add_sel"] forState:UIControlStateSelected];
    addbt.tag = 101;
    [addbt addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addbt];
    self.addButton = addbt;
    
    //表情按钮
    UIButton* facebt = [UIButton new];
    [facebt setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
    [facebt setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateSelected];
    facebt.tag = 102;
    [facebt addTarget:self action:@selector(clickToolBar:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:facebt];
    self.faceButton = facebt;
    
    //发送按钮
    UIButton* sendbt = [UIButton new];
    [sendbt setBackgroundImage:[UIImage imageNamed:@"DailyPrise_NoSendImage"] forState:UIControlStateNormal];
    [sendbt setBackgroundImage:[UIImage imageNamed:@"DailyPrise_SendImage"] forState:UIControlStateSelected];
    [sendbt addTarget:self action:@selector(sendMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendbt];
    self.sendButton = sendbt;
    
    //textView
    PublicPostTextView* textView = [PublicPostTextView new];
    textView.placeholder = @"回复：想说点什么";
//    textView.textColor = UIColorFromRGB(0xcccccc);
    textView.font = [UIFont systemFontOfSize:sbigFont];
    textView.placeholderColor = UIColorFromRGB(0xcccccc);
    textView.placeholderFont = [UIFont systemFontOfSize:sbigFont];
    textView.delegate = self;
    textView.layer.borderWidth = 1;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 8;
    textView.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
    textView.autoAdjustHeight = YES;
    [self addSubview:textView];
    self.textView = textView;
    
    //
    UITextView* unUsedTextView = [UITextView new];
    unUsedTextView.layer.borderWidth = 1;
    unUsedTextView.layer.masksToBounds = YES;
    unUsedTextView.layer.cornerRadius = 8;
    unUsedTextView.layer.borderColor = UIColorFromRGB(0xf2f2f2).CGColor;
    [self addSubview:unUsedTextView];
    [self sendSubviewToBack:unUsedTextView];
//    [self insertSubview:unUsedTextView belowSubview:textView];
    
    self.unUsedTextView = unUsedTextView;
    


    
    //添加约束
    addbt.sd_layout.centerYEqualToView(self).leftSpaceToView(self,5).widthIs(55/2.0).heightEqualToWidth();
    facebt.sd_layout.topEqualToView(addbt).leftSpaceToView(addbt,5).widthRatioToView(addbt,1).heightEqualToWidth();
    sendbt.sd_layout.centerYEqualToView(self).rightSpaceToView(self,5).heightIs(76/2).widthIs(100/2);
    textView.sd_layout.centerYEqualToView(self).leftSpaceToView(facebt,5).rightSpaceToView(sendbt,5).heightIs(sendbt.frame.size.height);
    unUsedTextView.sd_layout.topSpaceToView(textView,0).leftEqualToView(textView).rightEqualToView(textView).heightIs(0);

}

#pragma mark - 点击事件
#pragma mark * 点击toolbar
- (void)clickToolBar:(UIButton*) bt{
    if(self.unUsedTextView.inputView)self.unUsedTextView.inputView = nil;
    
    
    if(bt.tag == 101){
        //添加按钮
        self.faceButton.selected = NO;
        
        bt.selected = YES;
        self.addInputView = nil;
        self.unUsedTextView.inputView = self.addInputView;
        
    }else if(bt.tag == 102){
        //表情按钮
        self.addButton.selected = NO;
        
        self.faceButton.selected = YES;
        self.faceInputView = nil;
        self.unUsedTextView.inputView = self.faceInputView;
    }
    
    [self.unUsedTextView reloadInputViews];
    
    if(![self.unUsedTextView isFirstResponder]){
        [self.unUsedTextView becomeFirstResponder];
    }


//    if(self.textView.inputView)self.textView.inputView = nil;
//
//    if(bt.tag == 101){
//        bt.selected = YES;
//        self.addInputView = nil;
//        self.textView.inputView = self.addInputView;
//    }else if(bt.tag == 102){
//        //表情
//        self.addButton.selected = NO;
//        
//        if(convertToSystemKeyboard){
//            convertToSystemKeyboard = NO;
//            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
//            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
//            
//        }else{
//            convertToSystemKeyboard = YES;
//            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_board_nor"] forState:UIControlStateNormal];
//            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_board_heigh"] forState:UIControlStateHighlighted];
//            self.faceInputView = nil;
//            self.textView.inputView = self.faceInputView;
//            
//        }
//    }
//    
//    [self.textView reloadInputViews];
//    [self.textView becomeFirstResponder];

}
#pragma mark * 发送
- (void)sendMessageAction{
    
    if([self.textView isFirstResponder]){
        [self.textView resignFirstResponder];
    }
    
    if([self.unUsedTextView isFirstResponder]){
        [self.unUsedTextView resignFirstResponder];
    }

    
    
    if((self.imageDataSource.count == 0 || !self.imageDataSource) && [self.textView.text trimming].length == 0){
        return ;
    }
    
    NSMutableString* mutableStr  = [NSMutableString string];
    [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        EmotionTextAttachment* attach = attrs[@"NSAttachment"];
        if(attach){
            //表情
            [mutableStr appendString:attach.emotionTag];
        }else{
            //拼接文本
            NSAttributedString* temp = [self.textView.attributedText attributedSubstringFromRange:range];
            [mutableStr appendString:temp.string];
        }
    }];
    
    NSString* consultation = mutableStr;
    NSLog(@"%@",consultation);
    if(consultation.length == 0){
        consultation = @"";
    }
    
    BOOL isNeedUpload = NO;
    //上传图片
    if(self.imageDataSource && self.imageDataSource.count != 0){
        isNeedUpload = YES;
    }
    
    NSLog(@"uploadImageCount = %ld",self.imageDataSource.count);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(sendCommitPostWith:content:imageDataSource:)]){
        [self.delegate sendCommitPostWith:isNeedUpload content:consultation imageDataSource:self.imageDataSource];
    }

    
    
    
}
#pragma mark * 删除emojy表情
- (void)deleteFaceAction{
    [self.textView deleteBackward];
    self.sendButton.selected = [self.textView.text trimming].length != 0;

}
#pragma mark * 切换表情
- (void)convertEmotionAction:(UIButton*) bt{
    UIButton* emojyButton = (UIButton*)[self.faceInputView viewWithTag:301];
    UIButton* emotionButton = (UIButton*)[self.faceInputView viewWithTag:302];
    
//    if(self.textView.inputView){
//        self.textView.inputView = nil;
//        self.faceInputView = nil;
//    }
//    [self.defaultEmotionArray removeAllObjects];
//    self.defaultEmotionArray = nil;
//    
//    if([bt isEqual:emojyButton]){
//        //emojy表情
//        isEmotion = NO;
//        
//    }else if([bt isEqual:emotionButton]){
//        //自定义表情
//        isEmotion = YES;
//        
//    }
//    self.textView.inputView = self.faceInputView;
//    [self.textView reloadInputViews];
    
    
    if(self.unUsedTextView.inputView){
        self.unUsedTextView.inputView = nil;
        self.faceInputView = nil;
    }
    [self.defaultEmotionArray removeAllObjects];
    self.defaultEmotionArray = nil;
    
    if([bt isEqual:emojyButton]){
        //emojy表情
        isEmotion = NO;
        
    }else if([bt isEqual:emotionButton]){
        //自定义表情
        isEmotion = YES;
        
    }
    self.unUsedTextView.inputView = self.faceInputView;
    [self.unUsedTextView reloadInputViews];

}

#pragma mark * 点击emojy表情
- (void)clickEmotionAction:(UIButton*) emotionbt{
    NSInteger index = emotionbt.tag - 200;
    NSDictionary* emotionDic = self.defaultEmotionArray[index];
    
    //获取之前写的文本
    NSAttributedString* str = self.textView.attributedText;
    //将之前的文本包含进去
    NSMutableAttributedString* mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    //记录当前光标的位置
    NSInteger currentPosition;
    EmotionTextAttachment* attach = [EmotionTextAttachment new];
    attach.bounds = CGRectMake(0, -2.5, self.textView.font.lineHeight - 5, self.textView.font.lineHeight - 5);
    attach.image = [UIImage imageNamed:[emotionDic valueForKey:@"png"]];
    attach.emotionTag = [emotionDic valueForKey:@"tag"];
    NSAttributedString* attr = [NSAttributedString attributedStringWithAttachment:attach];
    //保存一下当前光标位置
    currentPosition = self.textView.selectedRange.location;
    [mutableStr insertAttributedString:attr atIndex:currentPosition];
    
    //重写给文本框赋值
    [mutableStr addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, mutableStr.length)];
    self.textView.attributedText = mutableStr;
    self.textView.selectedRange = NSMakeRange(currentPosition + 1, 0);
    
    self.sendButton.selected = [self.textView.text trimming].length != 0;
    
}

#pragma mark * 添加照片
- (void)clickInputViewCameraAction{
//    [self.textView resignFirstResponder];
//    self.addButton.selected = NO;
    
  NSLog( @"imagedata:%@",  self.imageDataSource);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickAddPhotoCompleteHandler:)]){
        WS(ws);
        [self.delegate clickAddPhotoCompleteHandler:^(NSMutableArray * _Nonnull imageDataSource) {
            
            if(ws.imageDataSource && ws.imageDataSource.count != 0){
                [ws.imageDataSource addObjectsFromArray:imageDataSource];
            }else{
                ws.imageDataSource = imageDataSource;
            }
            WSLog(@"====%ld",ws.imageDataSource.count);
//            if(imageDataSource.count != 0 && ws.imageDataSource){
//                [ws.imageDataSource removeAllObjects];
//                ws.imageDataSource = nil;
//            }
//            ws.imageDataSource = imageDataSource;
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [ws.textView becomeFirstResponder];
                [ws.unUsedTextView becomeFirstResponder];

            });
            
            if(ws.imageDataSource && ws.imageDataSource.count != 0){
                if(self.imageDataSource.count == 1){
                    self.LCImageView1.hidden = NO;
                    self.LCImageView1.showImageView.image = [self.imageDataSource firstObject];
                    self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop).leftSpaceToView(_addInputView,2*k_imageXspace+k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                    
                    [self.addPhotoButton updateLayout];
                    
                }else if(ws.imageDataSource.count == 2){
                    
                    self.LCImageView2.hidden = self.LCImageView1.hidden = NO;
                    self.LCImageView1.showImageView.image = [self.imageDataSource firstObject];
                    self.LCImageView2.showImageView.image = [self.imageDataSource lastObject];
                    
                    
                    self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);

                    [self.addPhotoButton updateLayout];
                    
                    
                }else if(ws.imageDataSource.count == 3){
                    self.LCImageView3.hidden = self.LCImageView2.hidden = self.LCImageView1.hidden = NO;
                    self.LCImageView1.showImageView.image = [self.imageDataSource firstObject];
                    self.LCImageView2.showImageView.image = [self.imageDataSource objectAtIndex:1];
                    self.LCImageView3.showImageView.image = [self.imageDataSource lastObject];
                    
            self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,k_imageXspace).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
            [self.addPhotoButton updateLayout];
                    
                }else if (ws.imageDataSource.count == 4){
                    self.LCImageView4.hidden= self.LCImageView3.hidden = self.LCImageView2.hidden = self.LCImageView1.hidden = NO;
                    
                    self.LCImageView1.showImageView.image = [self.imageDataSource objectAtIndex:0];
                    self.LCImageView2.showImageView.image = [self.imageDataSource objectAtIndex:1];
                    self.LCImageView3.showImageView.image = [self.imageDataSource objectAtIndex:2];
                    self.LCImageView4.showImageView.image = [self.imageDataSource objectAtIndex:3];
                    
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,2*k_imageXspace+k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                    [self.addPhotoButton updateLayout];
                    
                }else if (ws.imageDataSource.count == 5){
                    
                    self.LCImageView5.hidden = self.LCImageView4.hidden= self.LCImageView3.hidden = self.LCImageView2.hidden = self.LCImageView1.hidden = NO;
                    
                    self.LCImageView1.showImageView.image = [self.imageDataSource objectAtIndex:0];
                    self.LCImageView2.showImageView.image = [self.imageDataSource objectAtIndex:1];
                    self.LCImageView3.showImageView.image = [self.imageDataSource objectAtIndex:2];
                    self.LCImageView4.showImageView.image = [self.imageDataSource objectAtIndex:3];
                    self.LCImageView5.showImageView.image = [self.imageDataSource objectAtIndex:4];
                    
              self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                    
                    [self.addPhotoButton updateLayout];
                    
                }else if (ws.imageDataSource.count == 6){
                    self.LCImageView6.hidden = self.LCImageView5.hidden = self.LCImageView4.hidden= self.LCImageView3.hidden = self.LCImageView2.hidden = self.LCImageView1.hidden = NO;
                    
                    self.LCImageView1.showImageView.image = [self.imageDataSource objectAtIndex:0];
                    self.LCImageView2.showImageView.image = [self.imageDataSource objectAtIndex:1];
                    self.LCImageView3.showImageView.image = [self.imageDataSource objectAtIndex:2];
                    self.LCImageView4.showImageView.image = [self.imageDataSource objectAtIndex:3];
                    self.LCImageView5.showImageView.image = [self.imageDataSource objectAtIndex:4];
                    self.LCImageView6.showImageView.image = [self.imageDataSource objectAtIndex:5];
                    
                    self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                    [self.addPhotoButton updateLayout];
                    self.addPhotoButton.hidden = YES;

                }
                self.photoNumLabel.text = [NSString stringWithFormat:@"%u/6",ws.imageDataSource.count];
            }else{
                self.photoNumLabel.text = @"0/6";
            }

            
        }];
    }
}


#pragma mark - 监听通知回调
- (void)keyboardHidden{
    
    if(self.unUsedTextView.inputView){
        self.addButton.selected = NO;

        self.faceButton.selected = NO;
        
        return ;
    }
    
    
    
    
//    if(self.textView.inputView){
//        
//        convertToSystemKeyboard = NO;
//        
//        self.addButton.selected = NO;
//        
//        [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_nor"] forState:UIControlStateNormal];
//        [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_face_heigh"] forState:UIControlStateHighlighted];
//        
//    }
}

- (void)keyboardShow{
    
    
//    if(self.textView.inputView){
//        if([self.textView.inputView isEqual:self.faceInputView]){
//            convertToSystemKeyboard = YES;
//            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_board_nor"] forState:UIControlStateNormal];
//            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"circle_board_heigh"] forState:UIControlStateHighlighted];
//        }
//        if([self.textView.inputView isEqual:self.addInputView]){
//            self.addButton.selected = YES;
//        }
//
//    }
    
}
- (void)keyboardWillChangeFrame:(NSNotification*) notification{
//        NSDictionary* userInfo = notification.userInfo;
    
         //键盘显示\隐藏完毕的frame
//        CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//        //224,0.25
//        NSLog(@"%@---%g",NSStringFromCGRect(frame),duration);
    
    if([self.textView isFirstResponder]){
        
        self.addButton.selected = NO;
        self.faceButton.selected = NO;
    }
    
}


#pragma mark - 懒加载
-(UIView *)addInputView{
    if(!_addInputView){
        _addInputView = [UIView new];
        _addInputView.height = kAddInputViewHeight;
        _addInputView.backgroundColor = RGB(250, 250, 250);
        
        
        LCImagebgView* LCImageView1 = [LCImagebgView new];
        LCImageView1.tag = 401;
        LCImageView1.delegate = self;
        self.LCImageView1 = LCImageView1;
        
        LCImagebgView* LCImageView2 = [LCImagebgView new];
        LCImageView2.tag = 402;
        LCImageView2.delegate = self;
        self.LCImageView2 = LCImageView2;
        
        LCImagebgView* LCImageView3 = [LCImagebgView new];
        LCImageView3.tag = 403;
        LCImageView3.delegate = self;
        self.LCImageView3 = LCImageView3;
        
        LCImagebgView* LCImageView4 = [LCImagebgView new];
        LCImageView4.tag = 404;
        LCImageView4.delegate = self;
        self.LCImageView4 = LCImageView4;
        
        LCImagebgView* LCImageView5 = [LCImagebgView new];
        LCImageView5.tag = 405;
        LCImageView5.delegate = self;
        self.LCImageView5 = LCImageView5;
        
        LCImagebgView* LCImageView6 = [LCImagebgView new];
        LCImageView6.tag = 406;
        LCImageView6.delegate = self;
        self.LCImageView6 = LCImageView6;

        
        
        UIButton* addImageViewbt = [UIButton new];
//        [addImageViewbt setTitle:@"添加" forState:UIControlStateNormal];
//        addImageViewbt.backgroundColor = [UIColor redColor];
        [addImageViewbt setBackgroundImage:[UIImage imageNamed:@"circle_comment_add"] forState:UIControlStateNormal];
        [addImageViewbt addTarget:self action:@selector(clickInputViewCameraAction) forControlEvents:UIControlEventTouchUpInside];
        self.addPhotoButton = addImageViewbt;
        
        UILabel* photoNum = [UILabel new];
        photoNum.textColor = UIColorFromRGB(0x767676);
        photoNum.font = [UIFont systemFontOfSize:smidFont];
        photoNum.textAlignment = NSTextAlignmentCenter;
        self.photoNumLabel = photoNum;
        photoNum.text = @"0/6";
        [_addInputView addSubview:photoNum];
        

        
        [_addInputView sd_addSubviews:@[LCImageView1,LCImageView2,LCImageView3,LCImageView4,LCImageView5, LCImageView6,addImageViewbt]];
        
        LCImageView1.sd_layout.topSpaceToView(_addInputView,k_addTop).leftSpaceToView(_addInputView,k_imageXspace).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
        LCImageView2.sd_layout.topEqualToView(LCImageView1).leftSpaceToView(LCImageView1,k_imageXspace).heightRatioToView(LCImageView1,1).widthEqualToHeight(0);
        
        LCImageView3.sd_layout.topEqualToView(LCImageView1).leftSpaceToView(LCImageView2,k_imageXspace).heightRatioToView(LCImageView1,1).widthEqualToHeight(0);
        
      LCImageView4.sd_layout.topSpaceToView(LCImageView1,k_imageTop).leftSpaceToView(_addInputView,k_imageXspace).heightIs((160-10)/2).widthEqualToHeight(0);
        
        
        LCImageView5.sd_layout.topEqualToView(LCImageView4).leftSpaceToView(LCImageView4,k_imageXspace).heightRatioToView(LCImageView4,1).widthEqualToHeight(0);
        
        LCImageView6.sd_layout.topEqualToView(LCImageView4).leftSpaceToView(LCImageView5,k_imageXspace).heightRatioToView(LCImageView4,1).widthEqualToHeight(0);
        
        
    addImageViewbt.sd_layout.topSpaceToView(_addInputView,k_addTop).leftSpaceToView(_addInputView,k_imageXspace).heightIs(k_imageSingleHeight).widthEqualToHeight(0);

        
    photoNum.sd_layout.topSpaceToView(LCImageView5,15).centerXEqualToView(LCImageView5).widthIs(100).heightIs(20);

//        self.rightbgView.hidden = self.middlebgView.hidden = self.leftbgView.hidden = YES;
self.LCImageView6.hidden = self.LCImageView5.hidden = self.LCImageView4.hidden = self.LCImageView3.hidden = self.LCImageView2.hidden = self.LCImageView1.hidden = YES;
        
        if(self.imageDataSource && self.imageDataSource.count != 0){
            if(self.imageDataSource.count == 1){
                self.LCImageView1.hidden = NO;
                self.LCImageView1.showImageView.image = [self.imageDataSource firstObject];
            self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop).leftSpaceToView(_addInputView,2*k_imageXspace+k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                
                 [self.addPhotoButton updateLayout];
                
            }else if(self.imageDataSource.count == 2){
                
                self.LCImageView2.hidden = self.LCImageView1.hidden = NO;
                self.LCImageView1.showImageView.image = [self.imageDataSource firstObject];
                self.LCImageView2.showImageView.image = [self.imageDataSource lastObject];
                
            self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                
                [self.addPhotoButton updateLayout];
                
                
            }else if(self.imageDataSource.count == 3){
                self.LCImageView3.hidden = self.LCImageView2.hidden = self.LCImageView1.hidden = NO;
                self.LCImageView1.showImageView.image = [self.imageDataSource firstObject];
                self.LCImageView2.showImageView.image = [self.imageDataSource objectAtIndex:1];
                self.LCImageView3.showImageView.image = [self.imageDataSource lastObject];
            self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,k_imageXspace).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                
            [self.addPhotoButton updateLayout];
                
            }else if (self.imageDataSource.count == 4){
            self.LCImageView4.hidden= self.LCImageView3.hidden = self.LCImageView2.hidden = self.LCImageView1.hidden = NO;
                
                self.LCImageView1.showImageView.image = [self.imageDataSource objectAtIndex:0];
                self.LCImageView2.showImageView.image = [self.imageDataSource objectAtIndex:1];
                self.LCImageView3.showImageView.image = [self.imageDataSource objectAtIndex:2];
                self.LCImageView4.showImageView.image = [self.imageDataSource objectAtIndex:3];
                
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,2*k_imageXspace+k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                 [self.addPhotoButton updateLayout];
            
            }else if (self.imageDataSource.count == 5){
                
            self.LCImageView5.hidden = self.LCImageView4.hidden= self.LCImageView3.hidden = self.LCImageView2.hidden = self.LCImageView1.hidden = NO;
                
                self.LCImageView1.showImageView.image = [self.imageDataSource objectAtIndex:0];
                self.LCImageView2.showImageView.image = [self.imageDataSource objectAtIndex:1];
                self.LCImageView3.showImageView.image = [self.imageDataSource objectAtIndex:2];
                self.LCImageView4.showImageView.image = [self.imageDataSource objectAtIndex:3];
                self.LCImageView5.showImageView.image = [self.imageDataSource objectAtIndex:4];
 
         self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                
                [self.addPhotoButton updateLayout];
                
            }else if (self.imageDataSource.count == 6){
             self.LCImageView6.hidden = self.LCImageView5.hidden = self.LCImageView4.hidden= self.LCImageView3.hidden = self.LCImageView2.hidden = self.LCImageView1.hidden = NO;
                
                self.LCImageView1.showImageView.image = [self.imageDataSource objectAtIndex:0];
                self.LCImageView2.showImageView.image = [self.imageDataSource objectAtIndex:1];
                self.LCImageView3.showImageView.image = [self.imageDataSource objectAtIndex:2];
                self.LCImageView4.showImageView.image = [self.imageDataSource objectAtIndex:3];
                self.LCImageView5.showImageView.image = [self.imageDataSource objectAtIndex:4];
               self.LCImageView6.showImageView.image = [self.imageDataSource objectAtIndex:5];
                
            self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                [self.addPhotoButton updateLayout];
                self.addPhotoButton.hidden = YES;

            }
            self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
        }else{
            self.photoNumLabel.text = @"0/6";
        }

    }
          
    return _addInputView;
}

-(UIView *)faceInputView{
    if(!_faceInputView){
        _faceInputView = [UIView new];
        _faceInputView.height = kFaceInputViewHeight;
        _faceInputView.backgroundColor = UIColorFromRGB(0xffffff);
        
        UIScrollView* faceScrollView = [UIScrollView new];
        faceScrollView.showsHorizontalScrollIndicator = NO;
        faceScrollView.pagingEnabled = YES;
        faceScrollView.delegate = self;
        faceScrollView.backgroundColor = UIColorFromRGB(0xfafafa);
//        self.faceScrollView = faceScrollView;
        [_faceInputView addSubview:faceScrollView];

        UIPageControl* pageControl = [UIPageControl new];
        pageControl.pageIndicatorTintColor = RGB(232, 208, 217);
        pageControl.currentPageIndicatorTintColor = RGB(248, 187, 208);
        self.pageControl = pageControl;
        [_faceInputView addSubview:pageControl];

        UIButton* deleteButton = [UIButton new];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"circle_face_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteFaceAction) forControlEvents:UIControlEventTouchUpInside];
        [_faceInputView addSubview:deleteButton];

        //
        UIButton* emojybt = [UIButton new];
        [emojybt setImage:[UIImage imageNamed:@"Hotemoij_default"] forState:UIControlStateNormal];
        emojybt.tag = 301;
        [emojybt addTarget:self action:@selector(convertEmotionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_faceInputView addSubview:emojybt];
        
        UIButton* emotionbt = [UIButton new];
        [emotionbt setImage:[UIImage imageNamed:@"Hotemoij_selec"] forState:UIControlStateNormal];
        emotionbt.tag = 302;
        [emotionbt addTarget:self action:@selector(convertEmotionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_faceInputView addSubview:emotionbt];
        
        if(isEmotion){
            emotionbt.backgroundColor = UIColorFromRGB(0xf2f2f2);
            emojybt.backgroundColor = UIColorFromRGB(0xffffff);
        }else{
            emojybt.backgroundColor = UIColorFromRGB(0xf2f2f2);
            emotionbt.backgroundColor = UIColorFromRGB(0xffffff);
        }

        
        CGFloat width = 33;
        CGFloat height = 33;
        CGFloat horizontalMargin = (kScreenWidth - self.emotionColumn * width) / (self.emotionColumn + 1);
        CGFloat verticalMargin = (kScrollViewHeight - self.emotionRow * height) / (self.emotionRow + 1);

        NSInteger pageTotal = (self.emotionColumn * self.emotionRow);//当前页表情总个数

        NSInteger page = self.defaultEmotionArray.count / pageTotal;
        if(self.defaultEmotionArray.count % pageTotal ){
            page ++ ;
        }
//        NSLog(@"====%ld",self.defaultEmotionArray.count);
        faceScrollView.contentSize = CGSizeMake(kScreenWidth * page, kScrollViewHeight);
        pageControl.numberOfPages = page;

        NSInteger currentPage = 0;
        for(int i = 0; i < self.defaultEmotionArray.count; i++){
            if(i % pageTotal == 0 ){
                //整数
                currentPage = i / pageTotal;
            }
            NSInteger j = (i - currentPage * pageTotal);
            CGFloat x = currentPage * kScreenWidth + horizontalMargin + (width + horizontalMargin) * (j % self.emotionColumn);
            
            //            NSLog(@"---%g",x);
            
            CGFloat y = verticalMargin + (height + verticalMargin) * (j / self.emotionColumn);
            //            NSLog(@"---%ld",self.defaultEmotionArray.count);
            UIButton* emotion = [UIButton new];
            emotion.frame = CGRectMake(x, y, width, height);
            //            emotion.backgroundColor = [UIColor redColor];
            NSDictionary* emotionDic = [self.defaultEmotionArray objectAtIndex:i];
            [emotion setBackgroundImage:[UIImage imageNamed:[emotionDic valueForKey:@"png"]] forState:UIControlStateNormal];
            
            emotion.tag = 200 + i;
            [emotion addTarget:self action:@selector(clickEmotionAction:) forControlEvents:UIControlEventTouchUpInside];
            [faceScrollView addSubview:emotion];
        }
        
        
        
        faceScrollView.sd_layout.topSpaceToView(_faceInputView,0).leftSpaceToView(_faceInputView,0).rightSpaceToView(_faceInputView,0).heightIs(kScrollViewHeight);
        pageControl.sd_layout.topSpaceToView(faceScrollView,20).leftSpaceToView(_faceInputView,0).rightSpaceToView(_faceInputView,0).heightIs(8);
        deleteButton.sd_layout.rightSpaceToView(_faceInputView,0).bottomSpaceToView(_faceInputView,0).widthIs(104/2.0).heightIs(103/2.0);
        emojybt.sd_layout.leftSpaceToView(_faceInputView,0).bottomSpaceToView(_faceInputView,0).widthRatioToView(deleteButton,1).heightRatioToView(deleteButton,1);
        emotionbt.sd_layout.leftSpaceToView(emojybt,0).bottomSpaceToView(_faceInputView,0).widthRatioToView(deleteButton,1).heightRatioToView(deleteButton,1);
        
    }
    return _faceInputView;
}
-(NSMutableArray *)defaultEmotionArray{
    if(!_defaultEmotionArray){
        NSString* emotionPath = [[NSBundle mainBundle] pathForResource:@"EmotionPlist" ofType:@"plist"];
        
        _defaultEmotionArray = [NSMutableArray arrayWithContentsOfFile:emotionPath];
        NSMutableArray* tempArray = [NSMutableArray array];
        if(isEmotion){
            //移除emojy表情
            for(NSDictionary* dic in _defaultEmotionArray){
                if(![dic valueForKey:@"isEmotion"]){
                    [tempArray addObject:dic];
                }
            }
            
        }else{
            //移除自定义表情
            for(NSDictionary* dic in _defaultEmotionArray){
                if([dic valueForKey:@"isEmotion"]){
                    [tempArray addObject:dic];
                }
            }
            
        }
        
        [_defaultEmotionArray removeObjectsInArray:tempArray];
    }
    return _defaultEmotionArray;
}


#pragma mark - 代理
#pragma mark * textView代理
-(void)textViewDidChange:(UITextView *)textView{
    self.sendButton.selected = [textView.text trimming].length != 0;
}
#pragma mark * scrollView代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.x / kScreenWidth == (int)(scrollView.contentOffset.x / kScreenWidth)){
        self.pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
    }
}
#pragma mark * 删除照片

-(void)deleteImageViewWith:(LCImagebgView *)lcImagebgView{
    if(lcImagebgView.tag == 401){
        //左边图片
        if(self.imageDataSource.count == 1){
            //一张图片
            [UIView animateWithDuration:.2f animations:^{
            self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop).leftSpaceToView(_addInputView,k_imageXspace).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                 [self.addPhotoButton updateLayout];

                self.LCImageView1.hidden = YES;
                   self.addPhotoButton.hidden = NO;
            }completion:^(BOOL finished) {
//                self.leftbgView.showImageView = nil;
                self.LCImageView1.showImageView.image = nil;
                [self.imageDataSource removeLastObject];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%u/6",self.imageDataSource.count];
            }];
        }else if(self.imageDataSource.count == 2){
            [UIView animateWithDuration:.2f animations:^{
                
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop).leftSpaceToView(_addInputView,2*k_imageXspace+k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                [self.addPhotoButton updateLayout];
                   self.addPhotoButton.hidden = NO;
                
                self.LCImageView2.hidden = YES;
            }completion:^(BOOL finished) {
                self.LCImageView1.showImageView.image = self.LCImageView2.showImageView.image;
                self.LCImageView2.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:0];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
            }];
        }else if(self.imageDataSource.count == 3){
            [UIView animateWithDuration:.2f animations:^{
                
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                  [self.addPhotoButton updateLayout];
                
                self.addPhotoButton.hidden = NO;
                self.LCImageView3.hidden = YES;
            }completion:^(BOOL finished) {
                
                self.LCImageView1.showImageView.image =self.LCImageView2.showImageView.image;
                self.LCImageView2.showImageView.image = self.LCImageView3.showImageView.image;
                self.LCImageView3.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:0];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
            }];

        }else if(self.imageDataSource.count == 4){
            [UIView animateWithDuration:.2f animations:^{
                
    self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,k_imageXspace).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
        [self.addPhotoButton updateLayout];
                
                    self.addPhotoButton.hidden = NO;
                    self.LCImageView4.hidden = YES;
            }completion:^(BOOL finished) {
                
                self.LCImageView1.showImageView.image =self.LCImageView2.showImageView.image;
                self.LCImageView2.showImageView.image = self.LCImageView3.showImageView.image;
                self.LCImageView3.showImageView.image = self.LCImageView4.showImageView.image;
                self.LCImageView4.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:0];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
            }];
            
        }else if(self.imageDataSource.count == 5){
            [UIView animateWithDuration:.2f animations:^{
                
     self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,2*k_imageXspace+k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                [self.addPhotoButton updateLayout];
                
                        self.addPhotoButton.hidden = NO;
                        self.LCImageView5.hidden = YES;
            }completion:^(BOOL finished) {
                
                self.LCImageView1.showImageView.image =self.LCImageView2.showImageView.image;
                self.LCImageView2.showImageView.image = self.LCImageView3.showImageView.image;
                self.LCImageView3.showImageView.image = self.LCImageView4.showImageView.image;
                self.LCImageView4.showImageView.image = self.LCImageView5.showImageView.image;
                self.LCImageView5.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:0];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
            }];
            
        }else if(self.imageDataSource.count == 6){
            [UIView animateWithDuration:.2f animations:^{
                
            self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);

                [self.addPhotoButton updateLayout];
                
                    self.addPhotoButton.hidden = NO;
                    self.LCImageView6.hidden = YES;
            }completion:^(BOOL finished) {
                
                self.LCImageView1.showImageView.image =self.LCImageView2.showImageView.image;
                self.LCImageView2.showImageView.image = self.LCImageView3.showImageView.image;
                self.LCImageView3.showImageView.image = self.LCImageView4.showImageView.image;
                self.LCImageView4.showImageView.image = self.LCImageView5.showImageView.image;
                self.LCImageView5.showImageView.image = self.LCImageView6.showImageView.image;
                self.LCImageView6.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:0];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
            }];
            
        }



    }else if(lcImagebgView.tag == 402){
        //中间图片
        if(self.imageDataSource.count == 2){
            [UIView animateWithDuration:.2f animations:^{
                
        self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop).leftSpaceToView(_addInputView,2*k_imageXspace+k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                
                [self.addPhotoButton updateLayout];
                self.addPhotoButton.hidden = NO;
                self.LCImageView2.hidden = YES;
            }completion:^(BOOL finished) {
                self.LCImageView2.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:1];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
            }];
        }else if(self.imageDataSource.count == 3){
            [UIView animateWithDuration:.2f animations:^{
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                [self.addPhotoButton updateLayout];

                self.addPhotoButton.hidden = NO;
                self.LCImageView3.hidden = YES;
            }completion:^(BOOL finished) {
                
                self.LCImageView2.showImageView.image = self.LCImageView3.showImageView.image;
                self.LCImageView3.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:1];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];

            }];
            
        }else if(self.imageDataSource.count == 4){
            [UIView animateWithDuration:.2f animations:^{
            self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,k_imageXspace).heightIs(k_imageSingleHeight).widthEqualToHeight(0);

                [self.addPhotoButton updateLayout];
                
                self.addPhotoButton.hidden = NO;
                self.LCImageView4.hidden = YES;
            }completion:^(BOOL finished) {
                
                self.LCImageView2.showImageView.image = self.LCImageView3.showImageView.image;
                self.LCImageView3.showImageView.image = self.LCImageView4.showImageView.image;
                self.LCImageView4.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:1];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
                
            }];
            
        }else if(self.imageDataSource.count == 5){
            [UIView animateWithDuration:.2f animations:^{
     self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,2*k_imageXspace+k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                [self.addPhotoButton updateLayout];
                
                self.addPhotoButton.hidden = NO;
                self.LCImageView5.hidden = YES;
            }completion:^(BOOL finished) {
                self.LCImageView2.showImageView.image = self.LCImageView3.showImageView.image;
                self.LCImageView3.showImageView.image = self.LCImageView4.showImageView.image;
                self.LCImageView4.showImageView.image = self.LCImageView5.showImageView.image;
                self.LCImageView5.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:1];
    
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
                
            }];
            
        }else if(self.imageDataSource.count == 6){
            [UIView animateWithDuration:.2f animations:^{
            self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);

                [self.addPhotoButton updateLayout];
                
            self.addPhotoButton.hidden = NO;
            self.LCImageView6.hidden = YES;
            }completion:^(BOOL finished) {
                
                self.LCImageView2.showImageView.image = self.LCImageView3.showImageView.image;
                self.LCImageView3.showImageView.image = self.LCImageView4.showImageView.image;
                self.LCImageView4.showImageView.image = self.LCImageView5.showImageView.image;
                self.LCImageView5.showImageView.image = self.LCImageView6.showImageView.image;
                self.LCImageView6.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:1];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
                
            }];
            
        }




    }else if(lcImagebgView.tag == 403){
        //第三章图片
        
        if(self.imageDataSource.count == 3){
            [UIView animateWithDuration:.2f animations:^{
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                [self.addPhotoButton updateLayout];
                self.LCImageView3.hidden = YES;
                self.addPhotoButton.hidden = NO;
                
            }completion:^(BOOL finished) {
                
                self.LCImageView3.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:2];
                 self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
                
            }];
            
        }else if(self.imageDataSource.count == 4){
            [UIView animateWithDuration:.2f animations:^{
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,k_imageXspace).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                
                [self.addPhotoButton updateLayout];
                
                self.addPhotoButton.hidden = NO;
                self.LCImageView4.hidden = YES;
            }completion:^(BOOL finished) {
                
               
                self.LCImageView3.showImageView.image = self.LCImageView4.showImageView.image;
                self.LCImageView4.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:2];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
                
            }];
            
        }else if(self.imageDataSource.count == 5){
            [UIView animateWithDuration:.2f animations:^{
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,2*k_imageXspace+k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                [self.addPhotoButton updateLayout];
                
            self.addPhotoButton.hidden = NO;
            self.LCImageView5.hidden = YES;
            }completion:^(BOOL finished) {
               
                self.LCImageView3.showImageView.image = self.LCImageView4.showImageView.image;
                self.LCImageView4.showImageView.image = self.LCImageView5.showImageView.image;
                self.LCImageView5.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:2];
                
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
                
            }];
            
        }else if(self.imageDataSource.count == 6){
            [UIView animateWithDuration:.2f animations:^{
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                
                [self.addPhotoButton updateLayout];
                
                self.addPhotoButton.hidden = NO;
                self.LCImageView6.hidden = YES;
            }completion:^(BOOL finished) {
                
             
                self.LCImageView3.showImageView.image = self.LCImageView4.showImageView.image;
                self.LCImageView4.showImageView.image = self.LCImageView5.showImageView.image;
                self.LCImageView5.showImageView.image = self.LCImageView6.showImageView.image;
                self.LCImageView6.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:2];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
                
            }];
            
        }
    }else  if(lcImagebgView.tag == 404){
        //第4张图片
        
          if(self.imageDataSource.count == 4){
            [UIView animateWithDuration:.2f animations:^{
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,k_imageXspace).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                
                [self.addPhotoButton updateLayout];
                self.addPhotoButton.hidden = NO;
               self.LCImageView4.hidden = YES;
            }completion:^(BOOL finished) {
                [self.imageDataSource removeObjectAtIndex:3];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
                
            }];
            
        }else if(self.imageDataSource.count == 5){
            [UIView animateWithDuration:.2f animations:^{
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,2*k_imageXspace+k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                [self.addPhotoButton updateLayout];
                
                    self.addPhotoButton.hidden = NO;
                    self.LCImageView5.hidden = YES;
            }completion:^(BOOL finished) {
                
            
                self.LCImageView4.showImageView.image = self.LCImageView5.showImageView.image;
                self.LCImageView5.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:3];
                
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
                
            }];
            
        }else if(self.imageDataSource.count == 6){
            [UIView animateWithDuration:.2f animations:^{
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                
                [self.addPhotoButton updateLayout];
                
            self.addPhotoButton.hidden = NO;
            self.LCImageView6.hidden = YES;
            }completion:^(BOOL finished) {
                self.LCImageView4.showImageView.image = self.LCImageView5.showImageView.image;
                self.LCImageView5.showImageView.image = self.LCImageView6.showImageView.image;
                self.LCImageView6.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:3];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
                
            }];
            
        }
    }else  if(lcImagebgView.tag == 405){
        //第5张图片
        
          if(self.imageDataSource.count == 5){
            [UIView animateWithDuration:.2f animations:^{
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,2*k_imageXspace+k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                [self.addPhotoButton updateLayout];
                  self.addPhotoButton.hidden = NO;
                self.LCImageView5.hidden = YES;
            }completion:^(BOOL finished) {
                
                [self.imageDataSource removeObjectAtIndex:4];
                
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
                
            }];
            
        }else if(self.imageDataSource.count == 6){
            [UIView animateWithDuration:.2f animations:^{
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                
                [self.addPhotoButton updateLayout];
                
                self.addPhotoButton.hidden = NO;
                self.LCImageView6.hidden = YES;
            }completion:^(BOOL finished) {
                
                
                self.LCImageView5.showImageView.image = self.LCImageView6.showImageView.image;
                self.LCImageView6.showImageView.image = nil;
                [self.imageDataSource removeObjectAtIndex:4];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
                
            }];
            
        }
    }else  if(lcImagebgView.tag == 406){
        //第6张图片
        
        if(self.imageDataSource.count == 6){
            [UIView animateWithDuration:.2f animations:^{
                self.addPhotoButton.sd_layout.topSpaceToView(_addInputView,k_addTop+k_imageSingleHeight+k_imageTop).leftSpaceToView(_addInputView,3*k_imageXspace+2*k_imageSingleHeight).heightIs(k_imageSingleHeight).widthEqualToHeight(0);
                
                [self.addPhotoButton updateLayout];
                self.addPhotoButton.hidden = NO;
                self.LCImageView6.hidden = YES;
            }completion:^(BOOL finished) {
                
                
                [self.imageDataSource removeObjectAtIndex:5];
                self.photoNumLabel.text = [NSString stringWithFormat:@"%lu/6",self.imageDataSource.count];
                
            }];
            
        }
    }



}


#pragma mark - dealloc
-(void)dealloc{
    
    [kdefaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [kdefaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [kdefaultCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

    
    if(self.unUsedTextView.inputView){
        self.unUsedTextView.inputView = nil;
        [self.unUsedTextView reloadInputViews];
    }
//    [self.textView resignFirstResponder];

}

#pragma mark - setter
-(void)setHiddenAddButton:(BOOL)hiddenAddButton{
    _hiddenAddButton = hiddenAddButton;
    
    if(!hiddenAddButton) return ;
    
    self.addButton.hidden = hiddenAddButton;
    
    [self.faceButton sd_resetLayout];
    
    self.faceButton.sd_layout.centerYEqualToView(self).leftSpaceToView(self,5).widthIs(55/2.0).heightEqualToWidth();
    [self.faceButton updateLayout];

    
}






@end
