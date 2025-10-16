library(
    identifier: 'jenkins-packages-build-library@1.0.4',
    retriever: modernSCM([
        $class: 'GitSCMSource',
        remote: 'git@github.com:zextras/jenkins-packages-build-library.git',
        credentialsId: 'jenkins-integration-with-github-account'
    ])
)
String timeStamp = Calendar.getInstance().getTime().format('YYYYMMdd',TimeZone.getTimeZone('CST'))

pipeline {
    agent {
        node {
            label 'base'
        }
    }
    
    environment {
        VERSION="${timeStamp}"
    }

    options {
        skipDefaultCheckout()
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 1, unit: 'HOURS')
    }
    
    parameters {
        booleanParam defaultValue: false,
        description: 'Whether to upload the packages in playground repositories',
        name: 'PLAYGROUND'
    }

    tools {
        jfrog 'jfrog-cli'
    }

    triggers {
	    cron(env.BRANCH_NAME == 'devel' ? '0 19 * * 1-5' : '')
    }

    stages {
        stage('Checkout & Stash') {
            steps {
                checkout scm
                script {
                    gitMetadata()
                }
            }
        }

        stage('Build deb/rpm') {
            steps {
                echo 'Building deb/rpm packages'
                buildStage([
                    buildFlags: '-s',
                    rockySinglePkg: true,
                    ubuntuSinglePkg: true,
                ])
            }
        }

        stage('Upload artifacts')
        {
            steps {
                uploadStage(
                    packages: yapHelper.getPackageNames(),
                    rockySinglePkg: true,
                    ubuntuSinglePkg: true,
                )
            }
        }
    }
}
