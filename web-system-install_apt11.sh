#!/bin/bash

# 定义显示成功信息的函数
print_success() {
    echo -e "\e[32m$1\e[0m"
}

# 定义显示错误信息的函数
print_error() {
    echo -e "\e[31m错误：$1\e[0m"
}

# 下载 web_panel_system 二进制文件
print_success "正在下载 web_panel_system 二进制文件..."
curl -L -O https://cdn.jsdelivr.net/gh/codewyx/cmscdn/web_panel_system
if [ $? -ne 0 ]; then
    print_error "下载 web_panel_system 二进制文件失败。退出脚本。"
    exit 1
fi
print_success "web_panel_system 二进制文件下载成功。"

# 赋予 web_panel_system 执行权限
chmod +x web_panel_system
if [ $? -ne 0 ]; then
    print_error "赋予 web_panel_system 执行权限失败。退出脚本。"
    exit 1
fi
print_success "web_panel_system 执行权限赋予成功。"

# 使用 nohup 守护运行 web_panel_system
print_success "正在启动 面板交互进程 在端口 21909..."
nohup ./web_panel_system &
if [ $? -ne 0 ]; then
    print_error "启动 面板交互进程 失败。退出脚本。"
    exit 1
fi
print_success "面板交互进程 启动成功。"
