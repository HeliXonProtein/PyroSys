pipeline {
    agent any

    environment {
        CONDA_BASE_PREFIX = "$HOME/miniconda3"
        ENV_PREFIX = "$WORKSPACE/env"
        CONDARC = "$WORKSPACE/.condarc"
        PATH = "$ENV_PREFIX/bin:$CONDA_BASE_PREFIX/bin:$PATH"
    }

    stages {
        stage('Build') {
            steps {
                echo 'Begin build stage...'
                sh '.ci/autosetup.sh'
            }
        }
        stage('Code Quality Check') {
            steps {
                sh 'rm -rf reports && mkdir -p reports'
                echo 'Running Ruff checks...'
                sh 'ruff check src --fix --output-format=junit --output-file=reports/ruff-lint.xml'
            }
            post {
                always {
                    junit(
                        testResults: 'reports/ruff-lint.xml',
                        allowEmptyResults: true
                    )
                }
            }
        }
        stage('Auto Formatting') {
            steps {
                echo 'ruff formating...'
                sh 'ruff format . --diff'
            }
        }
        stage('Static Check') {
            steps {
                echo 'Mypy static check...'
                catchError(buildResult: 'UNSTABLE', stageResult: 'UNSTABLE') {
                    sh 'timeout -s SIGKILL 600s mypy src tests > reports/mypy.log'
                }
            }
            post {
                always {
                    recordIssues(
                        qualityGates: [[threshold: 1, type: 'TOTAL', unstable: true]],
                        tools: [myPy(pattern: 'reports/mypy.log')]
                    )
                }
            }
        }
        stage('Unit Test') {
            steps {
                echo 'Unittesting...'
                sh 'pytest --junit-xml=reports/unittest.xml ./tests'
            }
            post {
                always {
                    junit(
                        testResults: 'reports/unittest.xml'
                    )
                }
            }
        }
    }
}