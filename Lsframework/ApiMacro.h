//
//  ApiMacro.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#ifndef ApiMacro_h
#define ApiMacro_h


#ifdef DEBUG
//测试服务器

//开发环境
#define RONG_CLOUD_APP_KEY @"m7ua80gbu9uym"

#define RONG_CLOUD_APP_SECRET @"NTJoe28GjgGql"

#define PUBLIC_SERVICE_KEY @"KEFU145978163640400"


#else
//正式地址
//Address

//正式环境
#define RONG_CLOUD_APP_KEY @"k51hidwq1y10b"
#define RONG_CLOUD_APP_SECRET @"65P0R9gcjBuUwx"

#define PUBLIC_SERVICE_KEY @"KEFU146635012238678"

#endif
//融云
#define URL_RONG_HOST @"https://api.cn.rong.io/"
//分享
#define URL_SHARE @"http://etjk365.dzjk.com:8084/MobileHtml/gzh/FenXiangIndex.html"
//问题详情分享Url
#define URL_SHARE_CONSULATION @"http://www.zhongkang365.com/MobileHtml/gzh/fenda/wentixiangqing.html?Consultation="

//咨询专家分享Url
#define URL_SHARE_EXPERTANSWER @"http://www.zhongkang365.com/MobileHtml/gzh/fenda/zhuanjiajieda.html?DoctorID="

//健康测评分享Url
#define URL_SHARE_HEALTHSERVICE @"http://www.zhongkang365.com/MobileHtml/Appfenxiang/jiankangceping.html?EvalName="



#define WXPay_URL @"http://www.zhongkang365.com/MobileHtml/gzh/fenda/getappwxapi.aspx"

#define QuanZi_URL @"http://www.zhongkang365.com/MobileHtml/gzh/fenda/quanzifenxiang.html?ConsultationID"

//AppUrl
//#define BASE_URL @"http://etjk360.dzjk.com/Mobile/Mobile.do"
//#define BASE_DOMAIN @"http://etjk360.dzjk.com"
//#define UPLOAD_URL @"http://etjk360.dzjk.com/Mobile/uploadMac.do"
//#define ICON_URL @"http://etjk360.dzjk.com"//头像根路径

#ifdef DEBUG
//开发环境
//测试服务器地址

#define BASE_URL @"http://120.55.64.44:9020/Mobile/Mobile.do"
#define BASE_DOMAIN @"http://120.55.64.44:9020"
#define UPLOAD_URL @"http://120.55.64.44:9020/Mobile/uploadMac.do"
#define UPLOAD_URLV1 @"http://120.55.64.44:9020/Mobile/uploadV1.do"
#define UPLOAD_URL44 @"http://120.55.64.44:9020/upload44"

#define ICON_URL @"http://120.55.64.44:9020"//头像根路径



#else
//发布环境
//正式服务器地址
#define BASE_URL @"http://etjk365.dzjk.com:8084/Mobile/Mobile.do"
#define BASE_DOMAIN @"http://etjk365.dzjk.com:8084"
#define UPLOAD_URL @"http://etjk365.dzjk.com:8084/Mobile/uploadMac.do"
#define UPLOAD_URLV1 @"http://etjk365.dzjk.com:8084/Mobile/uploadV1.do"
#define UPLOAD_URL44 @"http://zhongkang365.com/upload44"

#define ICON_URL @"http://etjk365.dzjk.com:8084"//头像根路径

#endif



//API定义
#define API_PHONE_INDENTIFYING_CODE @"PhoneIdentifyingCode"//获取验证码
#define API_PHONE_REGIST @"PhoneRegist"//注册
#define API_LOGIN @"PhoneLogin"//登录
#define API_FORGETPASSWORD @"ForGetPassword"//忘记密码
#define API_PHONE_QUERY_BABY_ARCHIVES_INFO @"PhoneQueryBabyArchivesInfo"//获取默认孩子详细信息
#define API_QUERY_INDEX_PAGE_REMIND @"QueryIndexPageRemind"//获取孩子标准身高体重数据
#define API_PHONE_QUERY_BABY_ARCHIVESLIST @"PhoneQueryBabyArchivesList"//获取所有绑定孩子
#define API_PHONE_QUERY_NATION @"PhoneQueryNation"//民族
#define API_PHONE_QUERY_NATIONALITY @"PhoneQueryNationality"//国籍
#define API_PHONE_QUERY_PROVINCE @"PhoneQueryProvince"//省
#define API_PHONE_QUERY_City @"PhoneQueryCity"//市
#define API_PHONE_QUERY_HOSPITAL @"PhoneQueryHospital"//医院
#define API_PHONE_QUERY_DEPART @"PhoneQueryDepart"//科室
#define API_PHONE_QUERY_DATA_DICTIONARY @"Query_Data_Dictionary"//菜单

//档案录入
#define API_PHONE_ADD_BABY_EMR @"PhoneAddBabyEmr"//	添加儿童档案接口
#define API_PHONE_ADD_BABY_EMRv1 @"PhoneAddBabyEmrV1"//	添加儿童档案接口V1

#define API_PHONE_ADD_BIRTHCONDITION @"PhoneAddBirthCondition"//新生儿围产期
#define API_PHONE_ADD_PREGNANCY @"PhoneAddPregnancy"//母亲孕期情况
#define API_PHONE_ADD_HISTORY @"PhoneAddFamilyHistory"//家庭史
#define API_PHONE_ADD_DEVELOPMENT @"PhoneAddDevelopment"//发育情况
#define API_PHONE_EDIT_BABY_EMR @"PhoneEditBabyEmr" //编辑儿童档案
#define API_PHONE_GET_BABY_EMR_INFO @"PhoneGetBabyEmrInfo"//获取儿童档案
#define API_PHONE_EDIT_ALL_BABY_EMR @"PhoneEditAllBabyEmr" //编辑儿童所有档案


#define API_PHONE_ADD_CONSULTATION @"PhoneAddConsultation"//添加咨询
#define API_PHONE_QueryDoctor @"PhoneQueryDoctorOnlineList"//快速咨询模块医生列表
#define API_PHONE_QueryDOC_AC @"PhoneQueryDoctor"//精准咨询模块医生列表
#define API_QUERY_PACKAGEDOCTOR @"QueryHavePackageDoctor"//查询有套餐的医生列表
#define API_QUERY_USER_COLLECTION @"QueryUserCollection"//收藏医生的列表

#define API_PHONE_QUERY_DOCTOR_INFO @"PhoneQueryDoctorInfo"//获取医生详情
#define API_PHONE_QUERY_BABY_ARCHIVES_LIST @"PhoneQueryBabyArchivesList"//获取所有绑定的孩子
#define API_PHONE_QUERY_BABY_INFO @"QueryBabyInfo"//获取选择孩子的信息
#define API_PHONE_DELETE_BABYLINK @"RemoveBabyLink"//删除关联宝贝
#define API_PHONE_ADD_TEL_CONSULTATION @"PhoneAddTelConsultation"
#define API_QUERY_DAY_ATTENDANCE @"QueryDayAttendance"//获取家长当日是否签到
#define API_ADD_USER_SIGN @"AddUserSign"//家长签到
#define API_QUERY_FAMILY_DOCTOR @"QueryFamilyDoctor"//签约医生列表
#define API_QUERY_DOCTOR_PACKAGE_LIST @"QueryDoctorPackageList"//获取医生套餐详情
#define API_QUERY_MY_SERVICE_PACKAGE @"QueryMyService"//获取我的医疗服务套餐QueryMyFamilyDoctor
#define API_QUERY_MY_FAMILY_DOCTOR @"QueryMyFamilyDoctor" //获取我的申请家庭医生
#define API_QUERY_MY_ONLINE @"QueryAskOnline"//获取我的在线申请
#define API_QUERY_MY_PHONE @"QueryAskTel"//获取我的电话申请
#define API_QUERY_MY_EVALUTE_LIST @"QueryAskListByEvaluate"// 获取我的医生评价

#define API_INSERTBINDDEVICE @"InsertBindDevice"//上报个推DeviceToken
#define API_QUERY_SCREENNING_RECORD @"QueryScreenningRecord"//获取指定时间的随访记录
#define API_ADD_SCREENNING_RECORD @"AddScreenningRecord"//添加随访记录
#define API_GET_SCREENNING_RECORD @"GetScreenningRecord"//获取已有随访记录的日期

#define API_QUERY_HOSPITAL_ARCHIVES @"QueryPacsList"// 医院检查档案列表

#define API_QUERY_HOSPITAL_ARCHIVES_DETAIL @"QueryPacsInfo"// 医院检查档案列表详情

#define ADD_ARCHIVES @"AddPACS"// 上传检查档案

#define API_CONTINUE_UPLOAD_INSPECTION_IMAGE @"AddLisImgContinuingly"// 续传检查档案图片

#define API_QUERY_HOSPITAL_MER_LIST @"QueryEmrList"// 医院病历档案列表

#define ADD_EMR_ARCHIVES @"AddEMR"// 上传病历档案

#define API_CONTINUE_UPLOAD_EMR_IMAGE @"AddEmrImgContinuingly"// 续传病历档案图片

#define API_QURE_EMR_ARCHIVES_DETAIL @"QueryEmrInfo"// 电子病历详情

#define API_ADD_HELP @"AddHelp"// 帮助与反馈上传

#define API_QUERY_CHECK_PROJECT_LIST @"QueryInspectionItems"// 获取检查项目项目名列表

#define API_QUERY_HEALTHCASE @"QueryHealthyMain"//健康方案


#define API_QUERY_BESPEAK @"QueryBespeak"//获取预约
#define API_QUERY_CHILDREN_BESPEAK @"QueryChildren_Bespeak"//获取时间预约列表
#define API_ADD_UNAPPOINT_REASON @"AddNoSeeingTheDoctorReason"//取消预约原因
#define API_QUERY_FAMILY_DOCTOR @"QueryFamilyDoctor"//获取签约医生

#define API_ADD_FAMILY_DOCTOR @"AddFamilyDoctor"//添加家庭医生
#define API_ADD_COLLECTION @"AddCollection"//添加收藏医生
#define API_REMOVE_COLLECTION @"RemoveCollection"//删除收藏医生

#define API_QUERY_SEEING_DOCTORRECORD @"QuerySeeingADoctorRecord"//已面诊记录

#define API_SET_DEFAULTBABY @"SetDefaultBaby"//设置默认孩子
#define API_ADD_BABYHEADER @"AddBabyHeadPortrait"//修改孩子头像

#define API_QUERY_DOCTOR_SCREENING @"QueryDoctorScreening"//指定孩子的筛查列表

#define API_QUERY_MY_BESPEAK @"QueryMyBespeak"//查询我的预约

#define API_GET_COMMON_USER_INFO @"GetCommonUserInfo"

#define API_QUERY_DOCTOR_APPOINTMENT @"QueryDoctor_Appointment"//预约时间段
#define API_INSERT_BOOKING_ORDER @"InsertBookingOrder"//添加预约门诊
#define API_QUERY_BOOKING_ORDER @"QueryBookingOrder"//我的预约
#define API_GET_CHILD_RECORD @"GetChildRecordsByBabyID"//健康测评列表
#define API_GET_APPVERSION @"GetAppVersion" //获取版本号
#define API_HAVEMYWALLETPASS @"HaveMyWalletPassByUserID"//判断是否设置过钱包密码
#define API_SETPASSBYMYWALLET @"SetPassByMyWallet"//设置钱包密码
#define API_GETMYWALLETMONEY @"GetMyWalletMoney"//获取钱包余额
#define API_GETMYCONSUMPTION @"GetMyConsumption"//获取我的账单
#define API_INSERTWITHDRAWALS @"InsertWithdrawals"//钱包提现
#define API_INSERTALIPAYWITHDRAWALS @"InsertAlipayWithdrawals"//支付宝提现
#define API_GET_EXPERTDOCTOR_INFO @"GetExpertDoctorInfo"
#define API_GET_EXPERTDOCTOR_INFOV2 @"GetExpertDoctorInfoV2"
#define API_GET_EXPERTDOCTOR_INFOV3 @"GetExpertDoctorInfoV3"
#define API_GET_EXPERTDOCTOR_INFOV4 @"GetExpertDoctorInfoV4"

#define API_GET_EXPERTCONSULTATIONLIST @"GetExpertConsultationListV2"
#define API_GET_EXPERTCONSULTATIONLISTV1 @"GetExpertConsultationListV2"
#define API_GET_EXPERID_BY_USERID @"GetExperIDByUserID"//查询当前用户是否是医生
#define API_InsertShare @"InsertShare"//获取优惠券码
#define API_GET_MY_EXPERT_CONSULTATION_LIST @"getmyexpertconsultationlist"//我问
#define API_GET_MY_EXPERT_CONSULTATION_LISTV1 @"GetMyExpertConsultationListV2"//我问v1

#define API_QUERY_LISTEN_QUESTION @"QueryListenQuestion"//我听
#define API_QUERY_LISTEN_QUESTIONV1 @"QueryListenQuestionV2"//我听V1
//#define API_GET_ExpertConsultationByDoctorID @"GETExpertConsultationByDoctorID"//我答

#define API_GET_ExpertConsultationByDoctorID @"GetExpertConsultationByDoctorIDV2"//我答

 #define API_Update_ExpertConsultation @"UpdateExpertConsultation"//我答更新列表

#define API_ADD_EXPERT_CONSULTATION @"AddExpertConsultation"//添加专家分答咨询

#define API_ADD_EXPERT_CONSULTATIONV2 @"AddExpertConsultationV4"//添加专家分答咨询V2接口

#define API_GET_BANNER_LIST @"getbannerlistbytype"

#define API_INSERT_CONSULTING_RECORDS @"InsertConsultingRecordsV1"//新增咨询记录
#define API_INSERT_LISTEN_QUESTION_RECORDS @"InsertListenQuestionRecords"//新增偷听记录

//HTML
#define API_HTML_BABY_GROWTH_CURVE @"/wap/BabyGrowthCurve.html?"//健康档案曲线图
#define API_HTML_MRWY @"/wap/MRWY.aspx?userid="//母乳喂养折线图
#define API_HTML_PFNWY @"/wap/peifangnai.aspx?userid="//配方奶喂养
#define API_HTML_SM @"/wap/shuimian.aspx?userid="//睡眠
#define API_HTML_DB @"/wap/dabian.aspx?userid="//大便
#define API_HTML_YYBC @"/wap/yingyangbuchong.aspx?userid="//营养补充/(D/AD)
#define API_HTML_GJ @"/wap/GJ.aspx?userid="//钙剂
#define API_HTML_TJ @"/wap/TJ.aspx?userid="//铁剂
#define API_HTML_SERVICE @"/wap/Serviceindex.html?"//健康服务
#define API_HTML_JKJY @"/wap/HealthEdu/jiankangjiaoyu.html"//健康教育

#define API_INSERT_PAYORDER @"InsertBasePayOrder"//获取订单号
#define API_PAY_SUCCESS_BY_PAY_ORDER @"PaySuccessByPayOrder"//支付成功
#define API_INSERT_LISTEN_QUESTION @"InsertListenQuestion"//插入偷听表

#define API_PAYSUCCESS @"PaySuccessByPayOrder"//付款成功
#define API_INSERTLISTENQUESTION @"InsertListenQuestion"//插入偷听
#define API_INSERTWALLETRECHARGE @"InsertWalletRecharge"//充值记录接口

#define API_Get_EVAL_TABLES @"GetEvalTables"//健康测评量表接口
#define API_Get_EVAL_QUESTS @"GetEvalQuests"//健康测评量表问题接口
#define API_Get_EVAL_SAVE @"EvalSaveV1"  ///健康测评问题提交接口

#define API_UPDATEPASSBYMYWALLET @"UpdatePassByMyWallet" //修改钱包密码
#define API_FORGETMYWALLETPASSWORD @"ForGetMyWalletPassword"//忘记钱包密码
#define API_GET_CHILD_SCREENING @"GetChildScreeningRecordByUserID"//获取筛查报告接口

#define API_GET_CONFIGURES @"Get_Configures"//获取动态配置
#define API_GET_MESSAGEALERTLIST @"GetMessageAlertList"//获取我的提醒
#define API_GET_VACCINE @"GetVaccine"//获取首页疫苗提醒

#define API_GET_COUPONLIST @"GetCouponList"//获取优惠券接口

#define API_QUERY_QUESTION_RECOMMEND @"GetAllExpertConsultationList"//获取首页热点问题
#define API_QUERY_QUESTION_RECOMMENDV2 @"GetAllExpertConsultationListV2"//获取首页热点问题
#define API_GET_ALLEXPERTCONSULTATIONLISTV4 @"GetAllExpertConsultationListV4"//获取首页热点问题V4


#define API_GET_NEW_EXPERT_DOCTOR_INFO @"GetNewExpertDoctorInfo"//获取单条咨询医生信息

#define API_GetEHRChildRecordCount @"GetEHRChildRecordCount"//获取首页测评总数
#define API_GET_CLAIMCOUPON @"ClaimCoupon"//领取优惠券接口
#define API_GET_MYCOUPONLIST @"GetMyCouponList"//获取优惠券状态
#define API_SET_EXPERTDOCTORCOUPONCOUNT @"SetExpertDoctorCouponCount"//设置优惠券数量
#define API_SET_EXPERTDOCTORISVACATION @"SetExpertDoctorIsVacation"//设置是否休假
#define API_SET_EXPERTDOCTORPRICE @"SetExpertDoctorPrice"//设置咨询价格
#define API_GET_EXPERTDOCTORISVACATIONANDCOUNT  @"GetExpertDoctorIsVacationAndCount"//获取优惠券数量，价格，休假

#define API_GET_EXPERTCANCONSUMECOUNT @"GetExpertCanConsumeCount"//获取当天可用优惠券次数

#define API_GET_CONSULATIONCONSUMPTIONCOUPON @"ConsultationConsumptionCoupon"//获取使用优惠券后的价格


#define API_GET_CONSUMPTIONCOUPON @"ConsumptionCoupon"//消耗优惠券
#define API_GET_GETDAILYREMINDER @"GetDailyReminder"//获取每日提醒


#define API_INSERTUSERPHOTO @"InsertUserPhoto" //上传发现照片

#define API_GET_USERPHOTOSBYUSERID @"GetUserPhotosByUserID"//获取发现照片地址

#define API_SelectTaskCountByDayNum @"SelectTaskCountByDayNum"//获取发现任务数量
#define API_SelectTaskListByDayNum @"SelectTaskListByDayNum"//获取发现任务列表
#define API_SelectHealthcareLogListByDayNum @"SelectHealthcareLogListByDayNum"//获取保健日记列表
#define API_UpdateHealthcareLog @"UpdateHealthcareLog"//更新保健日记
#define API_GET_EXPERTCONSUMPTIONINFO @"GetExpertConsumptionInfo"//获取消费优惠券统计 
#define API_GET_ALLEXPERTCONSULTATIONLISTBYKEYWORDV1 @"GetAllExpertConsultationListByKeywordV2"//获取咨询专家搜索接口V1

#define API_GET_ALLEXPERTCONSULTATIONLISTBYKEYWORD @"GetAllExpertConsultationListByKeyword"//获取咨询专家搜索接口

#define API_GET_FIRSTARTICLE @"GetFirstArticle"//获取首页每日必读

#define API_GET_ARTICLECOMMENTLIST @"GetArticleCommentList"//获取文章评论列表

#define API_INSERT_ARTICLECOMMENT @"InsertArticleComment"//新增文章评论列表
#define API_GET_ARTICLEPRAISEBYUSERID @"GetArticlePraiseByUserID"//获取用户是否点赞

#define API_INSERT_ARTICLEPRAISE @"InsertArticlePraise"//文章点赞
#define API_CANCEL_ARTICLEPRAISE @"CancelArticlePraise"//文章取消点赞
#define API_GET_ARTICLECOMMENTREPLYLIST @"GetArticleCommentReplyList"//回复评论详情

#define API_GET_ADVISE_BY_BODY @"getAdviseByBody"//首页身高体重-保存
#define API_GetGESELLByChildID @"GetGESELLByChildID"//获取医院测评Gesell表数据
#define API_GetEHR_DDST_Result @"GetEHR_DDST_Result"//获取DDST表数据

#define API_GetEHR_Erxin_Result @"GetEHR_Erxin_Result"//获取儿心量表数据
#define API_GetCHILDRENByChildID @"GetCHILDRENByChildID"//获取婴儿神经运动筛查数据
#define API_GetScaleMeaSureByTableNameAndChildID @"GetScaleMeaSureByTableNameAndChildID"//获取心理量表数据


#define API_SET_NICKNAME @"SetNickName"//修改昵称

#define API_FREELISTENING @"FreeListening"//限时免费计数

#define API_GET_VOICE_WORDSCONSULTATION @"GetVoiceAndWordsConsultationListByUserID"

#define API_GET_VOICE_WORDSCONSULTATIONV1 @"GetVoiceAndWordsConsultationListByUserIDV2"


#define API_GET_THERAPEUTIC_VISTBYCONSULATIONID @"GetTherapeuticVisitByConsultationID"   //获取疗效回访


#define API_GET_CONSULATIONCOMMENTLIST @"GetConsultationCommentList"//获取咨询评论列表

#define API_GET_CONSULATIONCOMMENTLISTV1 @"GetConsultationCommentListV2"//获取咨询评论列表V1

#define API_INSERT_CONSULTATIONCOMMENT @"InsertConsultationCommentV1"//新增咨询评论列表
#define API_ADD_WORDS_CONSULTATION @"AddWordsConsultationV1"

#define API_GET_REPLY_COMMENT @"GetReplyComment"  //获得咨询回复列表
#define API_GET_REPLY_COMMENTV1 @"GetReplyCommentV1"  //获得咨询回复列表v1

#define API_ADD_REPLY_COMMENT @"AddReplyComment"  //插入咨询回复

//聊天
#define GET_DIALOG_INFO_LIST @"GetDialogInfoList"//获取会话列表
#define DELETE_DIALOG_INFO @"DeleteDialogInfo"//删除单条会话
#define GET_DIALOG_INFO @"GetDialogInfo"//获取私聊
#define GET_DIALOG_DETAIL_LIST @"GetDialogDetailList"//获取聊天内容
#define INSERT_DIALOG_DETAIL @"InsertDialogDetail"//回复单条聊天内容
#define DELETE_DIALOG_DETAIL_BY_ID @"DeleteDialogDetailByID"//删除单条聊天内容

#define API_GetUserIsUseCoupon @"GetUserIsUseCoupon"//获取用户是否优惠码新用户
#define API_ClaimCouponByCouponCode @"ClaimCouponByCouponCode"//根据优惠码获取优惠券

#define GET_ARTICLES @"GetArticles"//获取每日必读往期文章
#define INSERT_CONSULTATION_PRAISE @"InsertConsultationPraise"//咨询点赞
#define CANCEL_CONSULTATION_PRAISE @"CancelConsultationPraise"//取消点赞
#define INSERT_BABY_BODY_DATA_MONTH @"InsertBabyBodyDataMonth"//录入新身高体重
#define UPDATE_BABY_BODY_DATA @"UpdateBabyBodyData"//更新已有身高体重记录

#define GREATE_WX_ORDER @"CreateWxOrder"//获取微信订单
#define QUERRY_WX_ORDERSTATE @"QueryWxOrderState"//查询微信订单状态
#define API_GetVaccinePlane @"GetVaccinePlan"

#define API_GetCoulationCommentSingle @"GetConsultationComment" //获取单条热门咨询回复单条数据

#define API_GetCoulationCommentSingleV1 @"GetConsultationCommentV1" //获取单条热门咨询回复单条数据V1

#define API_DeleteReplyCommentByID @"DeleteReplyCommentByID" //删除帖子评论回复

#define API_DeletePatientCommentReplay @"DeletePatientCommentReplay"

#define API_DeleteConsultationComment @"DeleteConsultationComment" //删除帖子咨询评论

#define API_DeleteArticleComment @"DeleteArticleComment" // 删除头条1

#define API_DeleteAdmissionComment @"DeleteAdmissionComment" //删除 病友案例

#define API_DeleteWordsConsultationByID @"DeleteWordsConsultationByID" //删除帖子 

#define API_GetCircleSingle @"getwordsconsultation" //获取单条圈子详情单条数据
#define API_GetCircleSingleV1 @"getwordsconsultationV1" //获取单条圈子详情单条数据v1

#define API_Get_Daily_Remind @"GetUserRemindDay"//每日提醒

#define API_GetNewExpertDoctorInfo @"GetNewExpertDoctorInfo"//扫码获取医院信息
#define API_BindHospital @"BindHospital"//绑定医院
#define API_getmyhospitallist @"getmyhospitallist"//获取我绑定的医院列表


#define API_GET_EXPERT_CONSULTATION @"GetExpertConsultation"//获取问题详情

#define API_Search_Doctor_Article_Consultation @"SearchDoctorOrArticleOrConsultation"
#define API_Get_AdmissionRecordList @"GetAdmissionRecordList"//病友案例列表
#define API_Get_AdmissionRecordListV1 @"GetAdmissionRecordListV1"//病友案例列表V1

#define API_Get_AdmissionRecordDetail @"GetAdmissionRecordDetail"//病友案例详情

#define API_Get_AdmissionRecordDetailV1 @"GetAdmissionRecordDetailV1"//病友案例详情V1

#define API_Get_AdmissionComment @"GetAdmissionComment"//入院纪录评论
#define API_Get_AdmissionCommentV1 @"GetAdmissionCommentV2"//入院纪录评论v1
#define API_Add_AdmissionComment @"AddAdmissionCommentV1"//新增入院记录评论
#define API_Get_PatientCommentReply @"GetPatientCaseCommentReplay"
#define API_Get_PatientCommentReplyV1 @"GetPatientCaseCommentReplayV1"
#define API_InsertPatientCommentReply @"InsertPatientCommentReplay"

#define API_GetGoodsList @"GetGoodsList"//获取健康服务商品列表
#define API_getgoodsdetails @"getgoodsdetails"//获取健康服务商品详情
#define API_CreateGoodsOrder @"CreateGoodsOrder"//创建健康服务订单

#define API_GetMyOrderList @"GetMyOrderList"//获取我的健康服务订单列表
#define API_GetMyOrderListV1 @"GetMyOrderListV1"//获取我的健康服务订单列表V1
#define API_CreateGoodsWxOrder @"CreateGoodsWxOrder"//获取健康服务订单微信支付信息
#define API_CloseOrder @"CloseOrder"//取消健康服务订单
//清除推送角标
#define API_CLEARBADGE @"ClearBadge"
#define API_Search_Doctor_Article_ConsultationV1  @"SearchDoctorOrArticleOrConsultationV1"   //首页搜索V1接口
#define API_Search_Doctor_Article_ConsultationV3  @"SearchDoctorOrArticleOrConsultationV4"   //首页搜索V3接口

#define API_GET_FIRST_VACCINE @"GetFirstVaccineByMonth"//获取我的疫苗

#define API_GET_QUEST_TYPELIST @"GetQuestTypeList"//获取饮食测评列表
#define API_GET_QUEST_QUESTLIST @"GetQuestQuestList"//获取饮食测评问题详情
#define API_GET_QUEST_CHOICERESULT @"GetQuestChoiceResult"//提交饮食测评结果

#define API_QUERY_QUESTION_RECOMMENDV3 @"GetAllExpertConsultationListV3"//获取首页热点问题v3


#define API_GetBabyFoodTips @"GetBabyFoodTips"//膳食管理宝宝提示
#define API_GetHotKeyWord @"GetHotKeyWord"//膳食管理获取热门关键字
#define API_SearchFoodByKeyWords @"SearchFoodByKeyWords"//膳食管理搜索食物
#define API_AddUserFood @"AddUserFood"//膳食管理用户食材列表添加食材
#define API_GetUserFoodList @"GetUserFoodList"//膳食管理获取用户食材列表
#define API_DelUserFood @"DelUserFood"//膳食管理用户食材列表删除食材
#define API_GetFoodAnalysis @"GetUserFoodAnalysis"//膳食管理获取用户营养分析
#define API_GetExpertHalfPrice @"GetExpertHalfPrice"//获取半价追问信息

#define API_GET_FIRSTACTIVITY @"GetFirlstActivity"//获取第一个活动
#define API_BindWx2ml @"BindWx2ml" //绑定微信医生

#define API_AddExpertComment @"AddExpertComment"//添加医生评价
#define API_GetExpertCommentList @"GetExpertCommentList"//获取医生评价
//#define API_Getdocfullanwerconsultation @"getdocfullanwerconsultation"//获取相关咨询
#define API_GetdocfullanwerconsultationV1 @"GetDocFullAnwerConsultationV2"//获取相关咨询V1

#define API_GetBindExpertList @"GetBindExpertList"//获取绑定医生列表
#define API_CancelBindExpert @"CancelBindExpert"//取消绑定医生
//#define API_GET_Push_DOCANSWERCONSULATION @"GetDocAnwerConsultation" //推送医生已回答页面数据
#define API_GET_Push_DOCANSWERCONSULATIONV1 @"GetDocAnwerConsultationV1" //推送医生已回答页面数据
// 头条
#define API_GetDayArticles @"GetDayArticles"// 今日推荐
#define API_GetChoiceArticles @"GetChoiceArticles" //精选
#define API_GetOrderArticles @"GetOrderArticles" // 排行
#define API_GetCategoryArticleList @"GetCategoryArticleList" //更多


// 消息和通知
#define API_getsystemmessage @"getsystemmessage" // 系统消息
#define API_GetCommontMessage @"GetCommontMessage" // 评论 
#define API_getmyfavorite @"getmyfavorite" // 喜欢
#define API_GetConsultationBeListen @"GetConsultationBeListen" //听过
#define API_gettempsystemmessage @"gettempsystemmessage" //以前的通知
#define API_setmessageread @"setmessageread" // 红点 未读消息数


#define API_GetMyDialogList @"GetMyDialogList" //聊天
#define API_GetTalkDetail @"GetTalkDetail" // 新聊天详情
#define API_getmymsgunreadstate @"getmymsgunreadstate" //首页红点

#endif /* ApiMacro_h */
