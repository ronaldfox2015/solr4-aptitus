#!/usr/bin/env groovy

def myPipeline = evaluate readTrusted("deploy/init.groovy")

myPipeline {
  DEVELOPMENT_ENV = 'dev'
  STAGING_ENV = 'pre'
  PRODUCTION_ENV = 'prod'
}
