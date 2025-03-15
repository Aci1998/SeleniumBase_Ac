pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '30'))
    }

    stages {
        stage('开始准备环境') {
            steps {
                echo '开始拉取代码'
                git url: 'https://github.com/Aci1998/SeleniumBase_Ac.git', branch: 'master'

                echo '获取当前目录信息'
                sh 'pwd'
                echo "当前工作目录 (通过环境变量): ${env.WORKSPACE}"

                echo '打印当前目录结构'
                sh 'ls -l'

                echo '开始创建虚拟环境并安装依赖'
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install -r requirements.txt
                '''

                echo '开始更新pip'
                sh 'pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip'

                echo '开始安装 pytest pytest-html seleniumbase'
                sh 'pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pytest pytest-html seleniumbase'

                echo '*** SeleniumBase环境安装完成！ ***'
            }
        }

        stage('开始执行测试') {
            steps {
                echo '开始运行测试并生成报告'
                sh '''
                    mkdir -p reports
                    . venv/bin/activate
                    python3 -m pytest examples/test_suite.py \
                        --dashboard \
                        --rs \
                        --headless \
                        --html=reports/report.html \
                        --self-contained-html \
                        -v
                '''
            }
        }

        stage('归档测试报告') {
            steps {
                echo '将报告复制到 Nginx 目录'
                sh '''
                    mkdir -p /var/www/reports/${BUILD_NUMBER}
                    cp reports/report.html /var/www/reports/${BUILD_NUMBER}/report.html
                '''
            }
        }
    }

    post {
        always {
            // 发送邮件通知
            emailext (
                subject: "测试结果: ${currentBuild.fullDisplayName} - ${currentBuild.currentResult}",
                body: """
                    <p>构建: ${currentBuild.fullDisplayName}</p>
                    <p>状态: ${currentBuild.currentResult}</p>
                    <p><a href="http://www.wiac.xyz/reports/${BUILD_NUMBER}/report.html">查看测试报告</a></p>
                    <p><a href="${env.BUILD_URL}console">查看控制台输出</a></p>
                """,
                to: 'imacaiy@outlook.com',
                replyTo: 'imacaiy@outlook.com',
                mimeType: 'text/html'
            )

            // 清理工作区
            cleanWs()
        }
    }
}