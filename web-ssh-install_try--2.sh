#!/bin/bash

# 定义显示成功信息的函数
print_success() {
    echo -e "\e[32m$1\e[0m"
}

# 定义显示错误信息的函数
print_error() {
    echo -e "\e[31m错误：$1\e[0m"
}

# 检查并更新包管理器和安装 Python 3
install_python3() {
    if command -v python3 &>/dev/null; then
        print_success "Python 3 已经安装。"
    else
        if command -v apt &>/dev/null; then
            print_success "检测到 apt，使用 apt 安装 Python 3..."
            sudo apt update
            sudo apt install -y python3
        elif command -v yum &>/dev/null; then
            print_success "检测到 yum，使用 yum 安装 Python 3..."
            sudo yum install -y python3
        else
            print_error "无法确定包管理器。退出脚本。"
            exit 1
        fi

        if ! command -v python3 &>/dev/null; then
            print_error "安装 Python 3 失败。退出脚本。"
            exit 1
        fi

        print_success "Python 3 安装成功。"
    fi
}

# 检查并安装 pip
install_pip() {
    if command -v pip &>/dev/null; then
        print_success "pip 已经安装。"
    else
        print_error "未安装 pip，正在安装 pip..."
        curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        sudo python3 get-pip.py
        if [ $? -ne 0 ]; then
            print_error "安装 pip 失败。退出脚本。"
            exit 1
        fi
        print_success "pip 安装成功。"
    fi
}

# 安装 webssh
install_webssh() {
    if command -v wssh &>/dev/null; then
        print_success "webssh 已经安装。"
    else
        print_error "未安装 webssh，正在安装 webssh..."
        sudo pip install webssh -i https://pypi.tuna.tsinghua.edu.cn/simple/
        if [ $? -ne 0 ]; then
            print_error "安装 webssh 失败。退出脚本。"
            exit 1
        fi
        print_success "webssh 安装成功。"
    fi
}

# 启动 webssh
start_webssh() {
    print_success "正在启动 webssh 在端口 21908..."
    wssh --port=21908
}

# 主逻辑
main() {
    install_python3
    install_pip
    install_webssh
    start_webssh
}

# 执行主逻辑
main
