# 🚀 WeChat Version Collector

> [**中文说明**](./README.md) | **English**

![GitHub Release](https://img.shields.io/github/v/release/canc3s/wechat-versions?style=flat-square&color=blue)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/canc3s/wechat-versions/destversion.yml?style=flat-square&label=Build)
![License](https://img.shields.io/github/license/canc3s/wechat-versions?style=flat-square)

**Automated archiver for WeChat installation packages across multiple platforms.**

This project monitors official WeChat download sources, captures new versions as they are released, and archives them with SHA256 verification.

---

## ✨ Features

- **Multi-Platform Support**:
    - 🖥️ **Windows**: Monitors `pc.weixin.qq.com`
    - 🍎 **Mac**: Monitors `mac.weixin.qq.com`
    - 🤖 **Android**: Monitors `weixin.qq.com`
- **🔒 Integrity Check**: Automatically calculates and records SHA256 hashes to ensure file integrity.
- **📝 Automatic Logging**: Maintains a detailed [RELEASE_LOG.md](./RELEASE_LOG.md) history.
- **⚙️ GitHub Actions**: Fully automated monitoring and releasing workflow.

---

## 📅 Release History

> **[View Full Release Log](./RELEASE_LOG.md)**

All collected versions are tracked in the **[RELEASE_LOG.md](./RELEASE_LOG.md)** file, organized by platform.

---

## 🛠️ Usage

### Run Manually

You can trigger the monitor script manually for testing or ad-hoc updates:

```bash
# Check all platforms
./scripts/monitor.sh all

# Check specific platform
./scripts/monitor.sh win
./scripts/monitor.sh mac
./scripts/monitor.sh android

# Check with custom URL (Platform specific)
./scripts/monitor.sh win "https://example.com/WeChat.exe"
```

### Cleanup Duplicates

If you encounter redundant releases, use the cleanup tool:

```bash
# Dry run (safe mode)
./scripts/cleanup_duplicates.py

# Execute deletion
./scripts/cleanup_duplicates.py --execute
```

---

## 📂 Project Structure

```
.
├── RELEASE_LOG.md          # 📜 history of all releases
├── scripts/
│   ├── monitor.sh          # 🧠 Main logic entry point
│   ├── common.sh           # 🔧 Shared functions (Scraping, Git, Release)
│   └── cleanup_duplicates.py # 🧹 Maintenance tool
└── .github/workflows/
    └── destversion.yml     # 🤖 CI/CD Configuration
```

---

## 🔗 Related Projects

- [capcut-versions](https://github.com/canc3s/capcut-versions) — archive of Jianying and CapCut installers for Windows, macOS and Android

---

## 📄 License

This project is licensed under the MIT License.
