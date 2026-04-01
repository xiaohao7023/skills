# Skills - macOS 自动化工具集

个人效率工具集合，基于 OpenClaw 和 AppleScript 构建，支持飞书/企业微信消息自动发送。

---

## 📁 目录结构

```
skills/
├── README.md                 # 本文件
├── config.json               # 快捷键预设配置
├── scripts/                  # 通用脚本
│   ├── run-shortcut.scpt
│   ├── check-perms.scpt
│   └── test-simple.scpt
├── feishu-sender/           # 飞书消息发送 [已验证]
│   ├── README.md
│   └── applescript/
│       └── send_message.scpt
└── wecom-sender/            # 企业微信消息发送 [开发中]
    └── ...
```

---

## 🚀 功能模块

### 1. Shortcut Runner - 通用快捷键

通过配置化方式管理自定义快捷键，执行 AppleScript 或其他脚本。

**功能特性：**
- ✅ 执行预设快捷键（复制、粘贴、截图等）
- ✅ 自定义快捷键组合
- ✅ 支持延时和重复执行
- ✅ 可指定目标应用程序
- ✅ 纯 AppleScript 实现，无需额外依赖

**快速开始：**
```bash
# 执行预设快捷键
openclaw skills run shortcut-runner --name "copy"
openclaw skills run shortcut-runner --name "paste"

# 直接指定按键
openclaw skills run shortcut-runner --keys "cmd,space"

# 指定目标应用
openclaw skills run shortcut-runner --keys "cmd,t" --target "Safari"
```

**详细文档：** [SKILL.md](./SKILL.md)

---

### 2. Feishu Sender - 飞书消息发送 [已验证 ✅]

**核心突破：** 使用剪贴板粘贴解决 AppleScript 中文输入乱码问题

**技术要点：**
- AppleScript 的 `keystroke` 直接输入只支持 ASCII 字符
- 中文需通过剪贴板 + Cmd+V 粘贴实现
- 流程：剪贴板写入 → Cmd+V 粘贴 → 回车发送

**使用方法：**
```bash
# 运行飞书发送脚本
osascript feishu-sender/applescript/send_message.scpt
```

**详细文档：** [feishu-sender/README.md](./feishu-sender/README.md)

---

### 3. WeCom Sender - 企业微信消息发送 [开发中 🚧]

**状态：** 技术验证已完成，正在开发中

**技术路径：**
- 采用 Automator Workflow 激活企微搜索
- 后续流程同飞书方案（剪贴板粘贴）

**验证结果：** ✅ 全局快捷键唤起 + 消息发送成功

---

## 💡 关键技术认知

### AppleScript 中文处理

| 方式 | 支持中文 | 说明 |
|------|---------|------|
| `keystroke "中文"` | ❌ | 只支持 ASCII，中文会乱码 |
| 剪贴板 + Cmd+V | ✅ | 通用方案，支持任意字符 |

### 窗口激活最佳实践

- 单纯 `activate` 可能无法真正前置窗口
- 需配合 `tell process "应用名"` + `set frontmost to true`
- 在 Automator 中运行时，需明确指定目标进程避免快捷键被拦截

---

## 📋 前置要求

### macOS 辅助功能授权（必需）

所有 Skill 都需要 **Accessibility** 权限才能模拟键盘输入。

**快速授权：**
```bash
osascript -e 'tell application "System Events" to keystroke space using command down'
```

然后系统设置 → 隐私与安全性 → 辅助功能 → 勾选 OneClaw

**验证授权：**
```bash
osascript scripts/check-perms.scpt
```

---

## 🔧 安装

```bash
# 克隆到 OpenClaw skills 目录
git clone https://github.com/xiaohao7023/skills.git ~/.openclaw/skills/shortcut-runner

# 添加执行权限
chmod +x ~/.openclaw/skills/shortcut-runner/scripts/*.scpt
```

---

## 📝 更新日志

### 2026-04-01
- ✅ 飞书消息发送验证成功（剪贴板方案）
- ✅ 企业微信全局快捷键验证成功（Automator 方案）
- 🚧 企业微信消息发送开发中

---

## 🤝 贡献

欢迎提交 Issue 和 PR！

---

## 📄 许可证

MIT

---

**作者**：黄小豪  
**维护**：LITTA 团队
