#!/bin/bash

# 定义显示成功信息的函数
print_success() {
    echo -e "\e[32m$1\e[0m"
}

# 定义显示错误信息的函数
print_error() {
    echo -e "\e[31m错误：$1\e[0m"
}

# 检查是否已安装 Python 3
if command -v python3 &>/dev/null; then
    print_success "Python 3 已经安装。"
else
    print_error "未安装 Python 3，正在安装 Python 3..."
    sudo apt update
    sudo apt install -y python3
    if [ $? -ne 0 ]; then
        print_error "安装 Python 3 失败。退出脚本。"
        exit 1
    fi
    print_success "Python 3 安装成功。"
fi

# 检查是否已安装 pip
if command -v pip &>/dev/null; then
    print_success "pip 已经安装。"
else
    print_error "未安装 pip，正在安装 pip..."
    curl 'https://bootstrap.pypa.io/get-pip.py' > get-pip.py
    sudo python3 get-pip.py
    if [ $? -ne 0 ]; then
        print_error "安装 pip 失败。退出脚本。"
        exit 1
    fi
    print_success "pip 安装成功。"
fi

# 检查是否已安装 flask
if pip show flask &>/dev/null; then
    print_success "flask 已经安装。"
else
    print_error "未安装 flask，正在安装 flask..."
    sudo pip install flask -i https://pypi.tuna.tsinghua.edu.cn/simple/
    if [ $? -ne 0 ]; then
        print_error "安装 flask 失败。退出脚本。"
        exit 1
    fi
    print_success "flask 安装成功。"
fi

# 检查是否已安装 flask_cors
if pip show flask_cors &>/dev/null; then
    print_success "flask_cors 已经安装。"
else
    print_error "未安装 flask_cors，正在安装 flask_cors..."
    sudo pip install flask_cors -i https://pypi.tuna.tsinghua.edu.cn/simple/
    if [ $? -ne 0 ]; then
        print_error"安装 flask_cors 失败。退出脚本。"
        exit 1
    fi
    print_success "flask_cors 安装成功。"
fi

# 检查是否已安装 psutil
if pip show psutil &>/dev/null; then
    print_success "psutil 已经安装。"
else
    print_error "未安装 psutil，正在安装 psutil..."
    sudo pip install psutil -i https://pypi.tuna.tsinghua.edu.cn/simple/
    if [ $? -ne 0 ]; then
        print_error "安装 psutil 失败。退出脚本。"
        exit 1
    fi
    print_success "psutil 安装成功。"
fi

# 检查是否已安装 requests
if pip show requests &>/dev/null; then
    print_success "requests 已经安装。"
else
    print_error "未安装 requests，正在安装 requests..."
    sudo pip install requests -i https://pypi.tuna.tsinghua.edu.cn/simple/
    if [ $? -ne 0 ]; then
        print_error "安装 requests 失败。退出脚本。"
        exit 1
    fi
    print_success "requests 安装成功。"
fi

# 下载 web_system_apt.py
print_success "正在下载 web_system_apt.py..."
curl -O https://cdn.jsdelivr.net/gh/codewyx/cmscdn/web_system_apt3.py
mv web_system_apt3.py web_system_apt.py
if [ $? -ne 0 ]; then
    print_error "下载 web_system_apt.py 失败。退出脚本。"
    exit 1
fi
print_success "web_system_apt.py 下载成功。"

# 赋予 web_system_apt.py 执行权限
chmod +x web_system_apt.py
if [ $? -ne 0 ]; then
    print_error "赋予 web_system_apt.py 执行权限失败。退出脚本。"
    exit 1
fi
print_success "web_system_apt.py 执行权限赋予成功。"

# 使用 nohup 守护运行 web_system_apt.py
print_success "正在启动 面板交互进程 在端口 21909..."
nohup python3 web_system_apt.py &
if [ $? -ne 0 ]; then
    print_error "启动 面板交互进程 失败。退出脚本。"
    exit 1
fi
print_success "面板交互进程 启动成功。"
