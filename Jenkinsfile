pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                // 拉取代码，确保 examples/test_suite.py 存在
                git url: 'https://github.com/Aci1998/SeleniumBase_Ac.git', branch: 'master'
            }
        }
        stage('Build') {
            steps {
                sh '''
                    # 创建并激活虚拟环境
                    python3 -m venv venv
                    . venv/bin/activate

                    # 安装 requirements.txt 中的依赖（若存在）
                    if [ -f requirements.txt ]; then
                        pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt
                    else
                        pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pytest pytest-html seleniumbase
                    fi
                '''
            }
        }
        stage('Test') {
            steps {
                sh '''
                    # 确保在 $WORKSPACE 下操作（默认已是）
                    mkdir -p reports

                    # 激活虚拟环境并运行测试
                    . venv/bin/activate
                    python3 -m pytest examples/test_suite.py --html=reports/report.html --self-contained-html --verbose
                '''
            }
        }
        stage('Publish Reports') {
            steps {
                archiveArtifacts artifacts: 'reports/*.html', fingerprint: true, allowEmptyArchive: false
            }
        }
    }
    post {
        always {
            publishHTML target: [
                reportName: 'Test Results',
                reportDir: 'reports',
                reportFiles: 'report.html',
                keepAll: true,
                allowMissing: false,
                alwaysLinkToLastBuild: true
            ]
            emailext (
                subject: "Jenkins Build ${currentBuild.fullDisplayName}",
                body: """\
                    Build: ${currentBuild.fullDisplayName}
                    Status: ${currentBuild.currentResult}
                    Check the test report here:
                    ${env.BUILD_URL}htmlreports/Test_20Results/report.html
                    Console output:
                    ${env.BUILD_URL}console
                    Best Regards,
                    Jenkins
                """,
                to: 'imacaiy@outlook.com',
                replyTo: 'imacaiy@outlook.com',
                attachmentsPattern: 'reports/report.html',
                mimeType: 'text/html'
            )
        }
    }
}