# 虎牙监控 iOS

一个面向个人使用的 iPhone 虎牙直播监控 App。目标是关注主播、查看弹幕、收听直播声音，并在主播开播时收到 iPhone 通知。

## 你只有 Windows 电脑？可以这样安装

本项目已经配置 GitHub 云端 macOS/Xcode 构建，不要求你购买或拥有 Mac。

1. 打开仓库顶部 **Actions**。
2. 选择 **Build iPhone IPA for Windows**，打开最新的成功运行记录。
3. 在页面底部 **Artifacts** 下载 `huya-monitor-unsigned-ipa`。
4. 解压后获得 `HuyaMonitor-unsigned.ipa`。
5. 按照 [Windows 中文安装说明](docs/WINDOWS_INSTALL_GUIDE.md)，使用 Windows 侧载工具签名并安装到自己的 iPhone。

**注意：IPA 是未签名包，不能直接安装。** 必须用自己的 Apple Account 重新签名。免费账号侧载通常只有 7 天有效期，具体说明见安装指南。当前最低支持 iOS 17。

## 当前已完成

- SwiftUI iOS 原生工程，包含监控、关注主播、设置三个页面。
- 添加虎牙房间号或直播间链接。
- 关注列表保存在 iPhone 本地，重启 App 后仍然保留。
- 每位主播可单独设置开播提醒偏好。
- iOS 本机通知权限申请和 5 秒后测试通知。
- GitHub Actions 在云端 macOS 上检查模拟器编译，并生成 iPhone arm64 未签名 IPA。

## 尚未完成（需要后续数据接入）

- 虎牙真实主播开播/在线状态检测。
- 虎牙实时弹幕 WebSocket 接入。
- 直播音频流和后台播放。
- 云端监控服务、设备令牌注册和 APNs 远程开播推送。

本机测试通知不等于主播开播远程推送。正式远程提醒需要 APNs 能力、服务端凭据、设备 token，以及可持续使用且获准使用的虎牙开播状态来源。

## 重要说明

虎牙公开的旧弹幕 API 文档明确标注“本文档不再更新”，并指向虎牙小程序文档。它展示了历史 WebSocket 消息格式，但不能据此保证独立 iOS 客户端目前仍可稳定使用。正式接入前需要确认可用且获准使用的数据来源。项目不会把未经确认的私有接口或账号凭据写进客户端。

## 项目结构

- `HuyaMonitor/`：SwiftUI iOS 应用。
- `HuyaMonitor.xcodeproj/`：Xcode 工程。
- `docs/TECHNICAL_PLAN.md`：后续接入架构和前置条件。
- `docs/WINDOWS_INSTALL_GUIDE.md`：Windows 用户安装步骤。
- `docs/WINDOWS_AND_PUSH_LIMITATIONS.md`：Windows 构建和 APNs 推送限制。
- `.github/workflows/ios-build.yml`：模拟器编译检查。
- `.github/workflows/ios-ipa.yml`：iPhone arm64 IPA 云端打包。

## 隐私与密钥

不要把 Apple APNs 私钥、虎牙应用密钥、密码、Cookie 或个人访问令牌提交到 GitHub。正式后端配置应使用部署平台的 Secrets。
