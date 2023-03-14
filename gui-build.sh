#!/bin/bash
#变量定义
chatgpt_path="$HOME/chatgpt-qq/"
config_path="$HOME/chatgpt-qq/config.cfg"
confighelper_path="$HOME/chatgpt-qq/confighelper.sh"
#函数定义
function build_chatgpt {
    bash -c "$(curl -fsSL https://gist.githubusercontent.com/lss233/54f0f794f2157665768b1bdcbed837fd/raw/chatgpt-mirai-installer-154-16RC3.sh)"
}
function start_chatgpt {
    if [ -f "$config_path" ]; then
        cd $chatgpt_path
        docker-compose up -d
        exit 0
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
        echo -e "配置文件不存在，请下载程序或者使用confighelper!"
    fi
}
function login_qq {
    if [ -f "$config_path" ]; then
        cd $chatgpt_path
        docker run --rm mirai
    else
        echo -e "配置文件不存在，请下载程序或者使用confighelper!"
    fi
}
function config_help {
    if [ -f "$confighelper_path" ]; then
        bash $confighelper_path
    else
       curl -o confighelper.sh https://raw.githubusercontent.com/Cloxl/lss223-chatgpt-qq-confighelp/main/confighelper.sh && mv confighelper.sh $chatgpt_path && bash $confighelper_path
    fi
}
#主函数
while true; do
    choice=$(whiptail \
--title "Chatgpt for QQ help" \
--notags \
--menu "请选择需要执行的程序：" \
15 60 8 \
"1" "下载chatgpt-qq" \
"2" "启动chatgpt-qq" \
"3" "查看docker运行日志" \
"4" "更新chatgpt-qq" \
"5" "使用临时镜像登陆qq(适用于qq没登陆上需要再次登陆的时候)" \
"6" "关闭正在运行的chatgpt-qq" \
"7" "使用confighelper脚本 进行配置文件编辑" \
"0" "退出" \
3>&1 1>&2 2>&3)   
    case $choice in
        1)
            clear
            echo "您选择了下载chatgpt-qq"
            build_chatgpt
            ;;
        2)
            clear
            echo "您选择了启动chatgpt-qq"
            start_chatgpt
            ;;
        3)
            clear
            echo "您选择了查看docker运行日志"
            logs_chatgpt
            ;;
        4)
            clear
            echo "您选择了更新chatgpt-qq"
            update_chatgpt
            ;;
        5)
            clear
            echo "您选择了使用临时镜像登陆qq"
            login_qq
            ;;
        6)
            clear
            echo "您选择了关闭正在运行的chatgpt-qq"
            exit_chatgpt
            ;;
        7)
            clear
            echo "您选择了使用confighelper脚本 进行配置文件编辑"
            config_help
            ;;
        0)
            echo "您选择了退出"
            exit 0
            ;;
        *)
            echo "无效的选项，请重新选择"
            ;;
    esac
done
