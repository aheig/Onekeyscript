#!/bin/bash

# 确保脚本是以 root 权限运行
if [ "$EUID" -ne 0 ]; then
    echo "❌ 错误：请使用 sudo 或 root 权限运行此脚本！"
    exit 1
fi

echo "🔄 开始配置 Debian 13 全局中文环境..."

# 1. 更新源并确保安装了 locales 工具
echo "📦 正在检查并安装 locales 组件..."
apt-get update -y && apt-get install -y locales

# 2. 修改 locale.gen 文件，取消 zh_CN 相关的注释
echo "📝 正在配置支持的字符集 (zh_CN.UTF-8 和 zh_CN.GBK)..."
sed -i '/^#.*zh_CN.UTF-8 UTF-8/s/^#\s*//' /etc/locale.gen
sed -i '/^#.*zh_CN.GBK GBK/s/^#\s*//' /etc/locale.gen

# 如果文件中原本没有，则直接追加
if ! grep -q "^zh_CN.UTF-8 UTF-8" /etc/locale.gen; then
    echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
fi
if ! grep -q "^zh_CN.GBK GBK" /etc/locale.gen; then
    echo "zh_CN.GBK GBK" >> /etc/locale.gen
fi

# 3. 重新生成语言包
echo "⚙️ 正在生成区域设置 (locale-gen)..."
locale-gen

# 4. 设置系统全局默认语言
echo "🌐 正在设置全局默认语言为中文 UTF-8..."
cat << EOF > /etc/default/locale
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh"
LC_ALL="zh_CN.UTF-8"
EOF

# 5. 为当前非 root 用户（如果有的话）和 root 用户配置终端环境变量
echo "🖥️ 正在配置终端环境变量..."

# 定义需要追加的环境变量内容
ENV_LOCALE=$(cat << 'EOF'

# Debian 中文环境配置
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:zh
export LC_ALL=zh_CN.UTF-8
EOF
)

# 写入当前运行 sudo 的实际用户 ~/.bashrc
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
    if ! grep -q "export LANG=zh_CN.UTF-8" "$USER_HOME/.bashrc"; then
        echo "$ENV_LOCALE" >> "$USER_HOME/.bashrc"
        chown "$SUDO_USER:$SUDO_USER" "$USER_HOME/.bashrc"
    fi
fi

# 写入当前 root 用户的 ~/.bashrc
if ! grep -q "export LANG=zh_CN.UTF-8" ~/.bashrc; then
    echo "$ENV_LOCALE" >> ~/.bashrc
fi

echo "=================================================="
echo "      🎉 Debian 13 中文环境一键配置完成！"
echo "=================================================="
echo "💡 提示：为了使全局配置完全生效，请执行以下操作之一："
echo "   1. 运行命令立即刷新当前终端：source ~/.bashrc"
echo "   2. 或者断开 SSH 重新连接，或重启系统。"
echo "=================================================="
