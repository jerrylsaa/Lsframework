//
//  UIImageView+JMExtensions.m
//  FansGroup0307
//
//  Created by 梁继明 on 16/3/8.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#import "UIImageView+JMExtensions.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation UIImageView (JMExtensions)



-(void)setImageWithURLStr:(NSString *)urlName{
    
    NSURL *urlImage = [NSURL URLWithString:urlName] ;
    
    UIImage *image =  [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:urlName];
    
    if ( image) {
        
        self.image =  image;
        
    }else{
 

        [self sd_setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"downlaod_picture_fail"] options:SDWebImageDownloaderContinueInBackground|SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
           
        }];
        
        
    }
    
    
    self.contentMode = UIViewContentModeScaleAspectFill;
    
    
}

-(void)setImageConerWithURLStr:(NSString *)urlName{
    
    if (!urlName || urlName.length < 1) {
        
        return;
    }
    
    [self setImageWithURLStr:urlName];
    
    /*
     
     [self sd_setImageWithURL:placeholderImage:[UIImage imageNamed:@"icon_default_surface"]];
     
     
     NSLog(@"%f",self.frame.size.width);*/
    
    // self.layer.cornerRadius = 33.0f;
    
    
//    [self makeCorner:self.frame.size.width * 0.5f];
    
    /*
     self.layer.cornerRadius = self.frame.size.width*0.5f;
     NSLog(@"----width%f",self.frame.size.width);
     
     self.layer.masksToBounds = YES;*/
    
    
}



@end
