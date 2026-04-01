# Feishu Sender - 飞书消息发送

飞书消息自动发送工具，基于 AppleScript 实现，支持中文消息。

---

## ✅ 功能特性

- 自动打开飞书应用
- 搜索指定群聊/联系人
- 发送中文消息（无乱码）
- 支持 emoji 和特殊字符

---

## 🔑 核心方案：剪贴板粘贴

### 问题背景

AppleScript 的 `keystroke` 直接输入中文会失败：

```applescript
-- ❌ 失败：中文被吃掉或乱码
keystroke "三多需求团"
```

**根本原因：** AppleScript 的 `keystroke` 命令只支持 ASCII 字符。

### 解决方案

通过剪贴板中转，绕过字符编码限制：

```applescript
-- ✅ 成功：先写入剪贴板，再 Cmd+V 粘贴
set the clipboard to "三多需求团"
keystroke "v" using command down
```

**原理：**
- 剪贴板支持任意 Unicode 字符（中文、emoji 等）
- Cmd+V 是 macOS 原生功能，不受 AppleScript 限制
- 模拟真人操作，应用无法识别为自动化

---

## 🚀 使用方法

### 方式 1：直接运行脚本

```bash
osascript feishu-sender/applescript/send_message.scpt
```

### 方式 2：通过 OpenClaw 调用

```bash
openclaw skills run feishu-sender --group "群聊名称" --message "消息内容"
```

---

## 📋 完整流程

```applescript
-- 飞书消息发送完整 AppleScript
tell application "System Events"
    -- 1. 打开飞书
    do shell script "open -a Lark"
    delay 0.5
    
    -- 2. 激活搜索 (Cmd+K)
    keystroke "k" using command down
    delay 0.3
    
    -- 3. 输入群名（剪贴板方案）
    set the clipboard to "三多需求团"
    keystroke "v" using command down
    delay 0.3
    keystroke return
    delay 0.5
    
    -- 4. 输入消息内容（剪贴板方案）
    set the clipboard to "你好，这是测试消息"
    keystroke "v" using command down
    delay 0.2
    
    -- 5. 发送
    keystroke return
end tell
```

---

## ⚙️ 自定义配置

编辑 `send_message.scpt` 修改以下变量：

```applescript
-- 群聊名称
set groupName to "你的群聊名称"

-- 消息内容
set messageContent to "你要发送的消息"
```

---

## 🔧 故障排除

### 中文显示乱码

**原因**：直接使用了 `keystroke` 输入中文  
**解决**：使用剪贴板 + Cmd+V 方案

### 找不到群聊

**原因**：群聊名称不匹配或搜索延迟不足  
**解决**：
- 确认群聊名称准确
- 增加 `delay` 时间

### 消息未发送

**原因**：焦点不在输入框  
**解决**：确保进入群聊后等待足够时间再发送

---

## 📄 文件说明

```
feishu-sender/
├── README.md                      # 本文件
└── applescript/
    └── send_message.scpt          # 主发送脚本
```

---

## 📝 更新日志

### 2026-04-01
- ✅ 初始版本，验证成功
- ✅ 支持中文消息发送
- ✅ 支持指定群聊

---

**作者**：黄小豪  
**维护**：LITTA 团队
