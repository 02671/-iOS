# Windows 开发与推送能力说明

## 为什么 Windows 电脑也能编译 iOS 项目

Swift/iOS 的 Xcode 构建过程仍然需要 Apple 的 macOS/Xcode 环境。本项目使用 GitHub Actions 提供的云端 macOS runner 执行 xcodebuild，用户自己的 Windows 电脑不需要安装 Xcode。

## 本项目的两段流程

1. GitHub Actions：用 iPhoneOS SDK 编译 arm64 App，并打包成未签名 IPA。
2. Windows + Sideloadly：使用用户自己的 Apple Account 对 IPA 进行签名并安装到 iPhone。

未签名 IPA 不可以直接在 iPhone 上安装。

## 远程开播通知不是本机通知

当前 App 内的测试通知是由 iPhone 本机定时触发的。它不需要服务器，也不依赖虎牙数据。

正式开播提醒需要：
- iOS App 注册到 APNs 并获得设备 token；
- App ID 启用 Apple Push Notifications capability，签名配置包含 aps-environment entitlement；
- 云端服务安全保存 APNs 凭据和设备 token；
- 云端取得可信的虎牙开播状态来源，检测状态变化并去重后向 APNs 发通知。

Apple 的 APNs 文档说明，需要启用 Push Notifications capability，并把设备 token 安全地转交给 provider server：
https://developer.apple.com/documentation/usernotifications/registering-your-app-with-apns

Apple 的 iOS capability 列表说明可用能力取决于开发者计划会员资格；Push Notifications 属于 Apple Developer Program 的能力范围：
https://developer.apple.com/help/account/reference/supported-capabilities-ios

因此，免费 Apple Account 的侧载方案适合先安装、体验当前基础界面；若要正式实现 APNs 远程推送，后续需要检查 Apple Developer Program 账号与推送能力配置。不要在未确认之前先购买会员。

## 隐私

此仓库当前是公开仓库。不得提交 Apple Account 密码、APNs Auth Key（.p8）、证书私钥、虎牙 Cookie、访问令牌或个人推送令牌。
