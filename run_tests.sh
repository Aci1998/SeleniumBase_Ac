#!/bin/bash

# 进入代码目录
if [ -d "SeleniumBase_Ac" ]; then
    echo "进入代码目录..."
    cd SeleniumBase_Ac
    echo "更新代码..."
    git pull
else
    echo "拉取代码..."
    git clone https://github.com/Aci1998/SeleniumBase_Ac.git
    cd SeleniumBase_Ac
fi

# 创建虚拟环境
echo "创建虚拟环境..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate

# 安装依赖
echo "安装依赖..."
pip install -r requirements.txt

# 更新 pip 并安装测试工具
echo "更新 pip 并安装测试工具..."
pip install --upgrade pip
pip install pytest pytest-html seleniumbase

# 创建报告目录
TIMESTAMP=$(date +%Y%m%d%H%M%S)
REPORT_DIR="/var/www/reports/$TIMESTAMP"
mkdir -p $REPORT_DIR

# 运行测试
echo "运行测试..."
python3 -m pytest examples/test_suite.py \
    --dashboard \
    --rs \
    --headless \
    --html=$REPORT_DIR/report.html \
    --self-contained-html \
    -v

# 复制日志和仪表板
cp -r latest_logs/ $REPORT_DIR/latest_logs
cp dashboard.html $REPORT_DIR/dashboard.html

echo "测试完成！报告已发布到 $REPORT_DIR"