# Windows 安装到 iPhone（不需要 Mac）

本项目由 GitHub Actions 在云端 macOS/Xcode 环境构建。Windows 电脑只负责下载 IPA、使用侧载工具重新签名并安装。

## 重要：当前安装包是未签名 IPA

GitHub Actions 产出的 `HuyaMonitor-unsigned.ipa` 是 iPhone 真机架构的未签名安装包。它不能直接点开安装，必须先用你自己的 Apple Account 对它签名。项目不需要越狱。

## 第一步：下载 IPA

1. 打开仓库：https://github.com/02671/-iOS
2. 点击顶部的 **Actions**。
3. 在左侧选择 **Build iPhone IPA for Windows**。
4. 打开最新一次成功的运行记录（绿色勾）。
5. 在页面底部 **Artifacts** 区域下载 `huya-monitor-unsigned-ipa`。
6. 解压下载的 ZIP，得到 `HuyaMonitor-unsigned.ipa`。

如果 Actions 页面提示没有运行记录，先回到仓库首页，确认最新提交已进入 main 分支；代码变更会自动触发构建。也可以在 workflow 页面手动点击 Run workflow。

## 第二步：准备 Windows 和 iPhone

- Windows 10 或 Windows 11。
- iPhone、可传数据的 USB 线。
- iPhone 已解锁，首次连接电脑时在手机上点“信任此电脑”。
- Sideloadly 官方网站：https://sideloadly.io/ （点击 Windows 下载）。
- Sideloadly 官方说明 Windows 需要 Apple 的桌面版 iTunes 和 iCloud 组件；请按其官网说明安装，不要混用 Microsoft Store 版本：https://sideloadly.io/

Sideloadly 是第三方工具，不是 Apple 产品。安装前请自行确认官方网站和隐私政策。不要把 Apple Account 密码、验证码或设备解锁密码发给任何人，也不要写入 GitHub 仓库。

## 第三步：签名并安装

1. 在 Windows 打开 Sideloadly。
2. 用 USB 连接 iPhone，确认 Sideloadly 识别到了设备。
3. 把 `HuyaMonitor-unsigned.ipa` 拖入 IPA 栏。
4. 按 Sideloadly 的提示使用你自己的 Apple Account 完成签名验证。
5. 点击 Start，等待安装完成。
6. 如 iPhone 要求开启开发者模式，进入“设置 → 隐私与安全性 → 开发者模式”，开启并按提示重启。
7. 如系统出现开发者信任提示，按 iOS 当前界面在“设置 → 通用 → VPN 与设备管理”中完成信任。

## 免费 Apple Account 的期限

Sideloadly 官方 FAQ 说明：普通免费 Apple Developer 账号侧载的 App 通常只有 7 天有效期；到期后需再次用同一个 Apple Account 重新侧载。Sideloadly 的自动刷新功能仍要求电脑能通过 USB 或已配置的 Wi-Fi 连接到 iPhone。

官方说明：https://sideloadly.io/faq

免费账号也有可安装 App 数量限制。付费 Apple Developer Program 可延长签名期限，但目前不建议你为了测试第一版就先付费。

## 当前版本有哪些功能

已实现：监控页、关注主播页、添加房间号/直播间链接、本机关注列表保存、每个主播的提醒偏好、本机测试通知。

尚未实现：虎牙真实开播状态、真实弹幕流、直播声音、主播开播 APNs 远程推送。请不要把“本机测试通知”误认为真实主播开播提醒。

## 系统要求

当前工程最低支持 iOS 17。若 iPhone 系统低于 iOS 17，安装会失败，需要先升级 iOS 或调整项目最低版本并重新构建。

## 安装遇到问题时

请截图 Sideloadly 的完整报错和 iPhone 系统版本发给项目维护者。截图前遮挡 Apple Account 邮箱、验证码、设备序列号等个人信息。
