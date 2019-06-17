def start(def config) {
  sh 'git log HEAD^..HEAD --pretty="%h %an - %s" > GIT_CHANGES'
  def lastChanges = readFile('GIT_CHANGES')
  slackSend (channel: "${config.CHANNEL_SLACK}",color: "#FFFF00", message: "Started `${env.JOB_NAME} Build#${env.BUILD_NUMBER}`\n\n_The changes:_\n${lastChanges} <${env.RUN_DISPLAY_URL}|Open in Jenkins>")
}

def success(def config) {
  slackSend (channel: "${config.CHANNEL_SLACK}",color: "good", message: ":+1::grinning: SUCCESSFUL: Job : `${env.JOB_NAME}#${env.BUILD_NUMBER}` <${env.RUN_DISPLAY_URL}|Open in Jenkins>")
}

def failure(def config) {
  slackSend (channel: "${config.CHANNEL_SLACK}",color: 'warning', message: ":-1::face_with_head_bandage: FAILED: Job `${env.JOB_NAME}#${env.BUILD_NUMBER}` <${env.RUN_DISPLAY_URL}|Open in Jenkins>")
}

def abort(def config) {
  slackSend (channel: "${config.CHANNEL_SLACK}",color: '#BBBBBB', message: ":man-shrugging: ABORTED: Job `${env.JOB_NAME}#${env.BUILD_NUMBER}` <${env.RUN_DISPLAY_URL}|Open in Jenkins>")
}

return this
