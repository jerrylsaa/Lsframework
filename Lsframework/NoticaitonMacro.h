//
//  NoticaitonMacro.h
//  FamilyPlatForm
//
//  Created by lichen on 16/4/28.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#ifndef NoticaitonMacro_h
#define NoticaitonMacro_h


#define kdefaultCenter [NSNotificationCenter defaultCenter]

#define Notification_ChangeBaby @"ChangeBaby" //切换宝贝通知
#define Notification_DeleteLinkBaby @"deleteLinkBaby" //删除宝贝
#define Notification_UpdateBabyList @"updateBabyList"//更新宝贝列表
#define Notification_synchronizeIcon @"synchronizeBabyIcon"//同步宝宝头像
#define Notification_DeleteCurrentBaby @"deleteCurrentBaby"//删除当前宝宝
#define Notification_UpdateBabyDetailInfo @"updateBabyDetailInfo"//更新宝宝详情
#define Notification_UpdateDefaultBabyInfo @"updateDefaultBabyInfo"//更新默认宝宝信息

#define Notification_SelectPackage @"selectPackage"//选择套餐
#define Notification_Add_Baby_Complete @"addBabyComplete" //添加宝贝

#define Notification_ShowBabyArchiver @"showBabyArchiver"//展示baby档案
#define Notification_ChangeEditState @"changeEditState"//切换编辑状态

#define Notification_UpdateFamilyDoctor @"updateFamilyDoctor"//更新家庭医生列表

#define Notification_updateChildAdvater @"updateChildAdvater"//更新首页宝宝头像

#define Notification_ShowCommitInfo @"showCommitInfo"//展示提交信息


#define Notification_LoginOutAction @"loginOut"//退出

#define Notification_WeXinLogin @"WeXinLogin"//微信登录
#define Notification_ConsultationWeXinPayResult @"ConsultationWeXinPayResult"//咨询页面问题微信支付

#define Notification_HotWeXinPayResult @"HotWeXinPayResult"//咨询专家热点问题页面微信支付
#define Notification_HotWeXinPayResultDetail @"HotWeXinPayResultDetail"//咨询专家热点问题详情页面微信支付

#define Notification_HotViewWeXinPayResult @"HotViewWeXinPayResult"//首页热点问题页面微信支付


#define Notification_HotIsLoad @"isLoad" //首页热门咨询是否已加载
#define Notification_Push @"PushVC"
#define Notification_RefreshCircleList @"refreshCircleList"//刷新圈子列表
#define Notification_RefreshConsulationList @"refreshConsulationList"//刷新热门咨询评论列表
#define Notification_RefreshHotQuestion @"refreshHotQuestion"
#define Notification_Update_AllBaby @"updateAllBaby"
#define Notification_ConvertBaby @"convertBabay"//切换宝宝

#define Notification_RefreshDailyArticleMore @"refreshDailyArticleMore"//刷新每日必读查看往期列表
#define Notification_RefreshCircleSingle @"CircleSingleRefreshNotification"//刷新圈子单条数据
#define Notification_Change_Baby @"chageBaby"//切换宝宝
#define Notification_Refresh_DailyArticlePraiseCount @"DailyArticlePraiseCount"//刷新首页点赞数量
#define Notification_RefreshHomePraiseHot @"HomePraiseHotRefreshNotification"//刷新首页点赞数据

#define Notification_PushGeTui @"PushNotification"//刷新首页点赞数据
#define Notification_HotSearch @"HotSearchViewRefreshNotication"//刷新热门搜索页面数据
#define Notification_HEAInfoViewController @"HEAInfoViewControllerRefreshNotication"//刷新医生详情数据

#define Notification_ceshi @"Notification_ceshiRefreshNotication"//刷新医生详情数据

#define Notification_RefreshPushChartList @"Notification_RefreshPushChartListNotication"//刷新推送聊天列表页


#define Notification_RefreshDoctorQuestionDetail @"Notification_RefreshDoctorQuestionDetailInfo"//追问支付完成刷新问题详情页数据

#define Notification_RefreshHealthServiceCount @"Notification_GBHomeViewControllerHealthServiceCount"//测评结束后更新首页测评数量

#endif /* NoticaitonMacro_h */
