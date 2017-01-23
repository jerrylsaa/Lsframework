//
//  AppConfig.h
//  FamilyPlatForm
//
//  Created by Tom on 16/3/26.
//  Copyright © 2016年 梁继明. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

#define kLoginKey @"zhonghong8268793"

#define kAlipayParner @"2088421321188712"
#define kAlipaySeller @"sdtyhjk@126.com"

#ifdef DEBUG
#define kAlipayNotifyURL @"http://120.55.64.44:9020/AliPay/notify_url.aspx"
#define kAlipayHealthServiceNotifyURL @"http://120.55.64.44:9020/AliPay/g_notify_url.aspx"
#else
#define kAlipayNotifyURL @"http://etjk365.dzjk.com:8084/AliPay/notify_url.aspx"
#define kAlipayHealthServiceNotifyURL @"http://etjk365.dzjk.com:8084/AliPay/g_notify_url.aspx"

#endif

#define kAlipayAppScheme @"FamilyPlatform"//应用注册scheme,在Info.plist定义URL types

#define kAlipayPrivateKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMlUCiX5rEBQMwKvzgUCYYB/sb+1Nqqf335RmIEa5BEqJ6GNFzge3poX551ix5IO9m1nicSNwzPUU/lVzY3ULdAWxZDHCwMhiz9EES/ujR6Z7ilMzdR3wxiocaUJr+Qx7os6bgtz03krciKlqj5Xqzi9wSRiMFvC6/McLunAKThxAgMBAAECgYBx4/rBtNX+o9/Xe0CekNQ7bwFMo+TC7SHvQZV2I5I1K5WzzC8AbmYa4b8Cx6iCNbit9052RIPSxCClAicAPrGS7w+0BhXYVnpUuJgNJ1ZBo/ulajNco+KkmAXf3mc7ZWmMoKsquS5Pai3ru1Awcvat36quUwty7U/l5jxDDJMiKQJBAOVyzUm4EAIwdqXbp9PjdYQZpVLkGiBIzjempaL7Ekog+7gTzW/oByaxYVYV83lD2rMDqMiKkJU7dYLH5fzT9RsCQQDgoDQusIZZ2Z9KnEuUBGaS2Fvi30gUx4AaPbhKXDN/ckngZsk/XZUtDkXBkcDFvqfsmjmzIQlHG7t+5kRY/j1jAkEAxflXPgtN7MWqKhOr7Dxvckq6hhoAnOiU3hmxAz5FGqb46mxTrwHx4aXdSWzpRjGQ6zL2GArPE6RZET2vqIWuDwJAYqja4pr0F6jHFy044OVh7CONkEND1KSfdmcfd8GxeMvI+QAMaoF/ERAQwWl0QyZveTNwHmZnPc1HeABJitD4QwJAFHRB55GR2hb1kGrhg9zVGIjGmrkQu3OHSwB6/TP0zEsBDBGUNXwwHD/ZrVVyy3jKypJe4BEJh8cYwMbPwrVIIA=="

#define kPageSize 10

#define configureKey @"openzjzx"//展示/隐藏专家解答和我的咨询入口key
#define openMZYYKey @"openmzyy"//门诊预约和我的预约

#endif /* AppConfig_h */
