pipeline {
    agent any
    
    stages {
        stage('准备环境') {
            steps {
                echo '准备测试环境...'
                // 使用 python3 命令代替 python
                sh 'which python3 || echo "Python3 not found"'
                sh 'python3 --version || echo "Python3 version command failed"'
                
                // 创建并激活虚拟环境
                sh '''
                    python3 -m venv venv || echo "Creating venv failed"
                    . venv/bin/activate
                    pip3 install --upgrade pip
                    pip3 install -r requirements.txt
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
                    python3 -m pytest --alluredir=../allure-results
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
