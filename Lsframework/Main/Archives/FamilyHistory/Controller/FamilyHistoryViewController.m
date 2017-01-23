//
//  FamilyHistoryViewController.m
//  FamilyPlatForm
//
//  Created by Tom on 16/3/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//  家庭史


#import "FamilyHistoryViewController.h"
#import "GesImageView.h"
#import "FPDropView.h"
#import "FPButton.h"
#import "GrowthStatusViewController.h"
#import "MenuEntity.h"


@interface FamilyHistoryViewController ()<UITextFieldDelegate,FamilyHistoryPresenterDelegate>
{
    UIScrollView *_scrollView;
    
    GesImageView *_inheritanceView;
    
    UIImageView *_fatherImageView;
    UITextField *_fatherAge;
    UITextField *_fatherCulture;
    GesImageView *_fatherDisease;
    
    UIImageView *_motherImageView;
    UITextField *_motherAge;
    UITextField *_motherCulture;
    GesImageView *_motherDisease;
    
    FPButton *_backButton;
    FPButton *_nextButton;
    
    BOOL _isFinish;
}

@property (nonatomic ,strong)FPDropView *popView;

@property(nonatomic,retain) FamilyHistoryPresenter* presenter;

@end

@implementation FamilyHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initRightBarWithTitle:@"完成"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.title = @"家庭史";
    
    self.presenter=[FamilyHistoryPresenter new];
    self.presenter.delegate=self;
//    self.childForm = [ChildForm new];
    [self setupImageView];
    [self setupScrollView];
    [self setupInheritance];
    [self setupFatherView];
    [self setupMotherView];
    [self setupButtons];
}

- (FPDropView *)popView{
    if (!_popView) {
        NSArray *cultureArray = [MenuEntity MR_findByAttribute:@"parentId" withValue:@390];
        NSArray *sortedArray = [cultureArray sortedArrayUsingComparator:^NSComparisonResult(MenuEntity *entity_1, MenuEntity *entity_2){
            return [entity_1.menuId compare:entity_2.menuId];
        }];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (MenuEntity *entity in sortedArray) {
            [titleArray addObject:entity.dictionaryName];
        }

        _popView = [FPDropView new];
        _popView.height = 120;
        _popView.itemHeight = 20;
        _popView.textAlignment = NSTextAlignmentCenter;
        _popView.titles = titleArray;
        _popView.font = [UIFont systemFontOfSize:kScreenWidth == 320 ? 12 : 14];
        if (kScreenWidth == 320) {
            _popView.isFamily = YES;
        }
//        [_popView setSelectedHandler:^BOOL(NSUInteger selection) {
//            
//        }];
    }
    return _popView;
}

- (void)setupImageView{
    UIImageView *imageView = [UIImageView new];
    imageView.frame = self.view.bounds;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"family"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
}
- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
//    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, 434);
}
- (void)setupInheritance{
    _inheritanceView = [GesImageView new];
    _inheritanceView.image = [self stretchableImageWithImageName:@"text_nor"];
    [_scrollView addSubview:_inheritanceView];
    _inheritanceView.titleLabel.text = @"家庭遗传史:";
    _inheritanceView.selectGroup.selection = 0;

    _inheritanceView.titleLabel.textColor=FileFontColor;
    _inheritanceView.sd_layout.leftSpaceToView(_scrollView,25).topSpaceToView(_scrollView,15).rightSpaceToView(_scrollView,25).heightIs(65);
    _inheritanceView.layer.cornerRadius = _inheritanceView.height/2;
    _inheritanceView.clipsToBounds = YES;
}

- (void)setupFatherView{
    _fatherImageView = [UIImageView new];
    _fatherImageView.image = [self stretchableImageWithImageName:@"text_nor"];
    _fatherImageView.clipsToBounds = YES;
    _fatherImageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_fatherImageView];
    _fatherImageView.sd_layout.leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25).topSpaceToView(_inheritanceView,15).heightIs(130);
    _fatherImageView.layer.cornerRadius = _fatherImageView.height/4;
    UILabel *fatherNameLabel = [UILabel new];
    fatherNameLabel.text = @"父       亲:";
    fatherNameLabel.textColor = FileFontColor;
    [_fatherImageView addSubview:fatherNameLabel];
    fatherNameLabel.sd_layout.leftSpaceToView(_fatherImageView,25).topSpaceToView(_fatherImageView,8).widthIs(100).heightIs(25);
    //生育年龄
    UILabel *ageLabel = [UILabel new];
    ageLabel.text = @"生育年龄";
    ageLabel.textColor = FileFontColor;
    [_fatherImageView addSubview:ageLabel];
    ageLabel.sd_layout.leftSpaceToView(_fatherImageView,(kScreenWidth == 320 ? 110 : 130)).topSpaceToView(_fatherImageView,8).widthIs(70).heightIs(25);
    
    _fatherAge = [UITextField new];
    _fatherAge.delegate = self;
    _fatherAge.textColor = FileFontColor;
    _fatherAge.keyboardType = UIKeyboardTypeNumberPad;
    _fatherAge.background = [self stretchableImageWithImageName:@"text_nor"];
    
    [_fatherImageView addSubview:_fatherAge];
    _fatherAge.sd_layout.leftSpaceToView(ageLabel,5).rightSpaceToView(_fatherImageView,15).topSpaceToView(_fatherImageView,8).heightIs(25);
    _fatherAge.layer.cornerRadius = _fatherAge.height/2;
    _fatherAge.textAlignment = NSTextAlignmentCenter;
    //文化程度
    UILabel *cultuleLabel = [UILabel new];
    cultuleLabel.text = @"文化程度";
    cultuleLabel.textColor = FileFontColor;
    [_fatherImageView addSubview:cultuleLabel];
    cultuleLabel.sd_layout.leftSpaceToView(_fatherImageView,(kScreenWidth == 320 ? 110 : 130)).topSpaceToView(ageLabel,8).widthIs(70).heightIs(25);
    
    _fatherCulture = [UITextField new];
    _fatherCulture.delegate = self;
    _fatherCulture.clipsToBounds = YES;
    _fatherCulture.textColor = FileFontColor;
    _fatherCulture.background = [self stretchableImageWithImageName:@"text_nor"];
    _fatherCulture.textAlignment = NSTextAlignmentCenter;
    [_fatherImageView addSubview:_fatherCulture];
    _fatherCulture.sd_layout.leftSpaceToView(ageLabel,5).rightSpaceToView(_fatherImageView,15).topSpaceToView(_fatherAge,8).heightIs(25);
    _fatherCulture.layer.cornerRadius = _fatherCulture.height/2;
    //曾患疾病
    _fatherDisease = [GesImageView new];
    _fatherDisease.clipsToBounds = YES;
    [_fatherImageView addSubview:_fatherDisease];
    _fatherDisease.selectGroup.selection = 0;
    _fatherDisease.titleLabel.text = @"曾患疾病:";
    _fatherDisease.sd_layout.leftSpaceToView(_fatherImageView,0).topSpaceToView(_fatherCulture,0).rightSpaceToView(_fatherImageView,0).heightIs(65);
    _fatherDisease.layer.cornerRadius = _fatherDisease.height/2;
    
}
- (void)setupMotherView{
    _motherImageView = [UIImageView new];
    _motherImageView.image = [self stretchableImageWithImageName:@"text_nor"];
    _motherImageView.clipsToBounds = YES;
    _motherImageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_motherImageView];
    _motherImageView.sd_layout.leftSpaceToView(_scrollView,25).rightSpaceToView(_scrollView,25).topSpaceToView(_fatherImageView,15).heightIs(130);
    _motherImageView.layer.cornerRadius = _motherImageView.height/4;
    UILabel *motherNameLabel = [UILabel new];
    motherNameLabel.text = @"母       亲:";
    motherNameLabel.textColor = FileFontColor;
    [_motherImageView addSubview:motherNameLabel];
    motherNameLabel.sd_layout.leftSpaceToView(_motherImageView,25).topSpaceToView(_motherImageView,8).widthIs(100).heightIs(25);
    
    UILabel *ageLabel = [UILabel new];
    ageLabel.text = @"生育年龄";
    ageLabel.textColor =FileFontColor;
    [_motherImageView addSubview:ageLabel];
    ageLabel.sd_layout.leftSpaceToView(_motherImageView,(kScreenWidth == 320 ? 110 : 130)).topSpaceToView(_motherImageView,8).widthIs(70).heightIs(25);
    
    _motherAge = [UITextField new];
    _motherAge.delegate = self;
    _motherAge.textColor = FileFontColor;
    _motherAge.keyboardType = UIKeyboardTypeNumberPad;
    _motherAge.background = [self stretchableImageWithImageName:@"text_nor"];
    
    [_motherImageView addSubview:_motherAge];
    _motherAge.sd_layout.leftSpaceToView(ageLabel,5).rightSpaceToView(_motherImageView,15).topSpaceToView(_motherImageView,8).heightIs(25);
    _motherAge.layer.cornerRadius = _motherAge.height/2;
    _motherAge.textAlignment = NSTextAlignmentCenter;
    
    UILabel *cultuleLabel = [UILabel new];
    cultuleLabel.text = @"文化程度";
    cultuleLabel.textColor = FileFontColor;
    [_motherImageView addSubview:cultuleLabel];
    cultuleLabel.sd_layout.leftSpaceToView(_motherImageView,(kScreenWidth == 320 ? 110 : 130)).topSpaceToView(ageLabel,8).widthIs(70).heightIs(25);
    
    _motherCulture = [UITextField new];
    _motherCulture.delegate = self;
    _motherCulture.clipsToBounds = YES;
    _motherCulture.textColor = FileFontColor;
    _motherCulture.background = [self stretchableImageWithImageName:@"text_nor"];
    _motherCulture.textAlignment = NSTextAlignmentCenter;
    [_motherImageView addSubview:_motherCulture];
    _motherCulture.sd_layout.leftSpaceToView(ageLabel,5).rightSpaceToView(_motherImageView,15).topSpaceToView(_motherAge,8).heightIs(25);
    _motherCulture.layer.cornerRadius = _motherCulture.height/2;
    
    _motherDisease = [GesImageView new];
    _motherDisease.clipsToBounds = YES;
    [_motherImageView addSubview:_motherDisease];
    _motherDisease.titleLabel.text = @"曾患疾病:";
    _motherDisease.selectGroup.selection = 0;
    _motherDisease.sd_layout.leftSpaceToView(_motherImageView,0).topSpaceToView(_motherCulture,0).rightSpaceToView(_motherImageView,0).heightIs(65);
    _motherDisease.layer.cornerRadius = _motherDisease.height/2;
}

- (void)setupButtons{
    //上一步按钮
    _backButton = [FPButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"上一步" forState:UIControlStateNormal];
    [_backButton setBackgroundImage:[self stretchableImageWithImageName:@"back_nor"] forState:UIControlStateNormal];
    [_backButton setBackgroundImage:[self stretchableImageWithImageName:@"back_sel"] forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(fBackAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_backButton];
    _backButton.sd_layout.leftSpaceToView(_scrollView,25).topSpaceToView(_motherImageView,15).widthIs(kScreenWidth/2-30).heightIs(40);
    _backButton.cornerRadius = _backButton.height/2;
    
    //下一步按钮
    _nextButton = [FPButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:[self stretchableImageWithImageName:@"next_nor1"] forState:UIControlStateNormal];
    [_nextButton setBackgroundImage:[self stretchableImageWithImageName:@"next_sel1"] forState:UIControlStateHighlighted];
    [_nextButton addTarget:self action:@selector(fNextAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_nextButton];
    _nextButton.sd_layout.topSpaceToView(_motherImageView,15).rightSpaceToView(_scrollView,25).widthIs(_backButton.width).heightIs(_backButton.height);
    _nextButton.cornerRadius = _nextButton.height/2;
}

#pragma mark - 代理
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:_fatherAge] || [textField isEqual:_motherAge]) {
        ((UIImageView *)textField.superview).image = [self stretchableImageWithImageName:@"text_sel"];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:_fatherAge] || [textField isEqual:_motherAge]) {
        ((UIImageView *)textField.superview).image = [self stretchableImageWithImageName:@"text_nor"];
        textField.textAlignment = NSTextAlignmentCenter;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    if ([textField isEqual:_fatherCulture] || [textField isEqual:_motherCulture]) {
//        [self.popView showInController:self parentView:textField];
//        __weak __typeof(textField)weakTf = textField;
//        __weak __typeof(_popView)weakPop = _popView;
//        [_popView setSelectedHandler:^BOOL(NSUInteger selection) {
//            weakTf.text = weakPop.titles[selection];
//            return YES;
//        }];
//        return NO;
//    }
//
//    return YES;

    //文化程度
    NSArray *cultureArray = [MenuEntity MR_findByAttribute:@"parentId" withValue:@390];
    NSArray *sortedArray = [cultureArray sortedArrayUsingComparator:^NSComparisonResult(MenuEntity *entity_1, MenuEntity *entity_2){
        return [entity_1.menuId compare:entity_2.menuId];
    }];
    
    WS(ws);
    if([textField isEqual:_fatherCulture]){
        
        [self.popView showInController:self parentView:textField];
        __weak __typeof(textField)weakTf = textField;
        __weak __typeof(_popView)weakPop = _popView;
        [_popView setSelectedHandler:^BOOL(NSUInteger selection) {
            weakTf.text = weakPop.titles[selection];;
            ws.childForm.fatherEducation = [((MenuEntity *)sortedArray[selection]).menuId integerValue];
            return YES;
        }];
        return NO;
    }else if([textField isEqual:_motherCulture]){
        [self.popView showInController:self parentView:textField];
        __weak __typeof(textField)weakTf = textField;
        __weak __typeof(_popView)weakPop = _popView;
        [_popView setSelectedHandler:^BOOL(NSUInteger selection) {
            weakTf.text = weakPop.titles[selection];
            ws.childForm.motherEducation = [((MenuEntity *)sortedArray[selection]).menuId integerValue];
            return YES;
        }];
        return NO;
    }
    return YES;

}

-(void)onCommitComplete:(BOOL)success info:(NSString *)info{
    if(success){
        if(_isFinish){
        
        }else{
            _isFinish = NO;
            
            [ProgressUtil dismiss];
            
            GrowthStatusViewController* grow = [GrowthStatusViewController new];
            grow.childForm = self.childForm;
            grow.poptoClass = self.poptoClass;
            [self.navigationController pushViewController:grow animated:YES];

        }
        
        
    }else{
        [ProgressUtil showError:info];
    }
}

#pragma mark Action
- (void)fBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)fNextAction{
//    [self.navigationController pushViewController:[GrowthStatusViewController new] animated:YES];
    
    //家族遗传史
    if (self.childForm.historyMark!=nil&&self.childForm.historyMark.length!=0) {
        _inheritanceView.currentSelect=1;
    }

    self.childForm.history = _inheritanceView.currentSelect;
    self.childForm.historyMark = _inheritanceView.currentSelect?_inheritanceView.textField.text: nil;
    //父亲
    self.presenter.fatherAge=_fatherAge.text;
    self.childForm.fatherEverDisease = _fatherDisease.currentSelect;
    self.childForm.fatherEverDiseaseMark = _fatherDisease.currentSelect?_fatherDisease.textField.text: nil;
    //母亲
    self.childForm.motherBearAge=[_motherAge.text integerValue];
    self.presenter.motherAge=_motherAge.text;
    self.childForm.motherEverDisease = _motherDisease.currentSelect;
    self.childForm.motherEverDiseaseMark = _motherDisease.currentSelect?_motherDisease.textField.text: nil;

    [ProgressUtil show];
    [self.presenter commitFamilyHistory:self.childForm];
}

-(void)rightItemAction:(id)sender{
    _isFinish = YES;
    //家族遗传史
    if (self.childForm.historyMark!=nil&&self.childForm.historyMark.length!=0) {
        _inheritanceView.currentSelect=1;
    }

    self.childForm.history = _inheritanceView.currentSelect;
    self.childForm.historyMark = _inheritanceView.currentSelect?_inheritanceView.textField.text: nil;
    //父亲
    self.presenter.fatherAge=_fatherAge.text;
    self.childForm.fatherEverDisease = _fatherDisease.currentSelect;
    self.childForm.fatherEverDiseaseMark = _fatherDisease.currentSelect?_fatherDisease.textField.text: nil;
    //母亲
    self.childForm.motherBearAge=[_motherAge.text integerValue];
    self.presenter.motherAge=_motherAge.text;
    self.childForm.motherEverDisease = _motherDisease.currentSelect;
    self.childForm.motherEverDiseaseMark = _motherDisease.currentSelect?_motherDisease.textField.text: nil;
    
    [self.presenter commitFamilyHistory:self.childForm];

    if (self.poptoClass) {
        UIViewController * back;
        for (UIViewController * vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:self.poptoClass]) {
                back = vc;
                break;
            }
        }
        if (back) {
            [self.navigationController popToViewController:back animated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        [self presentViewController:[TabbarViewController new] animated:YES completion:nil];
    }

}

#pragma mark
- (UIImage *)stretchableImageWithImageName:(NSString *)imageName{
    //裁减拉伸图片
    UIImage *image = [UIImage imageNamed:imageName];
    CGRect myImageRect = CGRectMake(image.size.width/2 - 1, image.size.height/2 -1 , 3, 3);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size = CGSizeMake(myImageRect.size.width, myImageRect.size.height);
    UIGraphicsBeginImageContext (size);
    CGContextRef context = UIGraphicsGetCurrentContext ();
    CGContextDrawImage (context, myImageRect, subImageRef);
    UIImage *newImage = [UIImage imageWithCGImage :subImageRef];
    UIGraphicsEndImageContext ();
    image = [newImage stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:0];
    return image;
}

- (void)hiddenButton{
    _backButton.hidden = YES;
    _nextButton.hidden = YES;
}

- (void)vc_4_save:(Complete)block{
    //家族遗传史
    if (self.childForm.historyMark!=nil&&self.childForm.historyMark.length!=0) {
        _inheritanceView.currentSelect=1;
    }

    self.childForm.history = _inheritanceView.currentSelect;
    self.childForm.historyMark = _inheritanceView.currentSelect?_inheritanceView.textField.text: nil;
    //父亲
    self.childForm.fatherBearAge=[_fatherAge.text integerValue];
    self.childForm.fatherEverDisease = _fatherDisease.currentSelect;
    self.childForm.fatherEverDiseaseMark = _fatherDisease.currentSelect?_fatherDisease.textField.text: nil;
    //母亲
    self.childForm.motherBearAge=[_motherAge.text integerValue];
    self.childForm.motherEverDisease = _motherDisease.currentSelect;
    self.childForm.motherEverDiseaseMark = _motherDisease.currentSelect?_motherDisease.textField.text: nil;
    
    [ProgressUtil show];
    [self.presenter commitFamilyHistory:self.childForm block:^(BOOL success, NSString *message) {
        block(success ,message);
    }];
}

- (void)loadData:(ChildForm *)child{
    
    self.childForm = child;
    
    if (!(self.childForm.historyMark!=nil&&self.childForm.historyMark.length!=0)) {
        _inheritanceView.selectGroup.selection = 0;
    }else {
        _inheritanceView.selectGroup.selection = 1;
        _inheritanceView.currentSelect = 1;
        [_inheritanceView showText];
        _inheritanceView.textField.text = child.historyMark;
    }
    _fatherAge.text = [NSString stringWithFormat:@"%ld",(long)child.fatherBearAge];
    _fatherCulture.text = [self findDicNameBy:child.fatherEducation];
    
    if (child.fatherEverDisease == 0) {
        _fatherDisease.selectGroup.selection = 0;
    }else if (child.fatherEverDisease == 1){
        _fatherDisease.selectGroup.selection = 1;
        _fatherDisease.currentSelect = 1;
        [_fatherDisease showText];
        _fatherDisease.textField.text = child.fatherEverDiseaseMark;
    }
    
    _motherAge.text = [NSString stringWithFormat:@"%ld",(long)child.motherBearAge];
    _motherCulture.text = [self findDicNameBy:child.fatherEducation];
    
    if (child.motherEverDisease == 0) {
        _motherDisease.selectGroup.selection = 0;
    }else if (child.motherEverDisease == 1){
        _motherDisease.selectGroup.selection = 1;
        _motherDisease.currentSelect = 1;
        [_motherDisease showText];
        _motherDisease.textField.text = child.motherEverDiseaseMark;
    }
    
    
}

- (NSString *)findDicNameBy:(NSInteger)menuId{
    NSArray *array = [MenuEntity MR_findByAttribute:@"menuId" withValue:@(menuId)];
    if (array.count > 0) {
        MenuEntity *entity = array[0];
        return entity.dictionaryName;
    }
    return @"";
}
@end
