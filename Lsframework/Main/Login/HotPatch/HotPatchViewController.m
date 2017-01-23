//
//  HotPatchViewController.m
//  FamilyPlatForm
//
//  Created by 中弘科技 on 16/9/1.
//  Copyright © 2016年 梁继明. All rights reserved.
//  更新进度页面，主要完成补丁包下载，解压后回调到splash页面进入正常流程

#import "HotPatchViewController.h"
#import "HotPatchPresenter.h"
#import "SplashViewController.h"
//引入lua相关头文件
//#import "lauxlib.h"
//#import "wax.h"
//解压缩头文件
#import "ZipArchive.h"

@interface HotPatchViewController ()

@property (nonatomic, strong) HotPatchPresenter *presenter;

@end

@implementation HotPatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    _presenter = [HotPatchPresenter new];
    [self.navigationController pushViewController:[SplashViewController new] animated:NO];
//    [self loadLuaZip];
}

//下载lua.zip
- (void)loadLuaZip{
    WS(ws);
    [_presenter loadLua:^(BOOL success, NSString *path) {
        if (success == YES) {
            //有补丁，但是已经更新过了
            if ([path isEqualToString:@"NOPATCH"]) {
                NSString *pathStr = [kDefaultsUser objectForKey:@"zip"];
                NSString *patchStr = [NSString getPatchZipPath];
                [ws wax_Patch:[NSString stringWithFormat:@"%@/%@",patchStr,pathStr]];
            }else if ([path isEqualToString:@"NULLPATCH"]){
                //无补丁包需要更新
                [self.navigationController pushViewController:[SplashViewController new] animated:NO];
            }else{
                //有补丁包.且下载成功
                [ws wax_Patch:[path substringFromIndex:7]];
                NSArray *array = [path componentsSeparatedByString:@"/"];
                [kDefaultsUser setObject:array.lastObject forKey:@"zip"];
            }
        }else{
            //无补丁包.或下载失败
//            [ProgressUtil showError:@"下载补丁包失败，请检查网络"];
            
        }
    }];
    
}

//加载编译运行lua文件
- (void)wax_Patch:(NSString *)path{
    
//    if(path){
//        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *dir = [doc stringByAppendingPathComponent:@"lua"];
//        [[NSFileManager defaultManager] removeItemAtPath:dir error:NULL];
//        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:NULL];
//        
//        ZipArchive *zip = [[ZipArchive alloc] init];
//        [zip UnzipOpenFile:path];
//        [zip UnzipFileTo:dir overWrite:YES];
//        
//        [self lsFile:dir delete:path];
//        
//        NSString *pp = [[NSString alloc ] initWithFormat:@"%@/patch/?.lua;%@/?/init.lua;", dir, dir];
//        
//        setenv(LUA_PATH, [pp UTF8String], 1);
//        wax_start("patch", nil);
//        [kDefaultsUser setObject:_presenter.version forKey:PATCH_VERSION];
//        [self.navigationController pushViewController:[SplashViewController new] animated:NO];
//    }else{
//        NSLog(@"patchZipPath路径为空！");
//    }
}

//查看某个路径下的文件（可以用来查看解压的patch.zip路径等等是否正确）
- (void)lsFile:(NSString *)path delete:(NSString *)zipPath{
    
    NSFileManager *myFileManager=[NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator;
    myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];
    if(![myDirectoryEnumerator nextObject]){
        NSLog(@"path中没有其他目录或文件！");
        return;
    }
    //列举目录内容
    while((path=[myDirectoryEnumerator nextObject])!=nil)
    {
        NSLog(@"path:%@",path);
    }
}

@end
