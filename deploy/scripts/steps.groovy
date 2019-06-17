def deploy(def config) {
  withEnv(config.withEnv) {
    sh 'make start-solr'
  }
}

def rollback(def config) {
  withEnv(config.withEnv) {
    sh 'make install'
  }
}

def configs(def enviroment) {
  def envConfig = [
    "ENV=${enviroment}",
    "INFRA_BUCKET=infraestructura.${enviroment}"
  ]

  withEnv(envConfig) {
    sh "make sync-config-deploy"
  }

  configFile = readYaml file: 'deploy/jenkins.private.yml'
  config = configFile.params

  config.withEnv = [
    "ENV=${config.ENV}",
    "DEPLOY_REGION=${config.DEPLOY_REGION}",
    "BRANCH=${config.BRANCH}",
    "SOLR_HOST=${config.SOLR_HOST}",
    "SOLR_PORT=${config.SOLR_PORT}",
    "SOLR_DATABASE=${config.SOLR_DATABASE}",
    "SOLR_DBUSER=${config.SOLR_DBUSER}",
    "SOLR_DBPASSWORD=${config.SOLR_DBPASSWORD}",
    "INFRA_BUCKET=${config.INFRA_BUCKET}",
  ]

  return config
}

return this
