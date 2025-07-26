# 🚀 发布指南

本项目使用 GitHub Actions 自动化发布流程，支持正式版本和预发布版本的自动构建、发布和上传到浏览器扩展商店。

## 📋 版本命名规范

### 正式版本
- `1.0.0` - 稳定版本，会自动发布到 Chrome Web Store 和 Firefox Add-ons
- `2.1.3` - 后续稳定版本

### 预发布版本 (仅创建 GitHub Release，不发布到商店)
- `1.0.0-alpha.1` - Alpha 测试版本
- `1.0.0-beta.1` - Beta 测试版本
- `1.0.0-rc.1` - Release Candidate 候选版本

## 🛠️ 发布方式

### 方式一：使用发布脚本 (推荐)

```bash
# 稳定版本发布
./scripts/release.sh 1.0.0

# Alpha 版本发布
./scripts/release.sh 1.0.0-alpha.1

# Beta 版本发布
./scripts/release.sh 1.0.0-beta.1

# RC 版本发布
./scripts/release.sh 1.0.0-rc.1
```

脚本会自动：
- ✅ 验证版本格式
- ✅ 检查是否在 main 分支
- ✅ 检查工作目录是否干净
- ✅ 运行类型检查和格式检查
- ✅ 构建扩展
- ✅ 更新 package.json 版本
- ✅ 创建提交和标签
- ✅ 推送到 GitHub

### 方式二：手动通过 GitHub Actions

1. 访问项目的 GitHub Actions 页面
2. 选择 "Create Release Tag" 工作流
3. 点击 "Run workflow"
4. 输入版本号 (如 `1.0.0` 或 `1.0.0-alpha.1`)
5. 选择是否更新 package.json 版本
6. 点击 "Run workflow" 开始执行

### 方式三：直接推送标签

```bash
# 更新版本号
npm version 1.0.0 --no-git-tag-version
git add package.json
git commit -m "chore: bump version to 1.0.0"

# 创建并推送标签
git tag v1.0.0
git push origin main
git push origin v1.0.0
```

## 🔄 自动化流程

当推送标签时，GitHub Actions 会自动：

### 1. 构建和发布 (`release.yml`)
- 🏗️ 构建 Chrome 和 Firefox 扩展
- 📦 创建 ZIP 文件
- 🏷️ 创建 GitHub Release
- ⬆️ 上传扩展文件到 Release

### 2. 商店发布 (仅稳定版本)
- 🌐 发布到 Chrome Web Store
- 🦊 发布到 Firefox Add-ons

### 3. 预发布版本
- ⚠️ Alpha/Beta/RC 版本只创建 GitHub Release
- 📥 提供下载链接，不自动发布到商店

## ⚙️ 商店发布配置

要启用自动发布到浏览器扩展商店，需要配置以下 GitHub Secrets：

### Chrome Web Store
```
CHROME_STORE_KEYS = {
  "clientId": "your-client-id",
  "clientSecret": "your-client-secret",
  "refreshToken": "your-refresh-token",
  "extId": "your-extension-id"
}
```

### Firefox Add-ons
```
FIREFOX_STORE_KEYS = {
  "apiKey": "your-api-key",
  "apiSecret": "your-api-secret",
  "extId": "your-extension-id"
}
```

详细配置说明请参考 [`.github/PUBLISHING_SETUP.md`](.github/PUBLISHING_SETUP.md)。

## 🔍 工作流监控

### CI 工作流 (`ci.yml`)
- 🔄 在每次推送到 main/develop 分支时运行
- ✅ 类型检查、格式检查、构建测试
- 📤 上传构建产物作为 Artifacts

### 发布工作流 (`release.yml`)
- 🏷️ 在推送标签时触发
- 🚀 自动构建和发布

### 创建标签工作流 (`create-tag.yml`)
- 🎯 手动触发
- 📝 创建标签和版本提交

## 📚 使用示例

### 发布 1.0.0 稳定版本
```bash
./scripts/release.sh 1.0.0
```

结果：
- ✅ 创建 GitHub Release
- ✅ 上传扩展文件
- ✅ 自动发布到 Chrome Web Store
- ✅ 自动发布到 Firefox Add-ons

### 发布 1.1.0-alpha.1 测试版本
```bash
./scripts/release.sh 1.1.0-alpha.1
```

结果：
- ✅ 创建 GitHub Release (标记为 pre-release)
- ✅ 上传扩展文件
- ❌ 不发布到商店 (测试版本)

## 🚨 注意事项

1. **分支要求**: 只能在 `main` 分支创建发布
2. **版本格式**: 必须遵循语义化版本规范
3. **标签唯一性**: 每个版本标签只能创建一次
4. **工作目录**: 创建发布前确保工作目录干净
5. **权限要求**: 需要仓库写入权限来推送标签
6. **商店发布**: 首次发布需要手动上传扩展获取 ID

## 🔗 相关链接

- [Chrome Web Store Developer Dashboard](https://chrome.google.com/webstore/devconsole/)
- [Firefox Add-on Developer Hub](https://addons.mozilla.org/developers/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [语义化版本规范](https://semver.org/)
