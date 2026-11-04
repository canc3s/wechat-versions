# 🚀 微信版本收集器 (WeChat Version Collector)

> **中文说明** | [**English**](./README_EN.md)

![GitHub Release](https://img.shields.io/github/v/release/canc3s/wechat-versions?style=flat-square&color=blue)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/canc3s/wechat-versions/destversion.yml?style=flat-square&label=构建状态)
![License](https://img.shields.io/github/license/canc3s/wechat-versions?style=flat-square)

**多平台微信安装包自动归档工具。**

本项目自动监控官方下载源，捕获最新发布的版本，并进行 SHA256 校验和归档。

---

## ✨ 功能特性

- **多平台支持**:
    - 🖥️ **Windows**: 监控 `pc.weixin.qq.com`
    - 🍎 **Mac**: 监控 `mac.weixin.qq.com`
    - 🤖 **Android**: 监控 `weixin.qq.com`
- **🔒 完整性校验**: 自动计算并记录 SHA256 哈希值，确保文件完整。
- **📝 自动日志**: 维护详细的 [RELEASE_LOG.md](./RELEASE_LOG.md) 发布历史。
- **⚙️ 自动化**: 基于 GitHub Actions 的全自动监控与发布流程。

---

## 📅 发布历史

> **[查看完整发布日志](./RELEASE_LOG.md)**

所有收集到的版本信息均记录在 **[RELEASE_LOG.md](./RELEASE_LOG.md)** 文件中，按平台分类管理。

---

## 🛠️ 使用说明

### 手动运行

你可以手动触发监控脚本进行测试或临时更新：

```bash
# 检查所有平台
./scripts/monitor.sh all

# 检查特定平台
./scripts/monitor.sh win
./scripts/monitor.sh mac
./scripts/monitor.sh android

# 使用自定义下载链接测试 (特定平台)
./scripts/monitor.sh win "https://example.com/WeChat.exe"
```

---

## 📂 项目结构

```
.
├── RELEASE_LOG.md          # 📜 所有发布版本的历史记录
├── README.md               # 🇨🇳 中文说明文档
├── README_EN.md            # 🇺🇸 英文说明文档
├── scripts/
│   ├── monitor.sh          # 🧠 主逻辑入口
│   ├── common.sh           # 🔧 公共函数 (爬虫, Git, 发布)
└── .github/workflows/
    └── destversion.yml     # 🤖 CI/CD 配置
```

---

## 🔗 友链

- [capcut-versions](https://github.com/canc3s/capcut-versions) — 剪映 / CapCut 多平台离线完整安装包归档

---

## 📄 许可证

本项目基于 MIT License 开源。
