#!/usr/bin/env groovy#!/usr/bin/env groovy

def call(body) {
  // evaluate the body block, and collect configuration into the object
  def pipelineParams = [:]
  body.resolveStrategy = Closure.DELEGATE_FIRST
  body.delegate = pipelineParams
  body()

  def pipelineScript = null

  // Validate is pull-request
  if (env.CHANGE_ID == null) {
    pipelineScript = evaluate readTrusted("deploy/pipeline/deploy.groovy")
  } else {
    pipelineScript = evaluate readTrusted("deploy/pipeline/test.groovy")
  }

  pipelineScript(pipelineParams)
}

return this
