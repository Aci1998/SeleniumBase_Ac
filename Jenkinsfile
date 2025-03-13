pipeline {
    agent any
    
    stages {
        stage('准备环境') {
            steps {
                echo '准备测试环境...'
                // 确保使用正确的 Python 版本
                sh 'python --version'
                
                // 创建并激活虚拟环境
                sh '''
                    python -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }
        
        stage('运行测试') {
            steps {
                echo '执行自动化测试...'
                // 激活虚拟环境并运行测试
                sh '''
                    . venv/bin/activate
                    cd examples
                    pytest --alluredir=../allure-results
                '''
            }
        }
        
        stage('生成报告') {
            steps {
                echo '生成 Allure 报告...'
                // 生成 Allure 报告
                allure([
                    includeProperties: false,
                    jdk: '',
                    properties: [],
                    reportBuildPolicy: 'ALWAYS',
                    results: [[path: 'allure-results']]
                ])
            }
        }
    }
    
    post {
        always {
            echo '清理环境...'
            // 清理工作区
            cleanWs()
        }
        success {
            script {
                currentBuild.description = "✅ 测试通过"
            }
        }
        failure {
            script {
                currentBuild.description = "❌ 测试失败"
            }
        }
    }
    
    options {
        // 设置构建超时时间
        timeout(time: 1, unit: 'HOURS')
        // 保留最近的构建历史
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
} 