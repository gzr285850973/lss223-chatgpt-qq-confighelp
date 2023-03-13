#!/bin/bash
#函数定义区
#设置bot模式为mirai
function set_mirai_bot {
    echo -e "\033[32m接下来是mirai的配置\033[0m"
    echo -e  "您机器人的QQ号是多少？"
    read qq_number
    echo -e "您机器人管理员的QQ号是多少？"
    read manager_qq
    echo -e "您是否需要更改mirai-http-api中的verifyKey？（y/n，默认n）"
    read change_verifykey
    if echo -e "$change_verifykey" | grep -iq "^y"; then
        echo -e "请输入新的verifyKey："
        read verifykey
    else
        verifykey="1234567890"
    fi    
    echo -e "您是否需要更改mirai-http-api中http_url的端口？（y/n，默认n）"
    read change_http_url_port
    if echo -e "$change_http_url_port" | grep -iq "^y"; then
        echo -e "请输入新的http_http_url的端口："
        read http_url_port
    else
        http_url_port="8080"
    fi    
    echo -e "您是否需要更改mirai-http-api中的ws_url的端口？（y/n，默认n）"
    read change_ws_url_port
    if echo -e "$change_ws_url_port" | grep -iq "^y"; then
        echo -e "请输入新的ws_url的端口："
        read ws_url_port
    else
        ws_url_port="8080"
    fi
    echo -e "[mirai]
qq = $qq_number
manager_qq = $manager_qq
api_key = \"$verifykey\"
http_url = \"http://mirai:${http_url_port}\"
ws_url = \"http://mirai:${ws_url_port}\"
[openai]
browserless_endpoint = \"https://bypass.duti.tech/api/\"" > config.cfg
}
#设置bot模式为telegram
function set_telegram_bot {
    echo -e "\033[32mTelegram的配置\033[0m"
    echo -e "请输入您的Bot Token："
    read bot_token
    echo -e "您是否需要设置代理？（y/n，默认n）"
    read need_proxy
    if echo -e "$need_proxy" | grep -iq "^y"; then
        echo -e "请输入代理地址："
        read proxy_address
        proxy="proxy = \"$proxy_address\""
    else
        proxy=""
    fi
    echo -e "[telegram]
bot_token = \"$bot_token\"
$proxy
[openai]
browserless_endpoint = \"https://bypass.duti.tech/api/\"" > config.cfg
}
# 设置bot模式为onebot
function set_onebot {
    echo -e "\033[32m接下来是OneBot的配置\033[0m"
    echo -e "请输入机器人的QQ号："
    read qq
    echo -e "请输入机器人管理员的QQ号："
    read manager_qq
    echo -e "请输入反向WS的主机地址："
    read reverse_ws_host
    echo -e "请输入反向WS的端口号："
    read reverse_ws_port
    echo -e "[onebot]
qq = $qq
manager_qq = $manager_qq
reverse_ws_host = \"$reverse_ws_host\"
reverse_ws_port = $reverse_ws_port
[openai]
browserless_endpoint = \"https://bypass.duti.tech/api/\"" >> config.cfg
}
#设置浏览器模式
function select_browser_mode {
    echo -e "请选择第此号的浏览器模式"
    echo -e "\033[31my). 浏览器模式 该模式需要你的ip能访问openai\033[0m"
    echo -e "\033[32mn). 无浏览器模式 该模式通过第三方代理登陆所以ip能不能访问openai都不重要\033[0m"
    echo -e "\033[31m（y/n，默认n）\033[0m"
    read change_browser_mode
    if echo -e "$change_browser_mode" | grep -iq "^y"; then
        browser_mode="browser"
    else
        browser_mode="browserless"    
    fi
    echo -e "[[openai.accounts]]
mode = \"${browser_mode}\"" >> config.cfg
}
#设置代理
function set_proxy {
    echo -e "正向代理设置 如果你的ip或服务器ip在国内 则需设置正向代理 具体请看项目文档 这一步为不可控"
    read proxy
    echo -e "proxy = \"${proxy}\"" >> config.cfg
}
#设置账号密码登陆
function set_email_account {
    clear
    echo -e "你选择了邮箱版本："
    echo -e "优点：自动刷新 access_token 和 session_token，无需人工操作"
    echo -e "缺点：需要国外网络环境或者使用代理"
    echo -e "请输入邮箱账号:>"
    read email_account
    echo -e "请输入邮箱密码:>"
    read email_password
    echo -e "email = \"${email_account}\"
password = \"${email_password}\"" >> config.cfg
}
# 一些杂项设置
function set_puls_version {
    echo -e "你的第 $i 个账号是否为plus版本 （y/n，默认n）"
    read change_plus
    if echo -e "$change_plus" | grep -iq "^y"; then
        echo -e "paid = true " >> config.cfg
        echo -e "title_pattern = \"qq-{session_id}\"" >> config.cfg
        echo -e "auto_remove_old_conversations = true" >> config.cfg
    else
        echo -e "paid = false" >> config.cfg
    fi
}
#设置token登陆
function set_token_login {
    echo -e  "\033[32m你选择了token版本：\033[0m"
    echo -e "优点：适用于在国内网络环境 适用于通过 Google / 微软 注册的 OpenAI 账号 登录过程较快"
    echo -e "缺点：有效期为 30 天，到期后需更换"
    echo -e "使用session_token登陆 不知道有效期多久 推荐还是access_token"
    echo -e "\033[32m请选择session_token还是access_token登陆 默认access_token\033[0m"
    echo -e "\033[31m输入y为session_token\033[0m,\033[33m输入n为access_token\033[0m\033[34m（y/n，默认n）\033[0m"
    read change_token
    if echo -e "$change_token" | grep -iq "^y"; then
        echo -e "请输入session_token："
        read session
        echo -e "session_token = \"${session}\"" >> config.cfg
    else
        echo -e "请输入access_token"
        read access
        echo -e "access_token = \"${access}\"" >> config.cfg
    fi
}
#选择bot函数
function select_bot {
    echo -e "\033[32m请选择要配置的机器人类型：\033[0m"
    echo -e "1. Mirai"
    echo -e "2. OneBot"
    echo -e "3. Telegram Bot"
    echo -e "请输入数字选择机器人类型：" 
    read bot_type
    if [ $bot_type -eq 1 ]; then
        set_mirai_bot
    elif [ $bot_type -eq 2 ]; then
        set_onebot
    elif [ $bot_type -eq 3 ]; then
        set_telegram_bot
    else
        echo -e "\033[31m输入有误，请重新选择！\033[0m"
            select_bot
    fi
}
#登陆openai函数
function login_openai {
    echo -e "\033[32mbot设置部分设置结束，接下来是openai账号部分\033[0m"
    echo -e "请问你需要设置几个账号？(如果一个账号既登陆又设置api则为俩个账号)"
    read count
    for i in $(seq 1 $count)
    do
        clear
        echo -e "请为第 $i 个账号选择一个版本："
        echo -e "1). 邮箱(网页版)"
        echo -e "2). token(网页版)"
        echo -e "3). api-key(api版)"
        read version
        if [ $version -eq 1 ]
        then
            select_browser_mode
            set_email_account
            clear
            echo -e "你的ip或服务器ip是否在国内（y/n，默认n）"
            read change_proxy
            if echo -e "$change_proxy" | grep -iq "^y"; then
                set_proxy
            fi
            set_puls_version
        elif [ $version -eq 2 ]
        then
            select_browser_mode
            set_token_login
            clear
            echo -e "你的ip或服务器ip是否在国内（y/n，默认n）"
            read change_proxy
            if echo -e "$change_proxy" | grep -iq "^y"; then
                set_proxy
            fi
            set_puls_version
        elif [ $version -eq 3 ]
        then
            clear
            echo -e "\033[33m你选择了key版本：\033[0m"
            echo -e "优点：响应快 能画画"
            echo -e "缺点：烧钱 容易封号"
            echo -e "请输入api-key"
            read api
            echo -e "[[openai.accounts]]
api_key = \"${api}\"" >> config.cfg
            set_proxy
            clear
        else
            echo -e "无效的输入，重新开始"
            login_openai
        fi
    done
}
echo -e "\033[31m请注意，接下来的输入中，请你严格按照提示内容输入，否则重新运行次脚本，我不可能每一步都给你套一个循环\033[0m"
sleep 5
clear
echo -e "您是否在Linux系统上运行此脚本？（y/n，默认y）"
read is_linux    #不要问我为什么这样写 鬼知道还有人拿安卓运行这个脚本 搞得我很多命令都要兼顾安卓
if echo -e "$is_linux" | grep -iq "^n"; then
    echo -e "此脚本只能在Linux系统上运行(windows真有人会用shell脚本吗 其实你动手改一下 就能使用cmd运行了)"
    exit 1
fi
select_bot
login_openai
clear
echo -e "请问你是否要添加bing账号（y/n，默认n）"
read bing_value
if echo -e "$bing_value" | grep -iq "^y"; then
echo -e "[bing]" >> config.cfg
echo -e "请问你需要添加多少个bing账号"
read bing_num
for k in $(seq 1 $bing_num)
do
    echo -e "请输入第 $k 个bing账号的Cookie，获取方法见README"
    echo -e "cookie_content = MUID=xxxxx; SRCHD=AF=xxxx; SRCHUID=V=2&GUID=xxxxxxxx;  MicrosoftApplicationsTelemetryDeviceId=xxxxxx-xxxx-xxxx-xxx-xxxxx; ...一串很长的文本..."
    read cookie
    echo -e "[[bing.accounts]]
cookie_content = \"${cookie}\"" >> config.cfg
done
fi
clear
echo -e "恭喜你 完成了账号部分的配置 现在是图片转文字设置 请问是否需要自定义设置？（y/n，默认n）"
read text_image
if echo -e "$text_image" | grep -iq "^y"; then
    echo -e "[text_to_image]" >> config.cfg
    echo -e "是否强制开启文字转图片？设置后所有的消息强制以图片发送，减小风控概率  （y/n，默认n）"
    read always
    if echo -e "$always" | grep -iq "^y"; then
        echo -e "always = true" >> config.cfg
    else
        echo -e "always = false" >> config.cfg
    fi
    echo -e "是否默认开启，设置后所有的消息默认以图片发送，减小风控概率？ （y/n，默认n） "
    read default
    if echo -e "$default" | grep -iq "^y"; then
        echo -e "default = true" >> config.cfg
    else
        echo -e "default = false" >> config.cfg
    fi
    echo -e "请输入备用模式字体大小 默认值 30"
    read font_size
    echo -e "font_size = ${font_size}" >> config.cfg
    echo -e "请输入备用模式图片宽度 默认值 700"
    read width
    echo -e "width = ${width}
font_path = \"fonts/sarasa-mono-sc-regular.ttf\"
offset_x = 50 
offset_y = 50 " >> config.cfg
else
    echo -e "[text_to_image]
always = true
default = true
font_size = 30
width = 700
font_path = \"fonts/sarasa-mono-sc-regular.ttf\" 
offset_x = 50 
offset_y = 50" >> config.cfg
fi
clear
echo -e "[trigger]" >> config.cfg
echo -e "是否开启个性化前缀？（y/n，默认n）"
read prefix
if echo -e "$prefix" | grep -iq "^y"; then
    echo -n "prefix = [">> config.cfg
    echo -e "请输入你有多少个想添加的全局前缀"#此脚本完成的时间并没有私聊前缀 群聊前缀的设置
    read prefix_num
    for j in $(seq 1 $prefix_num)
    do
        echo -e "请输入你的第 $j 个前缀"
        read prefix
        echo -e -n "\"${prefix}\"," >> config.cfg
    done
    echo -e "]" >> config.cfg
    echo -e "配置群里如何让机器人响应，\033[32mat\033[0m 表示需要群里 \033[32m@\033[0m 机器人， \033[32mmention\033[0m 表示 \033[32m@\033[0m 或者\033[32m以机器人名字开头\033[0m都可以，\033[32mnone\033[0m 表示\033[32m不需要\033[0m"
    read require_mention
    echo -e "require_mention = \"${require_mention}\"
prefix_ai = { \"chatgpt-web\" = [\"gpt\"], \"bing-c\" = [\"bing\"] }
prefix_image = [\"画\",\"看\"]
reset_command = [ \"重置会话\",]
rollback_command = [ \"回滚会话\",] ">> config.cfg
else
    echo -e "prefix = [ \"\",]
prefix_friend = [ \"\",]
prefix_group = [ \"\",]
prefix_ai = { \"chatgpt-web\" = [\"gpt\"], \"bing-c\" = [\"bing\"] }
prefix_image = [\"画\", \"看\"]
require_mention = \"at\"
reset_command = [ \"重置会话\",]
rollback_command = [ \"回滚会话\",] " >>config.cfg
fi
clear
echo -e "恭喜你完成了机器人响应的设置，现在是百度云安全内容审核的设置请问是否需要？（y/n，默认n）"
read baudu
if echo -e "$baudu" | grep -iq "^y"; then
    echo -e "[baiducloud]" >> config.cfg
    echo -e "是否启动百度云内容安全审核? （y/n，默认n）"
    read check
    if echo -e "$check" | grep -iq "^y"; then
        echo -e "check = true" >> config.cfg
    else
        echo -e "check = false" >> config.cfg
    fi
    echo -e "请输入百度云API_KEY 24位英文数字字符串"
    read baidu_api_key
    echo -e "请输入百度云SECRET_KEY 32位的英文数字字符串"
    read baidu_secret_key
    echo -e "baidu_api_key = \"${baidu_api_key}\"
baidu_secret_key = \"${baidu_secret_key}\"
illgalmessage = \"[百度云]请珍惜机器人，当前返回内容不合规\"" >>config.cfg
fi
clear
echo -e "设置已经进入尾声，现在是最后一项设置"
echo -e "[system]" >> config.cfg
echo -e "机器人的账户是否自动同意进群邀请？（y/n，默认n）"
read accept_group_invite
if echo -e "$default" | grep -iq "^y"; then
    echo -e "accept_group_invite = true" >> config.cfg
else
    echo -e "accept_group_invite = false" >> config.cfg
fi
echo -e "机器人的账号是否自动同意好友？（y/n，默认n）"
read accept_friend_request
if echo -e "$default" | grep -iq "^y"; then
    echo -e "accept_friend_request = true" >> config.cfg
else
    echo -e "accept_friend_request = false" >> config.cfg
fi
echo -n "[presets]
# 切换预设的命令： 加载预设 猫娘
command = \"加载预设 (\\\\w+)\"
loaded_successful = \"预设加载成功！\"
scan_dir = \"./presets/\"
[presets.keywords]
# 预设关键词 <-> 实际文件
\"正常\" = \"presets/default.txt\"
\"猫娘\" = \"presets/catgirl.txt\"
[ratelimit]
warning_rate = 0.9
warning_msg = \"警告：额度即将耗尽！目前已发送：{usage}条消息，最大限制为{limit}条消息/小时，请调整您的节奏。额度限制整点重置，当前服务器时间：{current_time}\"
exceed = \"已达到额度限制，请等待下一小时继续和我对话。\"" >> config.cfg
echo -e "配置文件已创建！"