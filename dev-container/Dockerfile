FROM debian:bookworm-slim

LABEL maintainer="dev-container"
LABEL description="Remote development container based on Debian Bookworm"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# ============================================================
# 安装常用工具
# ============================================================
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    # SSH
    openssh-server \
    # 基础工具
    curl \
    wget \
    git \
    git-lfs \
    vim \
    neovim \
    nano \
    less \
    tree \
    htop \
    jq \
    unzip \
    zip \
    tar \
    rsync \
    ca-certificates \
    gnupg \
    lsb-release \
    apt-transport-https \
    software-properties-common \
    # 网络工具
    net-tools \
    iproute2 \
    iputils-ping \
    dnsutils \
    netcat-openbsd \
    # 开发工具
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    pkg-config \
    gdb \
    # 系统库
    libssl-dev \
    libffi-dev \
    zlib1g-dev \
    # Python
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    # Shell & 终端
    zsh \
    bash-completion \
    tmux \
    # 进程管理
    procps \
    lsof \
    # 搜索工具
    fd-find \
    ripgrep \
    # 本地化
    locales \
    tzdata \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ============================================================
# 配置 SSH
# ============================================================
RUN mkdir -p /var/run/sshd && \
    mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    # 生成 host keys
    ssh-keygen -A && \
    # 修改 sshd 配置
    cat > /etc/ssh/sshd_config <<'EOF'
Port 22
Protocol 2

# 认证配置
PermitRootLogin prohibit-password
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
AuthenticationMethods publickey

# 禁用密码登录
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
KbdInteractiveAuthentication no

# 安全配置
MaxAuthTries 5
ClientAliveInterval 120
ClientAliveCountMax 3

# 功能配置
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
EOF


# ============================================================
# 配置别名
# ============================================================
RUN cat >> /root/.zshrc <<'EOF'

# ---- Aliases ----
alias ll='ls -alF'
alias la='ls -A'
alias fd='fdfind'
alias gs='git status'
alias gl='git log --oneline --graph --all'

# ---- PATH ----
export PATH="$HOME/.local/bin:$PATH"
EOF

# ============================================================
# 启动脚本
# ============================================================
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

WORKDIR /root

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e"]
