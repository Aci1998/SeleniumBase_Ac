pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '30'))
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    echo '清空工作区并拉取代码'
                    git(
                        url: 'https://github.com/Aci1998/SeleniumBase_Ac.git',
                        credentialsId: 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKZrTo4rmz6wKmzbeTrRhsAilHlaXF0GCKCwRZORJssM',
                        branch: 'master',
                        extensions: [
                            [$class: 'CloneOption',
                             depth: 1,
                             noTags: true,
                             shallow: true,
                             timeout: 30],
                            [$class: 'GitLFSPull']
                        ]
                    )

                    echo '验证文件是否存在'
                    sh 'ls -l ${WORKSPACE}/run_tests.sh'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo '赋予执行权限并运行脚本'
                    sh '''
                        chmod +x ${WORKSPACE}/run_tests.sh
                        ${WORKSPACE}/run_tests.sh
                    '''
                }
            }
        }

        stage('Publish Report') {
            steps {
                script {
                    echo '获取时间戳（假设脚本中导出 TIMESTAMP 变量）'
                    def TIMESTAMP = sh(
                        script: 'date +%Y%m%d%H%M%S',
                        returnStdout: true
                    ).trim()

                    echo '发布 HTML 报告到 Jenkins 界面'
                    publishHTML(
                        target: [
                            reportDir: '/var/www/reports/${TIMESTAMP}',
                            reportFiles: 'report.html',
                            reportName: 'HTML Report'
                        ]
                    )

                    echo '输出外部访问链接'
                    echo "外部访问链接: http://www.wiac.xyz/reports/${TIMESTAMP}/report.html"
                }
            }
        }
    }

    post {
        always {
            emailext (
                subject: "测试报告生成通知 - ${env.JOB_NAME} - Build #${env.BUILD_NUMBER}",
                body: """
                    <p>构建号: ${env.BUILD_NUMBER}</p>
                    <p>状态: ${currentBuild.currentResult}</p>
                    <p>Jenkins 报告: <a href="${env.BUILD_URL}HTML_Report/">查看报告</a></p>
                    <p>外部访问链接: <a href="http://www.wiac.xyz/reports/${env.TIMESTAMP}/report.html">Nginx 报告链接</a></p>
                """,
                to: 'imacaiy@outlook.com',
                mimeType: 'text/html'
            )
        }
    }
}