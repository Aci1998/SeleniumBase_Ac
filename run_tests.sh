#!/bin/bash

# 进入代码目录
if [ -d "SeleniumBase_Ac" ]; then
    echo "进入代码目录..."
    cd SeleniumBase_Ac || { echo "无法进入 SeleniumBase_Ac 目录"; exit 1; }
    echo "更新代码..."
    git pull || { echo "拉取代码失败"; exit 1; }
else
    echo "拉取代码..."
    git clone https://github.com/Aci1998/SeleniumBase_Ac.git || { echo "克隆代码失败"; exit 1; }
    cd SeleniumBase_Ac || { echo "无法进入 SeleniumBase_Ac 目录"; exit 1; }
fi

# 创建虚拟环境
echo "创建虚拟环境..."
if [ ! -d "venv" ]; then
    python3 -m venv venv || { echo "创建虚拟环境失败"; exit 1; }
fi
source venv/bin/activate || { echo "激活虚拟环境失败"; exit 1; }

# 安装依赖
echo "安装依赖..."
pip install -r requirements.txt || { echo "安装依赖失败"; exit 1; }

# 更新 pip 并安装测试工具
echo "更新 pip 并安装测试工具..."
pip install --upgrade pip || { echo "更新 pip 失败"; exit 1; }
pip install pytest pytest-html seleniumbase || { echo "安装测试工具失败"; exit 1; }

# 创建报告目录
TIMESTAMP=$(date +%Y%m%d%H%M%S)
REPORT_DIR="/var/www/reports/$TIMESTAMP"
mkdir -p "$REPORT_DIR" || { echo "创建报告目录失败"; exit 1; }

# 运行测试
echo "运行测试..."
python3 -m pytest examples/test_suite.py \
    --dashboard \
    --rs \
    --headless \
    --html=reports/report.html \
    --self-contained-html \
    -v || { echo "测试执行失败"; exit 1; }

# 复制日志和仪表板
cp -r latest_logs/ "$REPORT_DIR/latest_logs" || { echo "复制日志失败"; exit 1; }
cp dashboard.html "$REPORT_DIR/dashboard.html" || { echo "复制仪表板失败"; exit 1; }

echo "测试完成！报告已发布到 $REPORT_DIR"
echo "访问链接: http://www.wiac.xyz/reports/$TIMESTAMP/report.html"

# 安装邮件工具
sudo yum install mailx -y

# 发送邮件
EMAIL="your-email@example.com"
SUBJECT="测试报告生成通知"
BODY="测试完成！报告已发布到 $REPORT_DIR\n访问链接: http://www.wiac.xyz/reports/$TIMESTAMP/report.html"
echo -e "$BODY" | mail -s "$SUBJECT" "$EMAIL"

echo "测试完成！报告已发布到 $REPORT_DIR"
echo "访问链接已发送到 $EMAIL"