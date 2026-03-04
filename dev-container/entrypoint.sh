#!/bin/bash
set -e

AUTH_KEYS="/root/.ssh/authorized_keys"

# 公钥注入 - 支持三种方式
# 1. 环境变量 SSH_PUBLIC_KEY
# 2. 挂载文件 /tmp/authorized_keys
# 3. 构建时已写入（无需处理）

if [ -n "${SSH_PUBLIC_KEY}" ]; then
    echo "${SSH_PUBLIC_KEY}" >> "${AUTH_KEYS}"
    echo "[INFO] SSH public key loaded from environment."
fi

if [ -f "/tmp/authorized_keys" ]; then
    cat /tmp/authorized_keys >> "${AUTH_KEYS}"
    echo "[INFO] SSH public key loaded from mounted file."
fi

if [ -f "${AUTH_KEYS}" ]; then
    sort -u "${AUTH_KEYS}" -o "${AUTH_KEYS}"
    chmod 600 "${AUTH_KEYS}"
else
    echo "[WARN] No SSH public key found! You won't be able to login."
fi

# 确保 host keys 存在
ssh-keygen -A > /dev/null 2>&1

echo "[INFO] SSH server starting..."
exec "$@"
