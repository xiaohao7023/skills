# Shortcut Runner - Manual Test Guide

## 权限设置（必须）

由于 OpenClaw 通过 `openclaw-gateway` 运行脚本，需要给它授权：

### 步骤 1: 打开系统设置
```
System Settings → Privacy & Security → Accessibility
```

### 步骤 2: 添加 openclaw-gateway
1. 点击左下角 **+** 按钮
2. 按 `Cmd+Shift+G`
3. 输入路径：`/Applications/OneClaw.app/Contents/MacOS/`
4. 选择 `openclaw-gateway`
5. 确保勾选框已选中

### 步骤 3: 验证权限
运行测试命令：
```bash
osascript ~/.openclaw/skills/shortcut-runner/scripts/test-simple.scpt
```

如果看到 "SUCCESS"，说明权限已生效。

---

## 功能测试清单

### 测试 1: 简单快捷键（打开 Spotlight）
```bash
osascript ~/.openclaw/skills/shortcut-runner/scripts/test-simple.scpt
```
预期结果：Spotlight 搜索框出现

### 测试 2: 复制快捷键
```bash
osascript ~/.openclaw/skills/shortcut-runner/scripts/run-shortcut.scpt "cmd,c" 0
```
预期结果：当前选中内容被复制到剪贴板

### 测试 3: 截图快捷键
```bash
osascript ~/.openclaw/skills/shortcut-runner/scripts/run-shortcut.scpt "cmd,shift,4" 0
```
预期结果：鼠标变成十字线，进入截图选择模式

### 测试 4: 带延时的重复执行
```bash
osascript ~/.openclaw/skills/shortcut-runner/scripts/run-shortcut.scpt "cmd,v" 200
```
预期结果：粘贴操作执行，然后等待 200ms

---

## 故障排除

### 错误："osascript 不允许发送按键"
**原因**：Accessibility 权限未授予
**解决**：按上述步骤授权

### 错误："Could not activate [AppName]"
**原因**：目标应用未运行或名称错误
**解决**：确保应用已运行，或使用正确应用名称

### 快捷键无反应
**原因**：目标应用未获得焦点
**解决**：先手动点击目标应用窗口，或使用 `--target` 参数
