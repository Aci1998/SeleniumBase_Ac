pipeline {
    agent any
    
    options {
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
    
    stages {
        stage('准备环境') {
            steps {
                // 拉取代码
                git url: 'https://github.com/Aci1998/SeleniumBase_Ac.git', branch: 'master'
                
                // 创建虚拟环境并安装依赖
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip
                    pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt || \
                    pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pytest pytest-html seleniumbase
                '''
            }
        }
        
        stage('执行测试') {
            steps {
                // 创建报告目录并运行测试
                sh '''
                    mkdir -p reports
                    . venv/bin/activate
                    python3 -m pytest examples/test_suite.py --html=reports/report.html --self-contained-html -v
                '''
                
                // 归档测试报告
                archiveArtifacts artifacts: 'reports/*.html', fingerprint: true
                publishHTML target: [
                    reportName: '测试报告',
                    reportDir: 'reports',
                    reportFiles: 'report.html',
                    keepAll: true,
                    alwaysLinkToLastBuild: true
                ]
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
                    <p><a href="${env.BUILD_URL}htmlreports/测试报告/report.html">查看测试报告</a></p>
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
