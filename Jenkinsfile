library(
    identifier: 'jenkins-lib-common@1.1.2',
    retriever: modernSCM([
        $class: 'GitSCMSource',
        remote: 'git@github.com:zextras/jenkins-lib-common.git',
        credentialsId: 'jenkins-integration-with-github-account'
    ])
)
String timeStamp = Calendar.getInstance().getTime().format('YYYYMMdd',TimeZone.getTimeZone('CST'))

boolean isBuildingTag() {
    return env.TAG_NAME ? true : false
}

pipeline {
    agent {
        node {
            label 'zextras-v1'
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

        stage('Publish containers') {
            when {
                expression {
                    return isBuildingTag() || env.BRANCH_NAME == 'devel'
                }
            }
            steps {
                container('dind') {
                    withDockerRegistry(credentialsId: 'private-registry', url: 'https://registry.dev.zextras.com') {
                        script {
                            Set<String> tagVersions = []
                            if (isBuildingTag()) {
                                tagVersions = [env.TAG_NAME, 'stable']
                            } else {
                                tagVersions = ['devel', 'latest']
                            }
                            dockerHelper.buildImage([
                                    dockerfile: 'Dockerfile',
                                    imageName : 'registry.dev.zextras.com/dev/carbonio-webui-i18n',
                                    imageTags : tagVersions,
                                    ocLabels  : [
                                            title          : 'Carbonio WebUI Localizations',
                                            description: 'Carbonio WebUI Localizations image',
                                            version        : tagVersions[0]
                                    ],
                                    platforms: ['linux/amd64', 'linux/arm64'],
                                    secrets: [
                                        'ssh_key': '/root/.ssh/id_rsa'
                                    ],
                            ])
                        }
                    }
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
