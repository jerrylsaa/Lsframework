//
//  FamilyDefine.h
//  FamilyPlatForm
//
//  Created by 梁继明 on 16/3/24.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#ifndef FamilyDefine_h
#define FamilyDefine_h

#define kScreenSize   [[UIScreen mainScreen] bounds].size
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height

#define kFitWidthScale(width) (width)/2.0*kScreenWidth/375
#define kFitHeightScale(height) (height)/2.0*kScreenHeight/667

#define kCurrentUser [GVUserDefaults standardUserDefaults]
#define kDefaultsUser [NSUserDefaults standardUserDefaults]
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self

#define  kJMWidth(widthLB)   [JMFoundation calLabelWidth:(widthLB)]
#define  kJMHeight(heightLB)   [JMFoundation calLabelHeght:(heightLB)]

//打点ACTION
#define  DotEventEnter  @"进入"
#define  DotEventReceive  @"收到"
//打点位置 point

#define  DotHomeSearch         @"首页上的搜索"   //首页--搜索
#define  DotExpertConsulation   @"咨询专家"   //首页-->咨询专家按钮
#define  DotHotQuestion         @"问题详情"     //咨询专家-->咨询-->每一行
#define  DotHotQuestionSend     @"问题详情－评论"    //问题详情页面->发送按钮
#define  DotHotQuestionShare    @"问题详情－分享"   ////问题详情页面->分享
#define  DotHotQuestionAnswer    @"问题详情－追问"   ////问题详情页面->追问


#define  DotExpertSegment       @"专家"     //咨询专家segment
#define  DotHEAninfoView        @"专家解答"    //专家解答-->专家-->每一行
#define  DotHEAninfoViewWrite    @"专家解答页面写好了"   //专家解答-->写好了
#define  DotHEAninfoViewCanclePay @"点击写好了出现的取消"//专家解答-->取消
#define  DotHEAninfoViewPay    @"点击写好了出现的支付"   //专家解答-->支付
#define  DotHEAninfoViewAppraise @"专家解答－医生收到的点评"//专家解答->医生评价
#define  DotExpertConsulationSearch    @"专家、咨询右侧的搜索"   //咨询专家-->搜索
//#define  DotHEAninfoViewShare     @"分享"   //专家解答-->分享

//膳食管理
#define  DotDietManager    @"膳食管理"   //首页--膳食管理按钮
#define  DotDietManagerFood  @"食材查询"   //膳食管理-->食材查询按钮
#define  DotDietManagerFoodCamera     @"膳食管理－拍照"   //专家解答-->分享
#define  DotDietManagerFoodSearch  @"膳食管理－搜索"   //膳食管理-->食材搜索

//健康服务
#define  DotHealthTeach  @"健康服务"   //首页--健康服务按钮
#define  DotHealthTeachSelect  @"选择服务"   //首页--健康服务-->选择服务--->行
#define  DotHealthTeachPay  @"购买服务"   //首页--健康服务-->购买服务
#define  DotHealthTeachCommit  @"确认提交"   //首页--健康服务-->确认提交


#define  DotHeightAndWeight  @"身高体重"   //首页--身高体重
//更多
#define  DotHomerMore  @"更多"   //首页-更多
#define  DotMoreFountionPatientCase  @"病友案例"   //More-->病友案例
#define  DotMoreFountionVaccinePlane  @"疫苗接种"   //More-->疫苗接种
#define  DotMoreFountionOutPatientAppoint  @"门诊预约"   //More-->门诊预约
#define  DotMoreFountionHRHealthAssess  @"查看报告"   //More-->查勘报告

#define  DotMoreFountionGood  @"成长快乐区域"   //More-->成长快乐

#define  DotHomeDailyRemind  @"首页上的每日提醒"   //首页-->每日提醒

#define  DotHealthService  @"健康测评区域"   //首页-->健康测评

//头条
#define  Dottoptab         @"首屏点击头条tab"   //首页--头条
#define  DotRecommendRow  @"每日精选文章"  //头条-->今日推荐--每行
#define  DotConcentration  @"精选"  //头条-->精选segment
#define  DotConcentrationRow  @"精选文章"  //头条-->精选--每行
#define  DotRanking        @"排行"  //头条-->排行segment
#define  DotRankingRow    @"排行文章"  //头条-->排行--每行

//打点备注  remark



#define WO(o) __weak typeof(o) o##Weak = o;

NS_INLINE void runOnMainThread(void (^block)(void))
{
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

NS_INLINE void runOnBackground(void (^block)(void))
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        block();
    });
}

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
//大于等于7.0的ios版本
#define iOS7_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

//大于等于8.0的ios版本
#define iOS8_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")


#define XG_ACCESS_ID 2200199480
#define XG_ACCESS_KEY @"IR8Y88YS3S3X"
#define XG_SECRET_KEY @"21795ae1aaf86d7a1fbbcab4fdffb685"

#define PATCH_VERSION @"patchVersion"//补丁版本号
#define PATCH_PATH @"patchPath"//补丁压缩包路径


#ifdef DEBUG
//开发环境
#define NSLog(...) NSLog(__VA_ARGS__);
#define WSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#else
//发布环境
//#define NSLog(...)
#define WSLog(fmt, ...)


#endif


#endif /* FamilyDefine_h */
