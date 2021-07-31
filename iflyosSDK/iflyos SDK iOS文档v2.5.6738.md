# APP iOS SDK

[TOC]

## 版本

vv2.5.6738 [点击下载SDK](https://cdn.iflyos.cn/docs/app_ios_sdk.zip)

|版本|更新内容|支持设备| 支持OS版本|webView版本|
|---|-------|-------|---------|-----------|
|v1.0 |iflyos SDK |iPhone,iPad|iOS 9以上版本| WKWebView|
|v1.1 |1.新增webViewAppear, webViewDisappear 接口<br>2.授权本地注册JS回调authSuccess，authFail|iPhone,iPad|iOS 9以上版本| WKWebView|
|v1.2 |1.新增声波配网模块 <br> 2.新增蓝牙配网模块 <br> 3.新增设备操作功能（设置别名，唤醒词，发音人，勿扰模式，蓝牙模式，设备更新，设备重启，重新配网，恢复出厂，红外遥控）|iPhone,iPad|iOS 9以上版本| WKWebView|
|v1.2.1 |1.新增用户信息接口|iPhone,iPad|iOS 9以上版本| WKWebView|
|v1.3.11596 |1.是配iPhoneXs/Xs Max设备的声波配网|iPhone,iPad|iOS 9以上版本| WKWebView|
|v1.3.12017 |1.新增第三方自定义登陆接口|iPhone,iPad|iOS 9以上版本| WKWebView|
|v1.3.13419 |1.新增信源接口，内容分组接口，取消信源全部收藏接口 <br> 2.音乐部分接口新增信源字段 <br> 3.解决授权后调用closePage接口问题|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|v1.5.15091 |1.新增BLE配网功能<br>2.新增BLE设备client类型查询接口，deviceCode获取接口和BLE授权状态接口|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|v1.5.16489 |1.新增openNewBrower打开外链接 2.新增酷狗多账号登录支持|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|v1.5.18565 |1.更新部分接口，新增儿童模式 2.独立拆分声波配网SDK（libiflyosQuietSDKForiOS.a）|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|v2.0.23064 |1.更新getUserId和getUserInfo接口 2.更新部分接口错误返回信息 3.更新web页面路由|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|v2.2.31144 |1.新增留言板功能，2.新增获取token接口|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|v2.2.49898 |1.新增专辑播放列表，2.新增新收藏接口，3，新增快捷指令，聊天设置，持续交互，4.新增注销接口，5.兼容xcode11和ios13|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|v2.4.78447 |1.新增信源列表跳转登陆功能 2.根据信源类型跳转登陆页面|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|v2.4.100309 |1.更新SDK兼容AFNetwork4.0|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|v2.5.2677 |1.更新setDeviceAlias zone字段可修改设备位置|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|v2.5.3828 |1.新增AP配网接口，2.新增WS推送服务|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|v2.5.4334 |1.新增获取标签 2.新增播放记录接口 3.新增删除记录接口 4.新增获取播放列表接口|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|v2.5.4445 |1.去除酷狗SDK 2.修改播放记录播放方法名|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|v2.5.5703 |1.新增第三方跳转支付页面|iPhone,iPad|iOS 10.1以上版本| WKWebView|
|vv2.5.6738 |1.IFTTT接口 ， 2.优化推送服务|iPhone,iPad|iOS 10.1以上版本| WKWebView|
## SDK文件

- include<br>
	- iflyosSDKForiOS<br>
		- ....
- libiflyosSDKForiOS.a
- libiflyosQuietSDKForiOS.a
- libiflyosPushService.a

## 工程配置
### 引入SDK
1. 把iflyosSDKForiOS.a和头文件拖到工程
2. target->build settings->Library Search Paths 设置SDK静态库路径
3. target->build settings->Header Search Paths 设置头文件路径
4. 若提示bitcode错误，则在buid settings搜索Enable Bitcode，然后设置为NO
5. Other Linker Flags -> -ObjC

### 依赖库

- AVFoundation
- AFNetworking
- SBJson
- XMLReader-PPTV
- WebViewJavascriptBridge

### profile
```
platform :ios, '10.1'
workspace 'iflyosSDK.xcworkspace'
inhibit_all_warnings!
use_frameworks!

target 'iflyosSDKDemo' do
    project 'iflyosSDKDemo/iflyosSDKDemo.xcodeproj'
    pod 'AFNetworking'
    #pod 'CocoaAsyncSocket'
    pod 'SBJson', '~> 3.2'
    pod 'XMLReader-PPTV'
    pod 'WebViewJavascriptBridge'
    pod 'SocketRocket'
end
```
### 头文件引入
```C
#import <iflyosSDKForiOS/iflyosCommonSDK.h>
#import <iflyosQuietSDKForiOS/iflyosQuietSDKForiOS.h>
#import <libiflyosPushService/libiflyosPushService.h>
```

## 使用说明

### SDK初始化
```C
[[IFLYOSSDK shareInstance] initAppId:@"iflyos网站申请的app id" type:DEFUALT/CUSTOM];
```

* DEFUALT 默认iflyos App登录模式
* CUSTOM 第三方登录模式，用户通过setCustomToken方式设置Token完成登录

### webView注册

1. 注册webView : `[[IFLYOSSDK shareInstance] registerWebView:self.webView handler:self tag:@"此webView的标识符"]`;
2. 设置WKWebView代理 : `[[IFLYOSSDK shareInstance] setWebViewDelegate:self tag:@"此webView的标识符"]`;
3. 注销webView : `[[IFLYOSSDK shareInstance] unregisterWebView:@"此webView的标识符"]`;

### webView

::: tip
若不设置WKWebView代理，则webView会把代理交给SDK处理，客户端将无法获得WebView的回调
:::

### BLE蓝牙搜索
```/
ServiceUUID:00001ff9-0000-1000-8000-00805f9b34fb//服务的UUID
WriteCharacteristicUUID:00001ffa-0000-1000-8000-00805f9b34fb//写特征的UUID
ReadCharacteristicUUID:00001ffa-0000-1000-8000-00805f9b34fb//读特征的UUID

/**
*	aaaa:前四位是厂商flag
*	xxxx-xxxx-xxxx-xxxx:clientId
*/
BLE AdvertData:<aaaa xxxx-xxxx-xxxx-xxxx> 
```

### 注意事项

- SDK初始化—— 选择CUSTOM登录模式时，openLoginPage无法打开登录页。

- 声波配网——发送声波数据时，必须把手机放在设备的麦克风收音处，否则会影响成功率

- 接口使用——除了声波发送功能外，其他接口需要进行登录后才能使用

- iPhone手机——由于18年发布的iPhoneXR/Xs/Xs Max这几款使用了双立体声扬声器，手机下扬声器播放的声波会失真，声波配网时，这几款手机必须使用手机上扬声器进行发送声波配网

- 由于每个开发者环境不一样，SDK中的config.xml,xxx.htm,xxx.json等资源文件若无法读取，请拖到SDK文件夹外，项目工程里即可


## 接口

### 1.初始化 

#### initAppId:loginType

| 参数  | 类型   | 说明                                                  | 备注 |
| ----- | ------ | ----------------------------------------------------- | ---- |
| appId | string | 在[iFLYOS开放平台](https://open.iflyos.cn)申请的appid |      |
|loginType|LOGIN_TYPE|登录模式|DEFUALT/CUSTOM|
|schema|string|app约定|target名|

#### 返回值

无



### 2.判断是否已经登录

#### isLogin

无参数

#### 返回值

| 参数    | 类型 | 说明         | 备注                   |
| ------- | ---- | ------------ | ---------------------- |
| isLogin | BOOL | 是否已经登录 | YES：已登录 <br>NO：未登录 |



### 3.登录

#### openLogin

| 参数 | 类型   | 说明   | 备注 |
| ---- | ------ | ------ | ---- |
| tag  | string | 标识符 |      |

#### 返回值

无



### 4.注销登录

#### logout

| 参数    | 类型                       | 说明         | 备注                       |
| ------- | -------------------------- | ------------ | -------------------------- |
| handler | id\<IFLYOSsdkLoginDelegate\> | 回调处理对象 | IFLYOSsdkLoginDelegate协议 |

#### 返回值

无



### 5.设置WKWebView代理

#### setWebViewDelegate:tag:

| 参数   | 类型                  | 说明                | 备注                  |
| ------ | --------------------- | ------------------- | --------------------- |
| target | id\<WKWebViewDelegate\> | webView回调处理对象 | WKWebViewDelegate协议 |
| tag    | string                | 标识符              |                       |

#### 返回值

无



### 6.注册WebView服务

#### registerWebView:handler:tag

| 参数    | 类型                                        | 说明         | 备注                                        |
| ------- | ------------------------------------------- | ------------ | ------------------------------------------- |
| webView | WKWebView                                   | webView对象  |                                             |
| handler | id<IFLYOSsdkDelegate,<br>IFLYOSsdkAuthDelegate> | 回调处理对象 | IFLYOSsdkDelegate,<br>IFLYOSsdkAuthDelegate协议 |
| tag     | string                                      | 标识符       |                                             |

#### 返回值

无



### 7.注销WebView服务

#### unregisterWebView

| 参数 | 类型   | 说明   | 备注 |
| ---- | ------ | ------ | ---- |
| tag  | string | 标识符 |      |

#### 返回值

无



### 8.打开新web页面

#### openNewPage

| 参数 | 类型   | 说明   | 备注 |
| ---- | ------ | ------ | ---- |
| tag  | string | 标识符 |      |

#### 返回值

无



### 9.打开内置web页面

#### openWebPage:pageIndex:deviceId:

| 参数       | 类型          | 说明             | 备注 |
| ---------- | ------------- | ---------------- | ---- |
| webViewTag | string        | 标识符           |      |
| pageIndex  | URL_PATH_ENUM | 内置页面索引参数 | 枚举 |
| deviceId   | string        | 设备ID           | 可选 |

| 枚举       | 说明          |
| ---------- | ------------- |
| SKILLS | 语音技能        |
| ACCOUNTS | 内容账号        |
| CLOCKS | 我的闹钟        |
| CONTROLLED_DEVICES | 被控设备        |
| PERSONAL_VOICE | 留声 |
| WAKEUP_WORDS | 唤醒词        |
| SLEEP | 定时休眠        |
| SPEARER | 发音人        |
| BLUETOOTH | 蓝牙连接        |
| DEVICE_VERSION_UPDATE | 版本升级        |
| TALK | 对话        |
| IFTTT | IFTTT训练计划       |
| DEVICE_ZONE | 设备位置设置        |


#### 返回值

无



### 10.打开设备认证页

#### openAuthorizePage:url

| 参数 | 类型   | 说明               | 备注 |
| ---- | ------ | ------------------ | ---- |
| tag  | string | 标识符             |      |
| url  | string | 设备返回的认证 url |      |

#### 返回值

| 参数 | 类型 | 说明     | 备注                                                         |
| ---- | ---- | -------- | ------------------------------------------------------------ |
| -    | int  | 调用状态 | 1:调用成功 <br>0:未初始化AppId<br>-1:找不到可调用的webView<br>-2:传入参数不合法<br>-3:未登录 |



### 11.webView页出现时调用

#### webViewAppear

| 参数       | 类型   | 说明   | 备注 |
| ---------- | ------ | ------ | ---- |
| webViewTag | string | 标识符 |      |

#### 返回值

无



### 12.webView页消失时调用

#### webViewDisappear

| 参数       | 类型   | 说明   | 备注 |
| ---------- | ------ | ------ | ---- |
| webViewTag | string | 标识符 |      |

#### 返回值

无



### 13.获取用户已绑定设备列表

#### getUserDevices

| 参数        | 类型 | 说明     | 备注               |
| ----------- | ---- | -------- | ------------------ |
| statusCode  | int  | 状态码   | http请求响应状态码 |
| successData | id   | 成功回调 |                    |
| failData    | id   | 失败回调 |                    |

#### 返回值

| 参数               | 类型   | 说明               | 备注                  |
| ------------------ | ------ | ------------------ | --------------------- |
| user_devices       | array  | 用户绑定的设备列表 |                       |
| infrared           | json   | 红外               |                       |
| infrared.client_id | string | 设备clientId       |                       |
| infrared.logo      | string | logo图片url        |                       |
| alias              | string | 设备别名           |                       |
| device_id          | string | 设备唯一ID         |                       |
| name          | string | 设备名         |                       |
| image              | string | 设备图片URL        |                       |
| music              | json   | 音乐资源字段       |                       |
| music.enable       | bool   | 是否可用           | YES：可用，NO：不可用 |
| music.text         | string | 文字提示           |                       |
| music.redirect_url | string | 跳转的url          |                       |
| branch | json | 品牌信息 |                       |
| branch.name | string | 品牌信息 |                       |
| branch.logo | string | 品牌logo url |                       |
| branch.id | int | 品牌ID |                       |



### 14.删除用户绑定设备

#### deleteUserDevice

| 参数        | 类型 | 说明     | 备注               |
| ----------- | ---- | -------- | ------------------ |
| deviceId  | string  | 设备ID   | |
| statusCode  | int  | 状态码   | http请求响应状态码 |
| successData | id   | 成功回调 |                    |
| failData    | id   | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |



### 15.获取音频管理首页数据

#### getMusicGroups

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数       | 类型   | 说明     | 备注 |
| ---------- | ------ | -------- | ---- |
| groups     | array  | 音频分组 |      |
| section_id | string | 分组id   |      |
| has_more | bool | 是否有更多  |  可以判断是否打开内容分组列表     |
| name | string | 分组名   |      |
| items | array | 内容分组items   |      |
| descriptions | array | 描述   |      |
| items.id | string | item的id   |      |
| items.name | string | item名称   |      |
| items.description | string | 备注说明   |      |
| items.source_type | string | 信源   |      |

### 16.获取音频管理分组数据列表

#### getMusicGroupsList

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| page    | int | 页码   |                    |
| limit    | int | 每页数量  |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数              | 类型   | 说明          | 备注                         |
| ----------------- | ------ | ------------- | ---------------------------- |
| items            | array  | 列表     |                              |
| from        | string | 来源       |                              |
| name          | string   | 名称  |  |
| image              | string | 图片url        |                              |



### 17.音乐搜索

#### searchMusic

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| keyword     | string | 关键词   |                    |
| page       | int    | 页码 |                    |
| limit       | int    | 每页数量 |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数    | 类型  | 说明     | 备注 |
| ------- | ----- | -------- | ---- |
| total   | int   | 总数量   |      |
| page    | int   | 页码     |      |
| limit   | int   | 每页数量 |      |
| results | array | 结果列表 |      |
| results.id | string | 音乐ID |      |
| results.name | string | 音乐名称 |      |
| results.artist | string | 音乐作者 |      |
| results.source_type | string | 信源类型 |      |
| results.source_name | string | 信源名称 |      |



### 18.用户已收藏列表

#### getMusicCollections

| 参数        | 类型   | 说明             | 备注               |
| ----------- | ------ | ---------------- | ------------------ |
| deviceId    | string | 设备ID           |                    |
| source_type     | string | 信源类型 |                    |
| startId     | string | 列表最后的音乐ID |                    |
| limit       | int    | 每页数量         |                    |
| statusCode  | int    | 状态码           | http请求响应状态码 |
| successData | id     | 成功回调         |                    |
| failData    | id     | 失败回调         |                    |

#### 返回值

| 参数                | 类型   | 说明     | 备注 |
| ------------------- | ------ | -------- | ---- |
| total               | int    | 总数量   |      |
| collections             | array  | 收藏列表 |      |
| collections.id          | string | 音乐ID   |      |
| collections.name        | string | 音乐名称 |      |
| collections.artist      | string | 音乐作者 |      |
| collections.available | bool | 是否可用 |      |
| collections.error_reason | string | 错误原因 |      |



### 19.收藏音乐

#### likeMusic

| 参数        | 类型   | 说明             | 备注               |
| ----------- | ------ | ---------------- | ------------------ |
| mediaId     | string | 音乐ID           |                    |
| source_type | string | 信源类型         |                    |
| statusCode  | int    | 状态码           | http请求响应状态码 |
| successData | id     | 成功回调         |                    |
| failData    | id     | 失败回调         |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |


### 20.取消收藏音乐

#### unlikeMusic

| 参数        | 类型   | 说明             | 备注               |
| ----------- | ------ | ---------------- | ------------------ |
| mediaId     | string | 音乐ID           |                    |
| source_type | string | 信源类型         |                    |
| statusCode  | int    | 状态码           | http请求响应状态码 |
| successData | id     | 成功回调         |                    |
| failData    | id     | 失败回调         |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |


### 21.获取指定设备当前播放器状态

#### getMusicCollections

| 参数        | 类型   | 说明             | 备注               |
| ----------- | ------ | ---------------- | ------------------ |
| deviceId    | string | 设备ID           |                    |
| statusCode  | int    | 状态码           | http请求响应状态码 |
| successData | id     | 成功回调         |                    |
| failData    | id     | 失败回调         |                    |

#### 返回值

| 参数                | 类型   | 说明     | 备注 |
| ------------------- | ------ | -------- | ---- |
| speaker | object | 扬声器状态 |  |
| music_player | object | 播放器状态 |  |
| media | object | 当前正在播放内容，没有播放时为`null` | |
| speaker.volume | int | 当前音量 | 50 |
| speaker.mute | boolean | 是否静音 | false |
| music_player.playing | boolean | 是否正在播放 | true |
| media.source_type | string | 信源类型 | migu |
| media.source | string | 内容提供方 | 咪咕音乐 |
| media.name | string | 内容名称 | 告白气球 |
| media.artist | string | 歌手名称 | 周杰伦 |
| media.image | string | 图片url |  |
| media.liked | boolean | 用户是否收藏 | false |
| media.id | string | 内容id | 236945c65a14933<br>44ae190d2cfe80217 |
| media.source_icon | string | 提供方图标 | "https://..." |
| media.source_description | string | 提供方描述 | "由 咪咕音乐 提供" |


### 22.指定设备播放音乐

#### musicControlPlay

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| mediaId    | string | 音乐ID   |                    |
| source_type    | string | 信源   |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数                     | 类型    | 说明                                 | 备注                             |
| ------------------------ | ------- | ------------------------------------ | -------------------------------- |
| speaker                  | object  | 扬声器状态                           |                                  |
| music_player             | object  | 播放器状态                           |                                  |
| media                    | object  | 当前正在播放内容，没有播放时为`null` |                                  |
| speaker.volume           | int     | 当前音量                             | 50                               |
| speaker.mute             | boolean | 是否静音                             | false                            |
| music_player.playing     | boolean | 是否正在播放                         | true                             |
| media.source_type        | string  | 信源类型                             | migu                             |
| media.source             | string  | 内容提供方                           | 咪咕音乐                         |
| media.name               | string  | 内容名称                             | 告白气球                         |
| media.artist             | string  | 歌手名称                             | 周杰伦                           |
| media.image              | string  | 图片url                              |                                  |
| media.liked              | boolean | 用户是否收藏                         | false                            |
| media.id                 | string  | 内容id                               | 236945c65a14933<br>44ae190d2cfe80217 |
| media.source_icon        | string  | 提供方图标                           | "https://..."                    |
| media.source_description | string  | 提供方描述                           | "由 咪咕音乐 提供"               |

### 23.指定设备播放用户收藏的音乐，mediaId 为空时默认第一首开始播放

#### musicControlPlayCollections

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| mediaId    | string | 音乐ID   |                    |
| source_type    | string | 信源   |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数                     | 类型    | 说明                                 | 备注                             |
| ------------------------ | ------- | ------------------------------------ | -------------------------------- |
| speaker                  | object  | 扬声器状态                           |                                  |
| music_player             | object  | 播放器状态                           |                                  |
| media                    | object  | 当前正在播放内容，没有播放时为`null` |                                  |
| speaker.volume           | int     | 当前音量                             | 50                               |
| speaker.mute             | boolean | 是否静音                             | false                            |
| music_player.playing     | boolean | 是否正在播放                         | true                             |
| media.source_type        | string  | 信源类型                             | migu                             |
| media.source             | string  | 内容提供方                           | 咪咕音乐                         |
| media.name               | string  | 内容名称                             | 告白气球                         |
| media.artist             | string  | 歌手名称                             | 周杰伦                           |
| media.image              | string  | 图片url                              |                                  |
| media.liked              | boolean | 用户是否收藏                         | false                            |
| media.id                 | string  | 内容id                               | 236945c65a14933<br>44ae190d2cfe80217 |
| media.source_icon        | string  | 提供方图标                           | "https://..."                    |
| media.source_description | string  | 提供方描述                           | "由 咪咕音乐 提供"               |

### 24.指定设备播放分类/榜单下所有音乐，mediaIa 为空时默认第一首开始播放

#### musicControlPlayGroup

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| mediaId    | string | 音乐ID   |                    |
| groupId    | string | 分类ID   |                    |
| source_type    | string | 信源   |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数                     | 类型    | 说明                                 | 备注                             |
| ------------------------ | ------- | ------------------------------------ | -------------------------------- |
| speaker                  | object  | 扬声器状态                           |                                  |
| music_player             | object  | 播放器状态                           |                                  |
| media                    | object  | 当前正在播放内容，没有播放时为`null` |                                  |
| speaker.volume           | int     | 当前音量                             | 50                               |
| speaker.mute             | boolean | 是否静音                             | false                            |
| music_player.playing     | boolean | 是否正在播放                         | true                             |
| media.source_type        | string  | 信源类型                             | migu                             |
| media.source             | string  | 内容提供方                           | 咪咕音乐                         |
| media.name               | string  | 内容名称                             | 告白气球                         |
| media.artist             | string  | 歌手名称                             | 周杰伦                           |
| media.image              | string  | 图片url                              |                                  |
| media.liked              | boolean | 用户是否收藏                         | false                            |
| media.id                 | string  | 内容id                               | 236945c65a14933<br>44ae190d2cfe80217 |
| media.source_icon        | string  | 提供方图标                           | "https://..."                    |
| media.source_description | string  | 提供方描述                           | "由 咪咕音乐 提供"               |

### 25.指定设备停止播放

#### musicControlStop

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数                     | 类型    | 说明                                 | 备注                             |
| ------------------------ | ------- | ------------------------------------ | -------------------------------- |
| speaker                  | object  | 扬声器状态                           |                                  |
| music_player             | object  | 播放器状态                           |                                  |
| media                    | object  | 当前正在播放内容，没有播放时为`null` |                                  |
| speaker.volume           | int     | 当前音量                             | 50                               |
| speaker.mute             | boolean | 是否静音                             | false                            |
| music_player.playing     | boolean | 是否正在播放                         | true                             |
| media.source_type        | string  | 信源类型                             | migu                             |
| media.source             | string  | 内容提供方                           | 咪咕音乐                         |
| media.name               | string  | 内容名称                             | 告白气球                         |
| media.artist             | string  | 歌手名称                             | 周杰伦                           |
| media.image              | string  | 图片url                              |                                  |
| media.liked              | boolean | 用户是否收藏                         | false                            |
| media.id                 | string  | 内容id                               | 236945c65a14933<br>44ae190d2cfe80217 |
| media.source_icon        | string  | 提供方图标                           | "https://..."                    |
| media.source_description | string  | 提供方描述                           | "由 咪咕音乐 提供"               |

### 26.指定设备继续播放

#### musicControlResume

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数                     | 类型    | 说明                                 | 备注                             |
| ------------------------ | ------- | ------------------------------------ | -------------------------------- |
| speaker                  | object  | 扬声器状态                           |                                  |
| music_player             | object  | 播放器状态                           |                                  |
| media                    | object  | 当前正在播放内容，没有播放时为`null` |                                  |
| speaker.volume           | int     | 当前音量                             | 50                               |
| speaker.mute             | boolean | 是否静音                             | false                            |
| music_player.playing     | boolean | 是否正在播放                         | true                             |
| media.source_type        | string  | 信源类型                             | migu                             |
| media.source             | string  | 内容提供方                           | 咪咕音乐                         |
| media.name               | string  | 内容名称                             | 告白气球                         |
| media.artist             | string  | 歌手名称                             | 周杰伦                           |
| media.image              | string  | 图片url                              |                                  |
| media.liked              | boolean | 用户是否收藏                         | false                            |
| media.id                 | string  | 内容id                               | 236945c65a14933<br>44ae190d2cfe80217 |
| media.source_icon        | string  | 提供方图标                           | "https://..."                    |
| media.source_description | string  | 提供方描述                           | "由 咪咕音乐 提供"               |

### 27.指定设备播放上一首

#### musicControlPrevious

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数                     | 类型    | 说明                                 | 备注                             |
| ------------------------ | ------- | ------------------------------------ | -------------------------------- |
| speaker                  | object  | 扬声器状态                           |                                  |
| music_player             | object  | 播放器状态                           |                                  |
| media                    | object  | 当前正在播放内容，没有播放时为`null` |                                  |
| speaker.volume           | int     | 当前音量                             | 50                               |
| speaker.mute             | boolean | 是否静音                             | false                            |
| music_player.playing     | boolean | 是否正在播放                         | true                             |
| media.source_type        | string  | 信源类型                             | migu                             |
| media.source             | string  | 内容提供方                           | 咪咕音乐                         |
| media.name               | string  | 内容名称                             | 告白气球                         |
| media.artist             | string  | 歌手名称                             | 周杰伦                           |
| media.image              | string  | 图片url                              |                                  |
| media.liked              | boolean | 用户是否收藏                         | false                            |
| media.id                 | string  | 内容id                               | 236945c65a14933<br>44ae190d2cfe80217 |
| media.source_icon        | string  | 提供方图标                           | "https://..."                    |
| media.source_description | string  | 提供方描述                           | "由 咪咕音乐 提供"               |

### 28.指定设备播放下一首

#### musicControlNext

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数                     | 类型    | 说明                                 | 备注                             |
| ------------------------ | ------- | ------------------------------------ | -------------------------------- |
| speaker                  | object  | 扬声器状态                           |                                  |
| music_player             | object  | 播放器状态                           |                                  |
| media                    | object  | 当前正在播放内容，没有播放时为`null` |                                  |
| speaker.volume           | int     | 当前音量                             | 50                               |
| speaker.mute             | boolean | 是否静音                             | false                            |
| music_player.playing     | boolean | 是否正在播放                         | true                             |
| media.source_type        | string  | 信源类型                             | migu                             |
| media.source             | string  | 内容提供方                           | 咪咕音乐                         |
| media.name               | string  | 内容名称                             | 告白气球                         |
| media.artist             | string  | 歌手名称                             | 周杰伦                           |
| media.image              | string  | 图片url                              |                                  |
| media.liked              | boolean | 用户是否收藏                         | false                            |
| media.id                 | string  | 内容id                               | 236945c65a14933<br>44ae190d2cfe80217 |
| media.source_icon        | string  | 提供方图标                           | "https://..."                    |
| media.source_description | string  | 提供方描述                           | "由 咪咕音乐 提供"               |

### 29.指定设备控制音量

#### musicControlVolume

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| volume    | int | 音量   |        [0-100]            |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数                     | 类型    | 说明                                 | 备注                             |
| ------------------------ | ------- | ------------------------------------ | -------------------------------- |
| speaker                  | object  | 扬声器状态                           |                                  |
| music_player             | object  | 播放器状态                           |                                  |
| media                    | object  | 当前正在播放内容，没有播放时为`null` |                                  |
| speaker.volume           | int     | 当前音量                             | 50                               |
| speaker.mute             | boolean | 是否静音                             | false                            |
| music_player.playing     | boolean | 是否正在播放                         | true                             |
| media.source_type        | string  | 信源类型                             | migu                             |
| media.source             | string  | 内容提供方                           | 咪咕音乐                         |
| media.name               | string  | 内容名称                             | 告白气球                         |
| media.artist             | string  | 歌手名称                             | 周杰伦                           |
| media.image              | string  | 图片url                              |                                  |
| media.liked              | boolean | 用户是否收藏                         | false                            |
| media.id                 | string  | 内容id                               | 236945c65a14933<br>44ae190d2cfe80217 |
| media.source_icon        | string  | 提供方图标                           | "https://..."                    |
| media.source_description | string  | 提供方描述                           | "由 咪咕音乐 提供"               |

### 30.设置设备别名

#### setDeviceAlias

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| alias    | string | 别名  |                  |
| childrenMode    | Bool | 儿童模式  |                  |
| continousModel | Bool   | 是否开启持续交互 |                    |
| statusCode     | int    | 状态码           | http请求响应状态码 |
| successData    | id     | 成功回调         |                    |
| failData | id | 失败回调 | |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |

### 31.设备详情

#### getDeviceInfo

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| alias | string | 设备别名，没有设置时为`null` |     |
| sleep | string | 定时休眠配置，关闭时为`null` |     |
| sleep_config.enable | boolean | 定时休眠配置，是否开启 |     |
| sleep_config.start | boolean | 定时休眠开始时间 |     |
| sleep_config.end | boolean | 定时休眠结束时间 |     |
| bluetooth_enable | boolean | 蓝牙是否开启 |     |
| speaker | string | 发音人名称 |     |
| wakeword | string | 唤醒词 |     |
| new_version | boolean | 是否有新版本 |     |
| infrared | object | 设备红外控制参数，字段不存在时红外配置 |     |
| infrared.client_id | object |  红外控制设备client_id |     |
| infrared.logo | object |  红外控制设备logo |     |
| reboot | boolean | 设备重启，默认为true |     |
| reset_network | boolean | 重新配网，默认为true |     |
| restore_factory | boolean | 恢复出厂默认为true |     |
| music_access | object | 音乐使用权限 |     |
| music_access.name | string | 显示名称 |     |
| music_access.value | string | 显示值 |     |
| music_access.redirect_url | string | 跳转地址 |     |

### 32.设备重启

#### rebootDevice

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |

### 33.设备恢复出厂设置

#### restoreDeviceToFactorySetting

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |

### 34.设备重新配网

#### resetDeviceNetwork

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备ID   |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |

### 35.声波配网（libiflyosQuietSDKForiOS.h）

#### sendQuiet (调用一次，发出一个（嘶嘶声）声波，一个声波代表一段完整的信息)

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| ssid    | string | wifi ssid   |                    |
| password  | string    | wifi密码   |   		|
| isAuth | bool     | 是否进行授权 |               |

#### 返回值

无


### 36.红外按键测试

#### infraredButtonTest

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| clientDeviceId    | string | 设备ID   |                    |
| extends  | dictionary    | 自定义扩展  | 数据格式主要是json |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |

### 37.红外添加设备信息

#### infraredAddDeviceInfo

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| clientDeviceId    | string | 设备ID   |                    |
| extends  | dictionary    | 自定义扩展  | 数据格式主要是json |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |

### 38.获取用户userId

#### getUserId

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| user_id     | string  | 用户唯一id               |      |

### 39.设置第三方登录token

#### setCustomToken

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| token    | string | 自定义token   |      初始化时选择（CUSTOM模式）第三方登录用，代替默认登录方式         |

#### 返回值

无

### 40.获取信源列表

#### getMediaSources

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| sources     | array  |信源列表              |      |
| sources.name | string | 信源名称 |      |
| sources.icon | string | 信源图片url |      |
| sources.source_type | string | 信源类型 |      |
| sources.user_collections_count | string | 收藏数量 |      |

### 41.取消信源所有收藏

#### deleteMediaSourcesWithType

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| sourceType | string    | 信源类型 |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |

### 42.获取内容分组列表

#### getMediaGroupList

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| sectionId | string    | 分组ID |                    |
| deviceId | string    | 设备ID |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| section_id     | string  | 分组ID               |      |
| name | string | 分组名 |      |
| descriptions | string | 描述 |      |
| items | string | 分组列表 |      |
| items.name | string | 分组名 |      |
| items.image | string | 分组图片URL |      |
| items.description | string | 分组描述 |      |
| items.id | string | 分组ID  |      |

### 43.根据设备clientId获取设备信息

#### getClientInfo

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| clientId | string    | clientId | BLE advertData中获取的clientId                  |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| client_id     | string  | clientId               |      |
| client_name | string | 设备类型名 |      |
| client_image | string | 设备类型图片 |      |

### 44.获取deviceCode

#### getClientInfo

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| clientId | string    | clientId | BLE advertData中获取的clientId                  |
| deviceId | string    | deviceId | BLE 连接成功后通过readValueForCharacteristic (00001ffa-0000-1000-8000-00805f9b34fb) 获取的deviceId                 |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| expires_in  | string  | 有效期               |      |
| device_code | string | device code |      |

### 45.BLE 授权状态查询

#### getClientInfo

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| clientId | string    | clientId | BLE advertData中获取的clientId                  |
| deviceId | string    | deviceId | BLE 连接成功后通过readValueForCharacteristic (00001ffa-0000-1000-8000-00805f9b34fb) 获取的deviceId     |
| deviceCode | string    | deviceCode |                   |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| expires_in  | string  | 有效期               |      |
| created_at | string | 创建时间 |      |
| access_token | string | access token |      |
| refresh_token | string | 刷新access_token的token |      |
| token_type | string | token类型 |      |

### 46.获取用户详情信息（如：昵称，性别）

#### getUserInfo

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| nickname     | string  | 昵称               |      |
| gender     	 | int  |  性别              |  1:男 2:女 3:其他   |
| phone     | string  | 电话号码               |      |
| birthday     | string  | 生日日期               |      |
| avatar     | string  | 头像               |  url获取图片    |

### 47.判断是否已经登录

#### getToken

无参数

#### 返回值

| 参数  | 类型   | 说明 | 备注 |
| ----- | ------ | ---- | ---- |
| token | string |      |      |

### 48.查看专辑

#### getAlbum

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| albumId     | string | 专辑ID   |                    |
| deviceId    | string | 设备ID   |                    |
| sourceType  | string | 信源类型 | 如：kugou/migu     |
| business    | string | 业务类型 | 如：music          |
| limit    | int | 每页数量 |         |
| page    | int | 页码 |         |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值

| 参数     | 类型   | 说明     | 备注             |
| -------- | ------ | -------- | ---------------- |
| total | int | 总数量    |                  |
| page | int | 页数     |                  |
| name | string | 专辑名     |                  |
| liked | Bool | 是否已收藏     |                  |
| image | string | 专辑图片url     |                  |
| from_type | string | 来源     |                  |
| can_like | Bool | 是否能收藏     |                  |
| artist | string | 歌手名     |                  |
| business | string | 业务类型     |                  |
| tag_id | int | 标签ID    |                  |
| items | Array | 专辑歌单列表    |                  |

### 49.收藏接口（new,支持专辑）

#### likeMedia

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| albumId     | string | 专辑ID   |                    |
| likeType    | string | 收藏类型   | （single:单曲 ， album:专辑       |
| sourceType  | string | 信源类型 | 如：kugou/migu     |
| business    | string | 业务类型 | 如：music          |
| mediaId    | string | 单曲id |         |
| tagId    | int | 标签ID   |         |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |

### 50.取消收藏接口（new,支持专辑）

#### unLikeMediaWithLikeType

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| likeType    | string | 收藏类型   | single:单曲 ， album:专辑       |
| mediaId    | Array | 单曲id数组 |         |
| tagId    | int | 标签ID   |         |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |

### 51.获取收藏标签列表

#### unLikeMediaWithLikeType

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| tags     |  Array |  标签列表              |      |
| tags.id | string | 标签id |      |
| tags.name | string | 标签名 |      |

### 52.我的收藏列表

#### getCollectionList

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备id |         |
| tagId    | int | 标签ID   |         |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| single     |   |  单曲列表              |      |
| single.total | int | 数量 |      |
| single.name | string | 单曲 |      |
| single.collections | Array | 单曲收藏列表 |      |
| album     |   |  专辑列表              |      |
| album.total | int | 数量 |      |
| album.name | string | 专辑 |      |
| album.collections | Array | 专辑收藏列表 |      |

### 53.播放列表

#### getPlayList

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备id |         |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| total | int | 数量 |      |
| playlist | Array | 播放列表 |      |
| playlist.tag_id | int | 标签id |      |
| playlist.source_type     | string  |  信源类型              |      |
| playlist.name | string | 歌名 |      |
| playlist.id | string | 歌id |      |
| playlist.business | string | 业务类型 |      |
| playlist.error_reason | string | 错误原因 |      |
| playlist.available | bool | 判断是否能播放 |      |
| playlist.artist | string | 歌手名 |      |
| playlist.album_id | string | 业务类型 |      |

### 54.专辑播放

#### playAlbum

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备id  |       |
| albumId    | string | 专辑id |         |
| mediaId    | string | 歌曲id |         |
| sourceType    | string | 信源类型 |         |
| bussiness    | string | 业务类型   |         |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |


### 55.专辑播放

#### playCollections

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备id  |       |
| tagId    | int | 标签id |         |
| mediaId    | string | 歌曲id |         |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |

### 56.播放正在播放列表

#### playNow

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| deviceId    | string | 设备id  |       |
| mediaId    | string | 歌曲id |         |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 信息状态码               |      |
| message | string | 服务端返回的信息 |      |

### 57.注销账号

#### revokeAccount

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| delegate    | IFLYOSsdkLoginDelegate | 代理  |       |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| onUserRevokeSuccess     | void  | 注销成功               |      |
| onUserRevokeFail | int , error | 注销失败 |   type:失败类型<br> error:失败原因    |

### 58.查询信源列表

#### getAccountsType

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| accounts     | Array  | 信源列表               |      |
| accounts.bind_type | string | 信源类型 | xmly/kugou/liusheng     |

### 59.根据信源类型进入登陆界面

#### openWebPage:type:

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| webViewTag  | String    | tag标签   |  |
| type  | String    | 信源类型   | xmly/kugou/liusheng |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

### 60.根据clientId获取authCode（AP配网用）

#### getAuthCode

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| clientId  | int    | 状态码   | http请求响应状态码 |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| interval     | Int  |                |      |
| expires_in | Int | 过期时间 |     |
| auth_code | Int | code |     |
| created_at | Int | 创建时间 |     |

### 60.检查authCode授权（AP配网用）

#### checkAuthCode

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| authCode  | authCode    | 状态码   | authCode |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  |                |  0000 ：成功    |
| message | string | 返回结果 |   					  |

#### Ap配网协议

##### 建立连接

客户端尝试对网关的 8080 端口建立 Socket 连接(例如，如果网关为 192.168.0.0，那么尝试对 192.168.0.0:8080 建立连接)。 Socket 连接成功后，向设备尝试通讯，发送带有 App 端当前时间戳(毫秒)的初始报文。以下是一个示例
1. {"timestamp": 1591083122301}
设备的 Socket 服务端在收到客户端发送的初始报文后，根据设备端需要，可以根据时间戳同步系统时间，而后应当回复报文，将设备的
client_id 报给客户端
2. {"client_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"}
客户端对此 client_id 进行判断，若不是期望配网的设备的 client_id ，那么可以断开与设备的连接并作出相应提示。 

##### 发送授权码

客户端在连接到热点之前需要根据 client_id 获取到一个用于授权的 auth_code ，在连接到热点并与设备建立 Socket 连接之后，与 ssid 和密码一同发送给设备。
{
"ssid": "iflytek",
"bssid": "a4:83:e7:22:08:d1",
"password": "iflytek123",
"auth_code": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
发送的数据需遵循以下规则:
1. ssid 字段必不为空;
2. bssid 字段非必传;
3. password 字段可能不存在，但若存在，则长度等于 5 (WEP) 或 8 到 63 (WPA2); 4. auth_code 字段必不为空。

##### 回复协议

若设备端收到正常数据则返回如下数据代表传输成功，而后关闭 AP 开始尝试连接 WiFi。 1. {"code": 1}
若收到不合法数据则回复相关错误
1. {"code": -1, "message": "PASSWORD_ILLEGAL"} code 和 message 对应关系
code:-1
message:PASSWORD_ILLEGAL(WiFi 密码不合法)

code:-2
message:INVALID_AUTH_CODE(传参中未包含 auth_code)

##### 关键代码实例
1.获取网关地址
```
/*
 *  这个目前也是只能得到路由器的IP
 */
+ (NSString *)getGatewayIP {
    NSString *ipString = nil;
    struct in_addr gatewayaddr;
    int r = getdefaultgateway(&(gatewayaddr.s_addr));
    if(r >= 0) {
        ipString = [NSString stringWithFormat: @"%s",inet_ntoa(gatewayaddr)];
        NSLog(@"default gateway : %@", ipString );
    } else {
        NSLog(@"getdefaultgateway() failed");
    }
    
    return ipString;
}
```

### 61.创建推送连接

#### createSocket：command：fromType：deviceId

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| token  | string    | 小飞在线客户端用户token |  |
| command  | string    | 推送ID | 默认为connect |
| fromType | string     | 订阅类型 | ALIAS(设备的状态更新)<br/>ACCOUNT(用户通知) |
| deviceId    | string     | 订阅推送的唯一标识 | 订阅类型为ALIAS时为设备的device_id(client_id.device_id形式)<br/>订阅类型为ACCOUNT时为用户uuid |

#### 操作接口
| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| open  | void    | 打开连接   |  |
| close  | void    | 关闭连接   |  |

### 62.获取标签

#### getRecordsTags

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| tags     | Array  |                |      |
| tags.id | int | 标签id |   					  |
| tags.name | string | 标签名 |   					  |

### 63.播放记录接口

#### getRecordsPlay

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| device_id | string     | 设备ID |                    |
| tag_id | Int     | 标签ID |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| total     | int  | 总数量               |      |
| result | array | 结果集 |   					  |

### 64.删除播放记录

#### deleteRecords

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| device_id | string     | 设备ID |                    |
| tag_id | Int     | 标签ID |       删除某个标签下的记录，即全选;若不传，则删除所有标签的记录             |
| ids | Array     | ID数组 |            要删除的记录 id，如[1,2,3]，全选删除时不传该字段        |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 结果code               |      |
| message | string | 结果信息 |   					  |

### 65.播放记录列表播放接口

#### playRecordsList

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| device_id | string     | 设备ID |                    |
| tag_id | Int     | 标签ID |       删除某个标签下的记录，即全选;若不传，则删除所有标签的记录             |
| source_type | string     | 信源 |          如：migu        |
| media_id | string     | 单曲ID |                |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| code     | string  | 结果code               |      |
| message | string | 结果信息 |   					  |

### 66.获取操作类型列表

#### getIFTTTExecType

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| execType | string     | 操作类型 |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
```
[
    {
        "value": "voice_reply",
        "text": "{reply}",
        "name": "语音回复"
    },
    {
        "value": "weather",
        "text": "{city}{date}的天气",
        "name": "播报天气"
    },
    {
        "value": "news",
        "text": "播报{newsType}新闻",
        "name": "播报新闻"
    },
    {
        "value": "music",
        "text": "播放{hobby}的歌",
        "name": "播放音乐"
    },
    {
        "value": "iot",
        "text": "{action_text}",
        "name": "智能家居控制"
    }
]
```

### 67.获取操作类型

#### getIFTTTExecTypeActionTypes

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| execType | string     | 操作类型 |                    |
| actionType | string     | 操作value |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
**响应说明**

1. 语音回复

```json
[
    {
        "type": "input",
        "name": "语音回复",
        "items": null,
        "column": "reply"
    },
    {
        "type": "select",
        "name": "回复设备",
        "items": [
            {
                "clientDeviceId": "-1",
                "alias": "当前唤醒设备",
                "status": "online"
            },
            {
                "clientDeviceId": "c0bdaffc-3b37-47e3-9d64-03fa620b4393.9c417cb54cd8",
                "alias": "魔飞-pro650",
                "status": "online"
            }
        ],
        "column": "devices"
    }
]
```

2. 闹钟响铃

```json
[
    {
        "type": "input",
        "name": "提示内容",
        "items": null,
        "column": "tips"
    },
    {
        "type": "select",
        "name": "响铃设备",
        "items": [
            {
                "clientDeviceId": "-1",
                "alias": "当前唤醒设备",
                "status": "online"
            },
            {
                "clientDeviceId": "c0bdaffc-3b37-47e3-9d64-03fa620b4393.9c417cb54cd8",
                "alias": "魔飞-pro650",
                "status": "online"
            }
        ],
        "column": "devices"
    }
]
```

3. 播报天气
```json
[
    {
        "type": "select",
        "name": "选择日期",
        "items": [
            {
                "value": "今天",
                "name": "今天"
            },
            {
                "value": "明天",
                "name": "明天"
            },
            {
                "value": "后天",
                "name": "后天"
            }
        ],
        "column": "date"
    },
    {
        "type": "select",
        "name": "选择城市",
        "items": null,
        "column": "city"
    },
    {
        "type": "select",
        "name": "播报设备",
        "items": [
            {
                "clientDeviceId": "-1",
                "alias": "当前唤醒设备",
                "status": "online"
            },
            {
                "clientDeviceId": "c0bdaffc-3b37-47e3-9d64-03fa620b4393.9c417cb54cd8",
                "alias": "魔飞-pro650",
                "status": "online"
            }
        ],
        "column": "devices"
    }
]
```

4. 播报新闻
```json
[
    {
        "type": "select",
        "name": "新闻类型",
        "items": [
            {
                "value": "热点",
                "name": "热点"
            },
            {
                "value": "社会",
                "name": "社会"
            },
            {
                "value": "国际",
                "name": "国际"
            },
            {
                "value": "国内",
                "name": "国内"
            },
            {
                "value": "体育",
                "name": "体育"
            },
            {
                "value": "娱乐",
                "name": "娱乐"
            },
            {
                "value": "财经",
                "name": "财经"
            },
            {
                "value": "科技",
                "name": "科技"
            },
            {
                "value": "军事",
                "name": "军事"
            },
            {
                "value": "生活",
                "name": "生活"
            },
            {
                "value": "教育",
                "name": "教育"
            },
            {
                "value": "汽车",
                "name": "汽车"
            },
            {
                "value": "人文",
                "name": "人文"
            },
            {
                "value": "旅游",
                "name": "旅游"
            }
        ],
        "column": "newsType"
    },
    {
        "type": "select",
        "name": "播报设备",
        "items": [
            {
                "clientDeviceId": "-1",
                "alias": "当前唤醒设备",
                "status": "online"
            },
            {
                "clientDeviceId": "c0bdaffc-3b37-47e3-9d64-03fa620b4393.9c417cb54cd8",
                "alias": "魔飞-pro650",
                "status": "online"
            }
        ],
        "column": "devices"
    }
]
```

5. 播放音乐
```json
[
    {
        "type": "select",
        "name": "音乐偏好",
        "items": [
            {
                "场景": [
                    "电子",
                    "古典",
                    "金属",
                    "爵士",
                    "蓝调",
                    "流行",
                    "朋克",
                    "说唱",
                    "乡村",
                    "摇滚",
                    "中国风",
                    "拉丁风",
                    "放克",
                    "R&B",
                    "巴洛克",
                    "民谣",
                    "古风",
                    "草原歌曲"
                ]
            },
            {
                "风格": [
                    "ktv",
                    "催眠",
                    "地铁",
                    "度假",
                    "工作",
                    "婚礼",
                    "家务烹饪",
                    "驾车",
                    "聚会",
                    "咖啡厅",
                    "旅行",
                    "沐浴",
                    "散步",
                    "校园",
                    "学习",
                    "夜店",
                    "运动",
                    "做家务",
                    "跳舞"
                ]
            },
            {
                "年代": [
                    "00后",
                    "10年代",
                    "50年代",
                    "60后",
                    "60年代",
                    "70后",
                    "70年代",
                    "80后",
                    "80年代",
                    "90后",
                    "90年代"
                ]
            },
            {
                "主题": [
                    "纯音乐",
                    "广告铃声",
                    "经典",
                    "舞曲",
                    "翻唱",
                    "胎教",
                    "抖音",
                    "红歌",
                    "热歌",
                    "儿歌",
                    "成名曲",
                    "对唱",
                    "神曲",
                    "背景音乐"
                ]
            }
        ],
        "column": "hobby"
    },
    {
        "type": "select",
        "name": "播放设备",
        "items": [
            {
                "clientDeviceId": "-1",
                "alias": "当前唤醒设备",
                "status": "online"
            },
            {
                "clientDeviceId": "c0bdaffc-3b37-47e3-9d64-03fa620b4393.9c417cb54cd8",
                "alias": "魔飞-pro650",
                "status": "online"
            }
        ],
        "column": "devices"
    }
]
```

| 参数名 | 类型   | 说明     |
| ------ | ------ | -------- |
| hobby  | string | 喜好风格 |
6. 智能家居控制
```json
[
    {
        "moreItem": true,
        "name": "选择设备",
        "column": "devices",
        "type": "select",
        "items": [
            {
                "iotId": 1,
                "deviceTypeId": 5,
                "zone": "默认房间",
                "id": 54,
                "deviceName": "三楼热水器",
                "brand": "Orvibo",
                "friendlyName": "三楼热水器"
            }
        ]
    }
]
```

| 参数名   | 类型    | 说明                                   |
| -------- | ------- | -------------------------------------- |
| moreItem | boolean | 是否需要扩展item请求（true则需要请求） |

```
[
    {
        "type": "input",
        "name": "语音回复",
        "items": null,
        "column": "reply"
    },
    {
        "type": "select",
        "name": "回复设备",
        "items": [
            {
                "clientDeviceId": "-1",
                "alias": "当前唤醒设备",
                "status": "online"
            },
            {
                "clientDeviceId": "c0bdaffc-3b37-47e3-9d64-03fa620b4393.9c417cb54cd8",
                "alias": "魔飞-pro650",
                "status": "online"
            }
        ],
        "column": "devices"
    }
]
```



### 68.获取操作类型

#### getIFTTTExecTypeActionTypes

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| execType | string     | 操作类型 |                    |
| actionType | string     | 操作value |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
```
[
    {
        "type": "input",
        "name": "语音回复",
        "items": null,
        "column": "reply"
    },
    {
        "type": "select",
        "name": "回复设备",
        "items": [
            {
                "clientDeviceId": "-1",
                "alias": "当前唤醒设备",
                "status": "online"
            },
            {
                "clientDeviceId": "c0bdaffc-3b37-47e3-9d64-03fa620b4393.9c417cb54cd8",
                "alias": "魔飞-pro650",
                "status": "online"
            }
        ],
        "column": "devices"
    }
]
```

### 69.查询moreItem数据

#### getIFTTTExecTypeMoreItem

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| execType | string     | 操作类型 |                    |
| actionType | string     | 操作value |                    |
| deviceId | string     |iot device id |  |
| body | dictionary     |请求body | 看下文格式 |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

**请求body**
```json
{
    "iotId": 1,
    "deviceTypeId": 5,
    "zone": "默认房间",
    "id": 54,
    "deviceName": "三楼热水器",
    "brand": "Orvibo",
    "friendlyName": "三楼热水器"
}
```

#### 返回值
```
[
    {
        "column": "action",
        "name": "选择操作",
        "type": "selectp",
        "items": [
            {
                "name": "取消模式(退出模式)",
                "text": "客厅空调取消{mode}",
                "id": 18,
                "items": {
                    "name": "模式",
                    "column": "mode",
                    "type": "select",
                    "items": [
                        {
                            "name": "常温",
                            "value": "normal"
                        },
                        {
                            "name": "自动模式",
                            "value": "auto"
                        },
                        {
                            "name": "标准模式",
                            "value": "standard"
                        }
                    ]
                }
            },
            {
                "name": "模式的切换",
                "text": "客厅空调的模式设置为{mode}",
                "id": 17,
                "items": {
                    "name": "模式",
                    "column": "mode",
                    "type": "select",
                    "items": [
                        {
                            "name": "常温",
                            "value": "normal"
                        },
                        {
                            "name": "自动模式",
                            "value": "auto"
                        },
                        {
                            "name": "标准模式",
                            "value": "standard"
                        }
                    ]
                }
            },
            {
                "name": "调小风速",
                "text": "客厅空调风速调小一点",
                "id": 16
            },
            {
                "name": "调大风速",
                "text": "客厅空调风速调大一点",
                "id": 15
            },
            {
                "name": "调低温度",
                "text": "客厅空调温度调低点",
                "id": 13
            },
            {
                "name": "调高温度",
                "text": "客厅空调温度调高点",
                "id": 12
            },
            {
                "name": "关闭",
                "text": "关闭客厅空调",
                "id": 2
            },
            {
                "name": "打开",
                "text": "打开客厅空调",
                "id": 1
            },
            {
                "name": "设置温度",
                "text": "客厅空调温度调到{temperature}度",
                "id": 11,
                "items": {
                    "name": "温度",
                    "column": "temperature",
                    "type": "select",
                    "items": [
                        {
                            "name": "16",
                            "value": 16
                        },
                        {
                            "name": "17",
                            "value": 17
                        },
                        {
                            "name": "18",
                            "value": 18
                        },
                        {
                            "name": "19",
                            "value": 19
                        }
                    ]
                }
            }
        ]
    }
]
```

### 70.查询训练计划

#### getIFTTTs

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
```
[
    {
        "token": "baf467fe-69a0-4e9f-8f93-2710335726e0",
        "operations": null,
        "execData": {
            "wakeUpWord": [
                "打开客厅里的空调",
                "我要听五月天的歌"
            ]
        }
    }
]
```

### 71.根据 plan_token获取训练计划详情

#### getIFTTTWithPlanToken

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| planToken | String     | 训练计划token |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
```
{
    "token": "baf467fe-69a0-4e9f-8f93-2710335726e0",
    "operations": [
        {
            "type": "weather",
            "text": "今天广东省广州市天气",
            "date": "今天",
            "clientDeviceId": "c0bdaffc-3b37-47e3-9d64-03fa620b4393.9c417cb54cd8",
            "city": "广东省|广州市",
            "alias": "魔飞-pro650"
        },
        {
            "type": "voice_reply",
            "reply": [
                "我也不知道啊",
                "不知道该说什么"
            ],
            "clientDeviceId": "c0bdaffc-3b37-47e3-9d64-03fa620b4393.9c417cb54cd8",
            "alias": "魔飞-pro650"
        },
        {
            "type": "news",
            "newsType": "热点",
            "clientDeviceId": "-1",
            "alias": "当前唤醒设备"
        },
        {
            "type": "music",
            "hobby": "场景|摇滚",
            "clientDeviceId": "-1",
            "alias": "当前唤醒设备"
        },
        {
            "zone": "客厅",
            "type": "iot",
            "iotId": 1,
            "id": 70,
            "friendlyName": "空调",
            "deviceTypeId": 3,
            "deviceName": "空调",
            "brand": "奥林巴斯",
            "action": {
                "value": "红色",
                "name": "设置颜色",
                "id": 4
            }
        }
    ],
    "execData": {
        "wakeUpWord": [
            "打开客厅里的空调",
            "我要听五月天的歌"
        ]
    }
}

```

### 72.删除训练计划

#### deleteIFTTTWithPlanTokens

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| planTokens | Array     | 训练计划token数组 |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
```
statusCode:200 ok
{}

```

### 73.检查唤醒语料是否合法

#### getIFTTTCheck

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| text | String     | 唤醒语料文本 |                    |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| message | string | 服务端返回的信息 |      |


### 74.添加训练计划

#### addIFTTT:execData:operations:token:

| 参数        | 类型   | 说明     | 备注               |
| ----------- | ------ | -------- | ------------------ |
| execType | string     | 操作类型 |                    |
| execData | string     | 数据字典 |                   |
| operations | string     | 操作步骤数组 |                   |
| token | string     | 训练计划唯一token |  token不为空时更新数据，token为空时添加数据                  |
| statusCode  | int    | 状态码   | http请求响应状态码 |
| successData | id     | 成功回调 |                    |
| failData    | id     | 失败回调 |                    |

**公共参数说明**

| 参数名    | 类型     | 说明         |
| --------- | -------- | ------------ |
| name      | string   | 操作类型名称 |
| type      | string   | 操作类型     |
| alias     | string   | 播报设备别名 |
| device_id | string   | 播报设备ID   |

**特定参数说明**

1. 语音回复

```json
{
  "name": "语音回复",
  "type": "voice_reply",
  "reply": [
    "我也不知道啊",
    "不知道该说什么"
  ],
  "alias": "当前唤醒设备",
  "device_id": "-1"
}
```

| 参数名    | 类型     | 说明         |
| --------- | -------- | ------------ |
| reply     | string[] | 语音回复语料 |

2. 闹钟响铃

```json
{
  "name": "闹钟响铃",
  "type": "alarm",
  "tips": "就是想提醒而已",
  "alias": "魔飞-pro650",
  "device_id": "c0bdaffc-3b37-47e3-9d64-03fa620b4393.9c417cb54cd8"
}
```

| 参数名 | 类型   | 说明         |
| ------ | ------ | ------------ |
| tips   | string | 语音提示内容 |

3. 播报天气
```json
{
  "name": "播报天气",
  "type": "weather",
  "date": "今天",
  "city": "广东省|广州市",
  "text": "广东省广州市今天的天气",
  "alias": "当前唤醒设备",
  "clientDeviceId": "-1"
}
```

| 参数名 | 类型   | 说明                           |
| ------ | ------ | ------------------------------ |
| date   | string | 日期：<br>今天<br>明天<br>后天 |
| city   | string | 城市                           |
| text   | string | 显示文案                       |
4. 播报新闻
```json
 {
   "name": "播报新闻",
   "type": "news",
   "newsType": "热点",
   "text": "播报热点新闻",
   "alias": "当前唤醒设备",
   "clientDeviceId": "-1"
 }
```

| 参数名   | 类型   | 说明     |
| -------- | ------ | -------- |
| newsType | string | 新闻类型 |
| text     | string | 显示文案 |
5. 播放音乐
```json
{
  "name": "播放音乐",
  "type": "music",
  "hobby": "场景|摇滚",
  "text": "播放摇滚的歌",
  "alias": "当前唤醒设备",
  "clientDeviceId": "-1"
}
```

| 参数名 | 类型   | 说明     |
| ------ | ------ | -------- |
| hobby  | string | 喜好风格 |
| text   | string | 显示文案 |
6. 智能家居控制
```json
{
  "iotId": 1,
  "deviceTypeId": 3,
  "zone": "客厅",
  "name": "智能家居控制",
  "text": "客厅空调的模式设置为常温",
  "action": {
    "id": 17,
    "mode": {
      "name": "常温",
      "value": "normal"
    },
    "column": "模式",
    "name": "模式的切换",
    "text": "客厅空调的模式设置为{mode}"
  },
  "id": 70,
  "type": "iot",
  "brand": "奥林巴斯",
  "deviceName": "空调",
  "friendlyName": "空调"
}
```

| 参数名       | 类型   | 说明               |
| ------------ | ------ | ------------------ |
| friendlyName | string | 被控设备自定义名称 |
| deviceName   | string | 被控设备名称       |
| brand        | string | 被控设备品牌       |
| action       | object | 被控设备操作       |
| text         | string | 显示文案           |

```
{
    "execType": "voice",
    "execData": {
        "wakeUpWord": [
            "打开客厅里的空调",
            "我要听五月天的歌"
        ]
    },
    "operations": [
        {
            "name": "语音回复",
            "alias": "当前唤醒设备",
            "clientDeviceId": "-1",
            "type": "voice_reply",
            "reply": [
                "我也不知道啊",
                "不知道该说什么"
            ]
        },
        {
            "name": "闹钟响铃",
            "alias": "魔飞-pro650",
            "clientDeviceId": "c0bdaffc-3b37-47e3-9d64-03fa620b4393.9c417cb54cd8",
            "type": "alarm",
            "tips": "就是想提醒而已"
        },
        {
            "date": "今天",
            "city": "广东省|广州市",
            "name": "播报天气",
            "alias": "当前唤醒设备",
            "clientDeviceId": "-1",
            "text": "广东省广州市今天的天气",
            "type": "weather"
        },
        {
            "name": "播报新闻",
            "alias": "当前唤醒设备",
            "clientDeviceId": "-1",
            "text": "播报热点新闻",
            "type": "news",
            "newsType": "热点"
        },
        {
            "name": "播放音乐",
            "alias": "当前唤醒设备",
            "clientDeviceId": "-1",
            "text": "播放摇滚的歌",
            "type": "music",
            "hobby": "场景|摇滚"
        },
        {
            "iotId": 1,
            "deviceTypeId": 3,
            "zone": "客厅",
            "name": "智能家居控制",
            "text": "客厅空调的模式设置为常温",
            "action": {
                "id": 17,
                "mode": {
                    "name": "常温",
                    "value": "normal"
                },
                "column": "模式",
                "name": "模式的切换",
                "text": "客厅空调的模式设置为{mode}"
            },
            "id": 70,
            "type": "iot",
            "brand": "奥林巴斯",
            "deviceName": "空调",
            "friendlyName": "空调"
        }
    ]
}

```

#### 返回值
| 参数         | 类型  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| message | string | 服务端返回的信息 |      |
| token | string | 训练计划唯一token |      |


## 协议

### IFLYOSsdkDelegate

| 函数名         | 参数  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| openNewPage | tag | 新页面打开 | tag : 标识符 |
| closePage | void | 关闭页面 |  |
| updateHeaderColor: | color | 网页加载完成回调颜色 | navigtionBar颜色 :  如：<meta name="head-color">#FFFFFF</meta> |
| updateTitle: | title | 网页加载完成回调标题 | title : 标题 |
| openNewBrower: | url | 浏览器打开URL |  |

### IFLYOSsdkLoginDelegate

| 函数名         | 参数  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| openNewPage:noBack | tag:标识符<br>noBack:是否支持手势返回 | 新页面打开 | tag : 标识符 noBack:是否支持手势返回 |
| onLoginSuccess | void | 登录成功 |  |
| onLoginFailed:error: | type:失败类型<br> error:失败原因 | 登录失败 |  |
| onLogoutSuccess: | void | 注销成功 |  |
| onLogoutFailed:error: |  type:失败类型<br> error:失败原因 | 注销失败 |  |
| onUserRevokeSuccess     | void  | 注销成功               |      |
| onUserRevokeFail | int , error | 注销失败 |   type:失败类型<br> error:失败原因    |

### IFLYOSsdkAuthDelegate

| 函数名         | 参数  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| onAuthSuccess | void | 授权成功 |  |
| onAuthFailed | void | 授权失败 |  |

### IFLYOSPushServiceProtocol

| 函数名         | 参数  | 说明               | 备注 |
| ------------ | ----- | ------------------ | ---- |
| onSockectOpenSuccess | void | 连接成功 |  |
| onSockect:error: | void | 连接失败，error:失败原因 |  |
| onSockect:didCloseWithCode:wasClean: | void | socket 主动关闭连接回调（关闭成功后，清理socket相关东西） | code:关闭代码,reason:关闭原因,wasClean:是否清除 |
| onSockect:receiveMessage: | void | 接收信息，receiveMessage : 回调信息 |  |

<IflyHeader />
