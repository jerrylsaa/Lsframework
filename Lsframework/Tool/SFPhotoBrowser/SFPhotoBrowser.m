//
//  SFPhotoBrowser.m
//
//
//  Created by laoshifu on 15/9/15.
//  Copyright (c) 2015年 laoshifu All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SFPhotoBrowser.h"
#define kIndexLabelWidth 80
#define kIndexLabelHeight 30

@interface SFPhotoBrowser ()
{
    UICollectionView *_collectionView;
}
@property (nonatomic,strong)NSMutableDictionary *photoDic;
@property (nonatomic,strong)UILabel *indexLable;//被点击的图片索引

@end

@implementation SFPhotoBrowser
static NSString *identifier = @"PhotoCell";

- (NSMutableDictionary *)photoDic{

    if (_photoDic == nil) {
        _photoDic = [NSMutableDictionary dictionary];
    }
    return _photoDic;
}

- (UILabel *)indexLable{
    
    if (_indexLable == nil) {
        _indexLable = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - kIndexLabelWidth) / 2, 20, kIndexLabelWidth, kIndexLabelHeight)];
        _indexLable.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
        _indexLable.font = [UIFont systemFontOfSize:15];
        _indexLable.textAlignment = NSTextAlignmentCenter;
        _indexLable.layer.cornerRadius = kIndexLabelHeight / 2;
        _indexLable.layer.masksToBounds = YES;
        _indexLable.textColor = [UIColor whiteColor];
        [self addSubview:_indexLable];
    }
    return _indexLable;
}

+ (void)showImageInView:(UIView *)view selectImageIndex:(NSInteger)index delegate:(id<PhotoBrowerDelegate>)delegate
{
    SFPhotoBrowser *photoBrower = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    photoBrower.currentPhotoIndex = index;
    photoBrower.delegate = delegate;
    [view addSubview:photoBrower];
    [photoBrower createCollectionView];
}

#pragma mark 创建UICollectionView
- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(kScreenWidth + kPhotoImageEdgeSize, kScreenHeight);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)+kPhotoImageEdgeSize, CGRectGetHeight(self.frame)) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.pagingEnabled = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[SFPhotoCell class] forCellWithReuseIdentifier:identifier];
    [self addSubview:_collectionView];
    
    //滚动到点击的图片
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPhotoIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)updateIndexView:(NSInteger)index{
    
    self.indexLable.text = [NSString stringWithFormat:@"%ld / %ld",index + 1,[self.delegate numberOfPhotosInPhotoBrowser:self]];

}
#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //更新索引视图
    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    [self updateIndexView:index];
}

#pragma mark -UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.delegate numberOfPhotosInPhotoBrowser:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SFPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.photoView.photoViewDelegate = self;
    
    //缓存photo
    SFPhoto *photo = [self.photoDic objectForKey:indexPath];
    
    if (photo == nil) {
        photo = [self.delegate photoBrowser:self photoAtIndex:indexPath.row];
        [self.photoDic setObject:photo forKey:indexPath];
        if (indexPath.row == _currentPhotoIndex) {
            photo.isSelectImg = YES;
        }
    }
    cell.photo = photo;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    SFPhotoCell *photoCell = (SFPhotoCell *)cell;
    photoCell.photoView.zoomScale = 1.0f;
}

#pragma mark -WXPhotoViewDelegate
- (void)photoViewDidZoomIn:(SFPhotoScrollView *)photoView{
    self.backgroundColor = kBackgroundColor;
    //隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    if ([self.delegate numberOfPhotosInPhotoBrowser:self] > 1) {
        //显示索引视图
        [self updateIndexView:_currentPhotoIndex];
    }
}
- (void)photoViewWillZoomOut:(SFPhotoScrollView *)photoView{
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.backgroundColor = [UIColor clearColor];
    //移除索引视图
    [self.indexLable removeFromSuperview];
}
- (void)photoViewDidZoomOut:(SFPhotoScrollView *)photoView{
    //移除当前视图
    [self removeFromSuperview];
}

@end