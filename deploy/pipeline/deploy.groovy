#!/usr/bin/env groovy

def call(def pParams) {
    def fnSteps = evaluate readTrusted("deploy/scripts/steps.groovy")
    def fnSlack = evaluate readTrusted("deploy/scripts/slack.groovy")

    pipeline {
        agent any
        options {
            disableConcurrentBuilds()
        }
        environment {
            DEVELOPMENT_ENV = 'dev'
            STAGING_ENV = 'pre'
            PRODUCTION_ENV = 'prod'
        }
        parameters {
            booleanParam(name: 'DEVELOPMENT', defaultValue: true, description: "Ejecutar Development")
            booleanParam(name: 'STAGING', defaultValue: false, description: "Ejecutar Staging")
            booleanParam(name: 'PRODUCTION', defaultValue: false, description: "Ejecutar Production")
            choice(
                name: 'EXECUTE',
                choices:"DEPLOY\nROLLBACK\nREGISTRY",
                description: '''DEPLOY: Se realiza deploy del servicio
                ROLLBACK: Rollback de la última migración
                REGISTRY: Requiere construir o no Registry en ECR'''
            )
        }
        stages {
            //Checkout
            stage('Checkout') {
                steps {
                    script {
                        wrap([$class: 'BuildUser']) {
                          BUILD_USER_ID = (env.BUILD_USER_ID) ? BUILD_USER_ID: ''
                        }
                    }
                }
            }

            /* #################### Development #################### */
            stage('Development Config') {
                when {
                    expression { return params.DEVELOPMENT }
                }
                steps {
                    script {
                        config = fnSteps.configs(DEVELOPMENT_ENV)
                        fnSlack.start(config)
                    }
                }
            }
            stage('Development') {
                when { expression { return params.DEVELOPMENT } }
                parallel {
                    stage('Deploy') {
                        when { expression { return params.EXECUTE == 'DEPLOY' } }
                        steps { script { fnSteps.deploy(config) } }
                    }
                }
            }

            /* #################### Staging #################### */
            stage('Staging Config') {
                when { expression { return params.STAGING } }
                stages {
                    stage('Config') {
                        steps {
                            script {
                                config = fnSteps.configs(STAGING_ENV)
                                userFound = config.ALLOWED_USERS.split(',').find { item -> item == BUILD_USER_ID }
                            }
                        }
                    }
                    stage('Validate') {
                        when {
                            expression { return userFound == null }
                        }
                        steps {
                            script {
                                input (message: "Continue deployment to Staging?", submitter: "${config.ALLOWED_USERS}")
                                fnSlack.start(config)
                            }
                        }
                    }
                }
            }
            stage('Staging') {
                when { expression { return params.STAGING } }
                parallel {
                    stage('Deploy') {
                        when { expression { return params.EXECUTE == 'DEPLOY' } }
                        steps { script { fnSteps.deploy(config) } }
                    }
                }
            }

            /* #################### Production #################### */
            stage('Production Config') {
                when { expression { return params.PRODUCTION } }
                stages {
                  stage('Config') {
                    steps {
                      script {
                        config = fnSteps.configs(PRODUCTION_ENV)
                        userFound = config.ALLOWED_USERS.split(',').find { item -> item == BUILD_USER_ID }
                      }
                    }
                  }
                  stage('Validate') {
                    when {
                        expression { return userFound == null }
                    }
                    steps {
                        script {
                            input (message: "Continue deployment to Production?", submitter: "${config.ALLOWED_USERS}")
                            fnSlack.start(config)
                        }
                    }
                  }
                }
            }
            stage('Production') {
                when { expression { return params.PRODUCTION } }
                parallel {
                    stage('Deploy') {
                        when { expression { return params.EXECUTE == 'DEPLOY' } }
                        steps { script { fnSteps.deploy(config) } }
                    }
                }
            }
        }
        post {
            success { script { fnSlack.success(config) } }
            failure { script { fnSlack.failure(config) } }
            aborted { script { fnSlack.abort(config) } }
            always { cleanWs() }
        }
    }
}
return this