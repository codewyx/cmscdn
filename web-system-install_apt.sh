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

# 下载 web_system_apt.py
print_success "正在下载 web_system_apt.py..."
curl -O https://cdn.jsdelivr.net/gh/codewyx/cmscdn/web_system_apt.py
if [ $? -ne 0 ]; then
    print_error "下载 web_system_apt.py 失败。退出脚本。"
    exit 1
fi
print_success "web_system_apt.py 下载成功。"

# 赋予 web_system_apt.py 执行权限
cd root
chmod +x web_system_apt.py
if [ $? -ne 0 ]; then
    print_error "赋予 web_system_apt.py 执行权限失败。退出脚本。"
    exit 1
fi
print_success "web_system_apt.py 执行权限赋予成功。"

# 使用 nohup 守护运行 web_system_apt.py
print_success "正在启动 web_system_apt.py 并保持守护运行..."
nohup python3 web_system_apt.py &
if [ $? -ne 0 ]; then
    print_error "启动 web_system_apt.py 失败。退出脚本。"
    exit 1
fi
print_success "web_system_apt.py 启动成功并保持守护运行。"

print_success "正在启动 面板交互进程 在端口 21909..."
python3 setup.py &
if [ $? -ne 0 ]; then
    print_error "启动面板交互进程失败。退出脚本。"
    exit 1
fi
print_success "面板交互进程启动成功。"
