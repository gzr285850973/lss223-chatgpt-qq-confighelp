#!/bin/bash
chatgpt_path="$HOME/chatgpt-qq/"
config_path="$HOME/chatgpt-qq/config.cfg"
confighelper_path="$HOME/chatgpt-qq/confighelper.sh"
#函数定义区
function build_chatgpt {
    bash -c "$(curl -fsSL https://gist.githubusercontent.com/lss233/54f0f794f2157665768b1bdcbed837fd/raw/chatgpt-mirai-installer-154-16RC3.sh)"
}
function start_chatgpt {
    if [ -f "$config_path" ]; then
        cd $chatgpt_path
        docker-compose up -d
    else
        echo -e "配置文件不存在，请下载程序或者使用confighelper!"
    fi
}
function logs_chatgpt {
    if [ -f "$config_path" ]; then
        cd $chatgpt_path
        echo -e "请注意，执行本程序如果你的ssh终端不支持图片渲染 可能会导致乱码 退出vps重进即可"
        sleep 5
        docker-compose logs -f
    else
        echo -e "配置文件不存在，请下载程序或者使用confighelper!"
    fi
}
function exit_chatgpt {
    if [ -f "$config_path" ]; then
        cd $chatgpt_path
        docker-compose stop
    else
        echo -e "配置文件不存在，请下载程序或者使用confighelper!"
    fi    
}
function update_chatgpt {
    if [ -f "$config_path" ]; then
        cd $chatgpt_path
        docker-compose pull
    else
        echo -e "配置文件不存在，请下载程序或者使用confighelper! 
    fi
}
function login_qq {
    if [ -f "$config_path" ]; then
        cd $chatgpt_path
        docker run --rm mirai
    else
        echo -e "配置文件不存在，请下载程序或者使用confighelper! 
    fi
}
function config_help {
    if [ -f "$confighelper_path" ]; then
        bash $confighelper_path
    else
       curl -o confighelper.sh https://raw.githubusercontent.com/Cloxl/lss223-chatgpt-qq-confighelp/main/confighelper.sh && mv confighelper.sh $chatgpt_path && bash $confighelper_path && mv config.cfg $chatgpt_path
    fi
}
function main {
    echo -e "请选择需要执行的程序："
    echo -e "1. 下载chatgpt-qq"
    echo -e "2. 启动chatgpt-qq"
    echo -e "3. 查看docker运行日志"
    echo -e "4. 更新chatgpt-qq"
    echo -e "5. 使用临时镜像登陆qq"
    echo -e "6. 关闭正在运行的chatgpt-qq"
    echo -e "7. 下载confighelper脚本 进行配置文件编辑"
    echo -e "请选择1~7"
    read choice
    case $choice in
      1)
        echo -e "开始下载chatgpt-qq"
        build_chatgpt
        ;;
      2)
        echo -e "正在启动chatgpt-qq"
        start_chatgpt
        ;;
      3)
        logs_chatgpt
        ;;
      4)
        ehco -e "开始更新，请手动启动或者在本程序内选择启动"
        update_chatgpt
        ;;
      5)
        ehco -e "正在加载mirai"
        login_qq
        ;;
      6)
        ehco -e "正在关闭......"
        exit_chatgpt
        ;;
      7)
        echo -e "正在启用"
        config_help
        ;;
      *)
        clear
        echo -e "无效选择，请重新选择"
        main
        ;;
    esac
}
main