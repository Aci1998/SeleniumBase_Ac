pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pytest pytest-html seleniumbase
                '''
            }
        }
        stage('Test') {
            steps {
                sh 'mkdir -p reports'
                sh '. venv/bin/activate && python3 -m pytest examples/test_suite.py --html=reports/report.html --self-contained-html --verbose'
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