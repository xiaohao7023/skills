# Shortcut Runner

一个用于 macOS 的 OpenClaw Skill，通过 AppleScript 模拟键盘快捷键操作。

## 功能特性

- ✅ 执行预设快捷键（复制、粘贴、截图等）
- ✅ 自定义快捷键组合
- ✅ 支持延时和重复执行
- ✅ 可指定目标应用程序
- ✅ 纯 AppleScript 实现，无需额外依赖

## 前置要求

### macOS 辅助功能授权（必需）

此 Skill 需要 **Accessibility** 权限才能模拟键盘输入。

**授权步骤：**

1. 打开 **系统设置 → 隐私与安全性 → 辅助功能**
2. 点击左下角的 **+** 按钮
3. 按 `Cmd + Shift + G`，输入路径：
   ```
   /Applications/OneClaw.app/Contents/MacOS/
   ```
4. 选择 **openclaw-gateway** 并添加
5. 确保勾选框为 **选中状态**

**验证授权：**
```bash
osascript scripts/check-perms.scpt
```

## 安装

### 方式 1：通过 OpenClaw 安装

```bash
# 克隆到 OpenClaw skills 目录
git clone https://github.com/xiaohao7023/skills.git ~/.openclaw/skills/shortcut-runner
```

### 方式 2：手动安装

1. 下载本仓库
2. 复制 `shortcut-runner` 文件夹到 `~/.openclaw/skills/`
3. 添加执行权限：
   ```bash
   chmod +x ~/.openclaw/skills/shortcut-runner/scripts/*.scpt
   ```

## 使用方法

### 执行预设快捷键

预设快捷键定义在 `config.json` 中：

```bash
# 复制
openclaw skills run shortcut-runner --name "copy"

# 粘贴
openclaw skills run shortcut-runner --name "paste"

# 截图
openclaw skills run shortcut-runner --name "screenshot"
```

### 直接指定按键

```bash
# 打开 Spotlight (Cmd+Space)
openclaw skills run shortcut-runner --keys "cmd,space"

# 新建窗口 (Cmd+N)
openclaw skills run shortcut-runner --keys "cmd,n"

# 复杂组合 (Cmd+Shift+4)
openclaw skills run shortcut-runner --keys "cmd,shift,4"
```

### 高级用法

```bash
# 重复执行 5 次，间隔 200ms
openclaw skills run shortcut-runner --keys "cmd,v" --repeat 5 --delay 200

# 指定目标应用
openclaw skills run shortcut-runner --keys "cmd,t" --target "Safari"
```

## 支持的按键

| 按键 | 别名 |
|------|------|
| cmd | command, ⌘ |
| ctrl | control, ⌃ |
| opt | option, alt, ⌥ |
| shift | ⇧ |
| return | enter |
| space | - |
| tab | - |
| esc | escape |
| delete | backspace |
| a-z, 0-9 | 直接输入 |
| f1-f20 | 功能键 |
| up/down/left/right | 方向键 |

## 配置预设快捷键

编辑 `config.json` 添加自定义快捷键：

```json
{
  "shortcuts": {
    "my-custom": {
      "keys": ["ctrl", "alt", "k"],
      "description": "我的自定义快捷键"
    }
  }
}
```

## 完整示例

```bash
# 1. 打开 Spotlight 并启动 Safari
openclaw skills run shortcut-runner --keys "cmd,space"
sleep 0.5
osascript -e 'tell application "System Events" to keystroke "safari"'
sleep 0.5
osascript -e 'tell application "System Events" to keystroke return'

# 2. 等待 Safari 启动
sleep 2

# 3. 新建窗口
openclaw skills run shortcut-runner --keys "cmd,n"

# 4. 输入网址
osascript -e 'tell application "System Events" to keystroke "baidu.com"'
openclaw skills run shortcut-runner --keys "return"
```

## 文件结构

```
shortcut-runner/
├── SKILL.md              # Skill 说明文档
├── config.json           # 快捷键预设配置
├── README.md             # 本文件
├── TESTING.md            # 测试指南
├── TEST_REPORT.md        # 测试报告
└── scripts/
    ├── run-shortcut.scpt      # 主执行脚本
    ├── check-perms.scpt       # 权限检查脚本
    └── test-simple.scpt       # 简单测试脚本
```

## 故障排除

### "osascript 不允许发送按键"

**原因**：Accessibility 权限未授予  
**解决**：按【前置要求】章节完成授权

### 快捷键无反应

**原因**：目标应用未获得焦点  
**解决**：
- 使用 `--target` 参数指定应用
- 或先手动点击目标应用窗口

### 按键顺序错误

**原因**：执行速度过快  
**解决**：添加 `--delay` 参数增加延时

## 注意事项

1. **安全性**：此 Skill 可以模拟键盘输入，请确保来源可信
2. **权限**：macOS 会记住授权状态，只需设置一次
3. **兼容性**：仅支持 macOS 系统
4. **稳定性**：部分应用可能有自定义快捷键行为

## 贡献

欢迎提交 Issue 和 PR！

## 许可证

MIT

---

**作者**：黄小豪  
**维护**：LITTA 团队
