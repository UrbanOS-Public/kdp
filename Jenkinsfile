library(
    identifier: 'pipeline-lib@4.5.0',
    retriever: modernSCM([$class: 'GitSCMSource',
                          remote: 'https://github.com/SmartColumbusOS/pipeline-lib',
                          credentialsId: 'jenkins-github-user'])
)

properties([
    pipelineTriggers([scos.dailyBuildTrigger()]),
])

def image
def doStageIf = scos.&doStageIf
def doStageIfRelease = doStageIf.curry(scos.changeset.isRelease)
def doStageUnlessRelease = doStageIf.curry(!scos.changeset.isRelease)
def doStageIfPromoted = doStageIf.curry(scos.changeset.isMaster)

node ('infrastructure') {
    ansiColor('xterm') {
        scos.doCheckoutStage()

        imageTag = "${env.GIT_COMMIT_HASH}"
        images = ["hive", "metastore", "presto", "spark"]

        doStageUnlessRelease('Build') {
            images.each {
                dir("images/${it}") {
                    image = docker.build("scos/${it}:${imageTag}")
                    scos.withDockerRegistry {
                        image.push()
                        image.push('latest')
                    }
                }
            }
        }

        doStageUnlessRelease('Deploy to Dev') {
            deployTo(environment: 'dev', tag: imageTag, internal: true)
        }

        doStageIfPromoted('Deploy to Staging')  {
            def environment = 'staging'

            deployTo(environment: environment, tag: imageTag, internal: true)

            scos.applyAndPushGitHubTag(environment)

            scos.withDockerRegistry {
                images.each {
                    image = scos.pullImageFromDockerRegistry("scos/${it}", imageTag)
                    image.push(environment)
                }
            }
        }

        doStageIfRelease('Deploy to Production') {
            def releaseTag = env.BRANCH_NAME
            def promotionTag = 'prod'

            deployTo(environment: 'prod', tag: imageTag, internal: false)

            scos.applyAndPushGitHubTag(promotionTag)

            scos.withDockerRegistry {
                images.each {
                    image = scos.pullImageFromDockerRegistry("scos/${it}", imageTag)
                    image.push(releaseTag)
                    image.push(promotionTag)
                }
            }
        }
    }
}

def deployTo(params = [:]) {
    dir('terraform') {
        def extraVars = [
            'image_tag': params.get('tag'),
            'is_internal': params.get('internal')
        ]
        def environment = params.get('environment')
        if (environment == null) throw new IllegalArgumentException("environment must be specified")

        def terraform = scos.terraform(environment)
        terraform.init()
        terraform.plan(terraform.defaultVarFile, extraVars)
        terraform.apply()
    }
}
