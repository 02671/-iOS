# 技术实施计划

## 目标

这是个人使用工具，优先考虑简单、稳定、低维护成本。客户端使用 SwiftUI；云端只承担必须持续运行的主播状态检测和 APNs 推送。

## 当前第一阶段

- SwiftUI 三个页面：监控、关注主播、设置。
- 关注主播资料保存在本机 UserDefaults。
- 通知权限申请和本机本地通知测试。
- 未接入的数据源明确标为未接入。

## Windows-only 使用方式（不需要本地 Mac）

- GitHub Actions 的 `.github/workflows/ios-ipa.yml` 在云端 macOS/Xcode 环境生成 iPhone arm64 未签名 IPA。
- 用户从 Actions 的 Artifacts 下载 IPA，再在 Windows 上通过侧载工具使用自己的 Apple Account 签名安装。
- 此方式解决“没有 Mac 怎么构建和初次安装”的问题，但免费签名会过期，且远程 APNs 仍需 Push Notifications capability 与服务端 APNs 凭据。
- 不要将 Apple Account 密码、APNs 私钥、虎牙 Cookie 或令牌放进仓库。

## 第二阶段：确认虎牙数据接入

虎牙旧公开弹幕 API 页面：
https://open.huya.com/index.php?m=Open&wiki=barrage

该页面明确说明文档不再更新（页面文档更新时间为 2019-03-01），并提示查看虎牙小程序文档。它记录了历史 WebSocket 的弹幕事件格式，但不足以证明它是当前对独立 iOS App 开放、稳定且获准使用的接口。

接入前必须确认：
1. 是否有适合个人用途的官方/获准接口。
2. 是否能查询房间的直播状态，或是否有可订阅的开播事件。
3. 是否能获取适用于独立客户端的弹幕流。
4. 是否允许独立客户端获取直播音频流，以及是否有可用播放地址。

不将未经确认的私有接口、逆向协议、账号 Cookie 或绕过访问控制的方法作为正式实现。不要将个人凭据写入 App 或 Git 仓库。

## 第三阶段：云端开播监控与 APNs

预期链路：

1. iOS App 获得用户同意后注册 APNs，取得设备令牌。
2. App 将令牌与用户关注列表安全地登记到个人后端。
3. 后端以低频、合规的方式检查关注主播状态。
4. 仅在状态从“未开播”切换为“开播”时发送通知，并进行去重。
5. App 收到通知后打开对应房间。

远程推送不是单靠 iPhone 本地通知权限即可完成。还需要 Apple Developer 账号相关配置、Push Notifications capability、设备令牌和服务端 APNs 凭据。APNs 私钥只能放在服务端 Secret 中，不放到仓库。

## 第四阶段：弹幕和音频

- 弹幕：由获准的数据来源提供事件，再通过 WebSocket/HTTP 向客户端传输。
- 音频：在授权允许且取得可用播放地址后，使用 AVPlayer/AVAudioSession 实现前台播放；需要时再配置 iOS 后台音频能力。
- 连接断开、网络切换、重复事件和房间切换均需处理。

## 用户需要准备的条件

- 一台可运行近期 Xcode 的 Mac，用于直接安装和调试；或者后续配置可用的签名/分发方式。
- iPhone 和 Apple Account。
- 如果要用 APNs 远程推送，需要确认 Apple Developer 账号及 Push Notifications capability 是否可用。Apple 当前说明，个人设备可以通过 Xcode 测试 App，不一定需要付费会员；App Store 分发和部分能力则需要加入 Apple Developer Program。
- 如虎牙官方数据源要求开发者申请，需要按其实际要求办理；“个人使用”本身不代表可以绕过平台接口授权。

## 完成标准

- 能添加、删除多个主播，退出 App 后关注列表仍在。
- 可正确显示主播真实开播状态，不使用假数据。
- 对每次开播事件只发一次提醒，停止直播后可重新识别下一次开播。
- App 未打开时也能收到 APNs 通知。
- 能显示真实弹幕并按用户操作清屏。
- 能播放真实直播音频，并在允许的情况下支持锁屏后台播放。
