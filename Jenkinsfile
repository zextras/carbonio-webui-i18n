library(
    identifier: 'jenkins-lib-common@v2.11.2',
    retriever: modernSCM([
        $class: 'GitSCMSource',
        remote: 'git@github.com:zextras/jenkins-lib-common.git',
        credentialsId: 'jenkins-integration-with-github-account'
    ])
)

properties(defaultPipelineProperties())

pipeline {
    agent {
        node {
            label 'zextras-v1'
        }
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        disableConcurrentBuilds()
        overrideIndexTriggers(false)
        skipDefaultCheckout()
        timeout(time: 1, unit: 'HOURS')
    }

    parameters {
        booleanParam(
            defaultValue: false,
            description: 'Whether to upload the packages in playground repositories',
            name: 'PLAYGROUND'
        )
    }

    stages {
        stage('Setup') {
            steps {
                checkout scm
                script {
                    env.VERSION = env.TAG_NAME ? env.TAG_NAME.replaceAll('^v', '') : '0.0.0'
                }
                gitMetadata()
            }
        }

        stage('Skip CI') {
            steps {
                script { semanticRelease.guard() }
            }
        }

        stage('Security Scan') {
            steps { gitleaksStage() }
        }

        stage('Publish containers - devel') {
            when {
                anyOf {
                    branch 'main'
                    buildingTag()
                }
            }
            steps {
                dockerStage([
                    dockerfile: 'Dockerfile',
                    imageName: 'registry.dev.zextras.com/dev/carbonio-webui-i18n',
                    ocLabels: [
                        title      : 'Carbonio WebUI Localizations',
                        description: 'Carbonio WebUI Localizations image',
                    ],
                    platforms: ['linux/amd64', 'linux/arm64'],
                    secrets: [
                        'ssh_key': '/root/.ssh/id_rsa'
                    ],
                ])
            }
        }

        stage('Build deb/rpm') {
            steps {
                echo 'Building deb/rpm packages'
                buildStage([
                    buildFlags: "-s -w ${env.VERSION}",
                    rockySinglePkg: true,
                    skipTsOverride: true,
                    ubuntuSinglePkg: true,
                ])
            }
        }

        stage('Upload artifacts') {
            tools {
                jfrog 'jfrog-cli'
            }
            steps {
                uploadStage(
                    rockySinglePkg: true,
                    ubuntuSinglePkg: true,
                )
            }
        }

        stage('Semantic Release') {
            steps {
                semanticRelease()
            }
        }
    }
}
