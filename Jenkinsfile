library(
    identifier: 'jenkins-lib-common@v2.11.2',
    retriever: modernSCM([
        $class: 'GitSCMSource',
        remote: 'git@github.com:zextras/jenkins-lib-common.git',
        credentialsId: 'jenkins-integration-with-github-account'
    ])
)

pipeline {
    agent {
        node {
            label 'zextras-v1'
        }
    }

    options {
        skipDefaultCheckout()
        timeout(time: 1, unit: 'HOURS')
        overrideIndexTriggers(false)
    }

    tools {
        jfrog 'jfrog-cli'
    }

    stages {
        stage('Setup') {
            steps {
                checkout scm
                script {
                    env.VERSION = Calendar.getInstance().getTime().format('YYYYMMdd', TimeZone.getTimeZone('UTC'))
                    gitMetadata()
                    // Merge library properties with custom properties
                    properties(
                        defaultPipelineProperties() + [
                            buildDiscarder(logRotator(numToKeepStr: '5')),
                            parameters([
                                booleanParam(
                                    defaultValue: false,
                                    description: 'Whether to upload the packages in playground repositories',
                                    name: 'PLAYGROUND'
                                )
                            ]),
                            pipelineTriggers([
                                cron(env.BRANCH_NAME == 'devel' ? '0 19 * * 1-5' : '')
                            ])
                        ]
                    )
                }
            }
        }

        stage('Publish containers - devel') {
            when {
                anyOf {
                    branch 'devel'
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
            when {
                anyOf {
                    branch 'devel'
                    buildingTag()
                }
            }
            steps {
                uploadStage(
                    packages: yapHelper.resolvePackageNames(),
                    rockySinglePkg: true,
                    ubuntuSinglePkg: true,
                )
            }
        }
    }
}
