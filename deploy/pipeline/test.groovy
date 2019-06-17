#!/usr/bin/env groovy

def call(def pParams) {
  pipeline {
    agent any
    stages {
      stage('Checkout') {
        steps {
          checkout scm
        }
      }
    }
    post {
      always {
        junit '**/build/reports/xunit/xml/*.xml'
      }
    }
  }
}

return this
