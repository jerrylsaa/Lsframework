//
//  ACPhoneConsultationViewController.m
//  FamilyPlatForm
//
//  Created by tom on 16/3/29.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "ACPhoneConsultationViewController.h"
#import "GCPlaceholderTextView.h"
#import "ACPhoneConsultationPresenter.h"
#import "ACDiagnoseFlowViewController.h"
#import "OrderSubmitViewController.h"
#import "JHCustomMenu.h"
#import "ImageWidget.h"
#import "FPTextField.h"
#import "LeftTitleTextField.h"
#import "ACPhoneConsultationPresenter.h"

#define AC_FONT [UIFont systemFontOfSize:(kScreenWidth == 320 ? 14 : 18)]

@interface ACPhoneConsultationViewController ()<JHCustomMenuDelegate,ACPhoneConsultationPresenterDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_headImageView;//头像
    UILabel *_nameLabel;//姓名
    UILabel *_priceLabel;//收费
    UILabel *_talkTimeLabel;//通话时间
//    UILabel *_phoneLabel;//接听号码
//    UITextField* _phonetf;
//    FPTextField* _phonetf;
    LeftTitleTextField* _phonetf;
    UILabel *_patientLabel;//患者姓名
    UIButton *_patientButton;
//    NSArray *_patientArray;
    //疾病名称
    UIView *_diseaseView;
    UILabel *_diseaseLabel;
    UITextField *_diseaseText;
    //病情信息
    UIView *_descriuption;
    UILabel *_descriptionLabel;
    GCPlaceholderTextView *_descriptionText;
    UILabel *_picLabel;
    ImageWidget *_picCollectionView;//添加图片
    UIButton *_commitButton;//提交按钮
    
    NSString* patientName;
    NSString* feeTime;
    
}
@property (nonatomic ,strong)JHCustomMenu *patientMenu;

@property(nonatomic,retain) ACPhoneConsultationPresenter* presenter;

@property(nonatomic,retain) NSMutableArray<NSString* > * patientArray;

@end

@implementation ACPhoneConsultationViewController

-(NSMutableArray *)patientArray{
    if(!_patientArray){
        _patientArray=[NSMutableArray array];
    }
    return _patientArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    self.title = @"电话咨询";
    self.presenter = [ACPhoneConsultationPresenter new];
    self.presenter.delegate = self;
    [ProgressUtil show];
    [self.presenter getBabyArchives];
    
    [self setupScrollView];
    [self setupHeadImageView];
    [self setupNameLabel];
    [self setupPriceLabel];
    [self setupTalkTimeLabel];
    [self setupPhoneTextField];
    [self setupPatientLabel];
    [self setupDistease];
    [self setupDesciption];
    [self seupPicCollectionView];
    [self setupCommitButton];
    [self setupSep];
    [self loadData];
    [self setupProcesses];
}

- (void)setupScrollView{
    _scrollView = [UIScrollView new];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _scrollView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).topSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    _scrollView.contentSize = CGSizeMake(kScreenWidth, 600);
}


#pragma mark 头像
- (void)setupHeadImageView{
    _headImageView = [UIImageView new];
    [_scrollView addSubview:_headImageView];
    _headImageView.sd_layout.leftSpaceToView(_scrollView,20).topSpaceToView(_scrollView,15).widthIs(75).heightIs(75);
}
#pragma mark 姓名
- (void)setupNameLabel{
    _nameLabel = [UILabel new];
    _nameLabel.font = AC_FONT;
    [_scrollView addSubview:_nameLabel];
    _nameLabel.sd_layout.leftSpaceToView(_headImageView,20).topSpaceToView(_scrollView,40).widthIs(120).heightIs(20);
}
#pragma mark 收费情况
- (void)setupPriceLabel{
    _priceLabel = [UILabel new];
    _priceLabel.textColor = [UIColor redColor];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.font = AC_FONT;
    [_scrollView addSubview:_priceLabel];
    _priceLabel.sd_layout.leftSpaceToView(_nameLabel,0).rightSpaceToView(_scrollView,20).topSpaceToView(_scrollView,40).heightIs(20);
}

#pragma mark 通话时间
- (void)setupTalkTimeLabel{
    _talkTimeLabel = [UILabel new];
    _talkTimeLabel.font = AC_FONT;
    [_scrollView addSubview:_talkTimeLabel];
    _talkTimeLabel.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,20).topSpaceToView(_headImageView,15).heightIs(50);
}

#pragma mark 接听号码
- (void)setupPhoneTextField{
//    _phoneLabel = [UILabel new];
//    _phoneLabel.font = AC_FONT;
//    [_scrollView addSubview:_phoneLabel];
//    _phoneLabel.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,20).topSpaceToView(_talkTimeLabel,0).heightIs(50);
    
    _phonetf=[LeftTitleTextField new];
    _phonetf.title=@"接听号码：";
    _phonetf.font=AC_FONT;
    _phonetf.titleFont = AC_FONT;
    _phonetf.text=kCurrentUser.phone;
    [_scrollView addSubview:_phonetf];
    _phonetf.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,20).topSpaceToView(_talkTimeLabel,0).heightIs(50);
}
#pragma mark 患者姓名
- (void)setupPatientLabel{
    _patientLabel = [UILabel new];
    _patientLabel.font = AC_FONT;
    [_scrollView addSubview:_patientLabel];
    _patientLabel.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,50).topSpaceToView(_phonetf,0).heightIs(50);
    UIImageView *buttonImage = [UIImageView new];
    buttonImage.image = [UIImage imageNamed:@"ac_down"];
    [_scrollView addSubview:buttonImage];
    buttonImage.sd_layout.leftSpaceToView(_patientLabel,12).rightSpaceToView(_scrollView,13).topSpaceToView(_phonetf,18).heightIs(14);
    
    _patientButton = [UIButton new];
    [_patientButton addTarget:self action:@selector(selectPatientAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_patientButton];
    _patientButton.sd_layout.leftSpaceToView(_patientLabel,0).topSpaceToView(_phonetf,0).rightSpaceToView(_scrollView,0).heightIs(50);
    
}
#pragma marl 疾病名称
- (void)setupDistease{
    _diseaseView = [UIView new];
    _diseaseView.backgroundColor = [UIColor colorWithWhite:.8 alpha:.2];
    [_scrollView addSubview:_diseaseView];
    _diseaseView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_patientLabel,0).heightIs(50);
    
    _diseaseLabel = [UILabel new];
    _diseaseLabel.font = AC_FONT;
    _diseaseLabel.text = @"疾病名称：";
    [_diseaseView addSubview:_diseaseLabel];
    _diseaseLabel.sd_layout.leftSpaceToView(_diseaseView,20).topSpaceToView(_diseaseView,0).widthIs(105).heightIs(50);
    
    _diseaseText = [UITextField new];
    _diseaseLabel.font = AC_FONT;
    _diseaseText.placeholder = @" 请输入疾病名称";
    [_diseaseText setValue:AC_FONT forKeyPath:@"_placeholderLabel.font"];
    [_diseaseView addSubview:_diseaseText];
    _diseaseText.sd_layout.leftSpaceToView(_diseaseLabel,10).rightSpaceToView(_diseaseView,20).topSpaceToView(_diseaseView,0).heightIs(50);
}
#pragma mark 病情信息
- (void)setupDesciption{
    _descriuption = [UIView new];
    _descriuption.backgroundColor = [UIColor colorWithWhite:.8 alpha:.2];
    [_scrollView addSubview:_descriuption];
    _descriuption.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_diseaseView,0).heightIs(80);
    
    _descriptionLabel = [UILabel new];
    _descriptionLabel.font = AC_FONT;
    _descriptionLabel.text = @"病情信息：";
    [_descriuption addSubview:_descriptionLabel];
    _descriptionLabel.sd_layout.leftSpaceToView(_descriuption,20).topSpaceToView(_descriuption,0).widthIs(105).heightIs(50);
    
    _descriptionText = [GCPlaceholderTextView new];
    _descriptionText.font = AC_FONT;
    _descriptionText.backgroundColor = [UIColor clearColor];
    _descriptionText.textColor = UIColorFromRGB(0x999999);
    _descriptionText.placeholder = @"请您详细描述您的病情，以便得到医生更好的回答";
    [_descriuption addSubview:_descriptionText];
    _descriptionText.sd_layout.leftSpaceToView(_descriptionLabel,10).rightSpaceToView(_descriuption,20).topSpaceToView(_descriuption,0).heightIs(80);
}

- (void)seupPicCollectionView{
    _picLabel = [UILabel new];
    _picLabel.font = AC_FONT;
    _picLabel.text = @"上传病例或者患者部位图片：";
    [_scrollView addSubview:_picLabel];
    _picLabel.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,20).topSpaceToView(_descriuption,0).heightIs(50);
    
    _picCollectionView = [[ImageWidget alloc] init];
    [_scrollView addSubview:_picCollectionView];
    _picCollectionView.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,20).topSpaceToView(_picLabel,0).minHeightIs(80).maxHeightIs(80);
}

#pragma  mark 添加私人医生
- (void)setupCommitButton{
    _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitButton.clipsToBounds = YES;
    [_commitButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [_commitButton setBackgroundImage:[self stretchableImageWithImageName:@"ac_commit"] forState:UIControlStateNormal];
    [_commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_commitButton];
    _commitButton.sd_layout.leftSpaceToView(_scrollView,20).rightSpaceToView(_scrollView,20).topSpaceToView(_picCollectionView,20).heightIs(40);
    _commitButton.layer.cornerRadius = _commitButton.height/2;
}


#pragma mark 分割线
- (void)setupSep{
    for (int i = 0; i < 7; i++) {
        UIView *sepView = [UIView new];
        sepView.backgroundColor = UIColorFromRGB(0xdbdbdb);
        [_scrollView addSubview:sepView];
        CGFloat orginY;
        if (i == 5) {
            orginY = 135;
        }else if (i == 6){
            orginY = 220;
        }else{
            orginY = 105;
        }
        sepView.sd_layout.leftSpaceToView(_scrollView,0).rightSpaceToView(_scrollView,0).topSpaceToView(_scrollView,orginY+50*i).heightIs(1);
    }
}

#pragma mark 加载数据
- (void)loadData{
    _headImageView.image = [UIImage imageNamed:@"correct"];
    _nameLabel.text = [NSString stringWithFormat:@"姓名：%@",self.doctor.UserName];
    NSString *price = [NSString stringWithFormat:@"%.f/%@",self.doctor.AudioPrice,self.doctor.AudioUnit];
    if (!self.doctor.AudioPrice || !self.doctor.AudioUnit) {
        price = @"";
    }
    _priceLabel.text = price;
    feeTime = self.doctor.AudioTime;
    _talkTimeLabel.text =[NSString stringWithFormat: @"通话时间：%@",feeTime];
//    _phonetf.text = @"接听号码：13XXXXXXXXX";
    _patientLabel.text = @"患者姓名：";
}

- (void)setupProcesses{
    
    UIButton *processesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [processesButton setTitle:@"流程" forState:UIControlStateNormal];
    [processesButton addTarget:self action:@selector(processesAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:processesButton];
    [self.navigationItem setRightBarButtonItem:backItem];
}


#pragma mark - 点击事件
//Action
- (void)commitAction{
    id responder = [self findFirstResponder];
    if (responder && ([responder isKindOfClass:[UITextField class]] || [responder isKindOfClass:[UITextView class]])) {
        [responder resignFirstResponder];
    }
    
    self.presenter.userID=kCurrentUser.userId;
    self.presenter.babyName=patientName;
    self.presenter.diseaseName=_diseaseText.text;
    self.presenter.descriptionDisease=_descriptionText.text;
    
//    self.presenter.descriptionDiseaseImage=nil;
    self.presenter.askDoctorID= 7;//医生id，假数据
    self.presenter.feeNormal=_priceLabel.text;
    self.presenter.feeUnit=@"次";
    self.presenter.feeSequence = 1;//假数据
    self.presenter.feeTime = feeTime;//假数据
    
    [ProgressUtil show];
    //判断是否需要上传图片
    if(_picCollectionView.urls.count!=0){
    //走上传图片的接口
        [self.presenter uploadDescriptionDiseaseImage:_picCollectionView.urls];
    }else{
    //走提交的接口
        self.presenter.descriptionDiseaseImage=nil;
        [self.presenter commitPhoneConsultation];
    }
}

- (void)processesAction{
    [self.navigationController pushViewController:[ACDiagnoseFlowViewController new] animated:YES];
}

- (void)selectPatientAction{
    __weak typeof(self) weakSelf=self;
    //科室数组
//    _patientArray = @[@"赵",@"钱",@"孙",@"李"];
    if(!self.patientMenu){
        NSArray* array = self.patientArray;
        self.patientMenu=[[JHCustomMenu alloc] initWithDataArr:array origin:CGPointMake(kScreenWidth/2, 255 - _scrollView.contentOffset.y) width:kScreenWidth/2 rowHeight:50 rowNumber:3];
        self.patientMenu.delegate=self;
        [self.view addSubview:self.patientMenu];
        
        self.patientMenu.dismiss=^(){
            weakSelf.patientMenu=nil;
        };
    }else{
        
        [self.patientMenu dismissWithCompletion:^(JHCustomMenu *object) {
            weakSelf.patientMenu=nil;
        }];
    }
}
#pragma mark - 代理
#pragma mark JHCustomMenuDelegate
-(void)jhCustomMenu:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    patientName = nil ;
    patientName = self.patientArray[indexPath.row];
    _patientLabel.text = [NSString stringWithFormat:@"患者姓名：%@",self.patientArray[indexPath.row]];
}

-(void)onCompletation:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil dismiss];
        
        for(BabayArchList* baby in self.presenter.dataSource){
            [self.patientArray addObject:baby.childName];
        }
    }else{
        [ProgressUtil showError:info];
    }
}

-(void)uploadImageCompletation:(BOOL)success{
//    [ProgressUtil dismiss];
//    [self.presenter commitPhoneConsultation];
    self.presenter.descriptionDiseaseImage=self.presenter.uploadPath;
    [self.presenter commitPhoneConsultation];

}

-(void)commitCompletation:(BOOL)success info:(NSString *)info{
    if(success){
        [ProgressUtil showInfo:@"提交成功"];
#warning 临时隐藏
//        [self.navigationController pushViewController:[OrderSubmitViewController new] animated:YES];

    }else{
        [ProgressUtil showError:info];
    }
}



#pragma mark -
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

//获取响应者
- (id)findFirstResponder{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subview in self.view.subviews) {
        if ([subview isFirstResponder]&&subview!=nil) {
            return subview;
        }
    }
    return nil;

}






@end
