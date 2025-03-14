pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                // 安装测试依赖
                sh 'pip3 install pytest pytest-html seleniumbase'
            }
        }
        stage('Test') {
            steps {
                // 执行测试并生成报告
                sh 'mkdir -p reports' // 确保 reports 目录存在
                sh 'python3 -m pytest examples/test_suite.py --html=reports/report.html --self-contained-html --verbose'
            }
        }
        stage('Publish Reports') {
            steps {
                // 归档 HTML 报告
                archiveArtifacts artifacts: 'reports/*.html', fingerprint: true, allowEmptyArchive: false
                // 如果有 JUnit XML 报告，可启用以下步骤（当前无 XML，注释掉）
                // junit 'reports/*.xml'
            }
        }
    }
    post {
        always {
            // 发布 HTML 报告到 Jenkins 界面
            publishHTML target: [
                reportName: 'Test Results',    // 报告名称
                reportDir: 'reports',          // 报告目录
                reportFiles: 'report.html',    // 报告文件
                keepAll: true,                 // 保留所有历史报告
                allowMissing: false,           // 报告不存在时失败
                alwaysLinkToLastBuild: true    // 始终链接到最新构建
            ]

            // 发送邮件通知
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
                replyTo: 'noreply@jenkins.io',
                attachmentsPattern: 'reports/report.html', // 附加报告文件
                mimeType: 'text/html'                     // 支持 HTML 格式邮件
            )
        }
    }
}