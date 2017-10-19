def buildVersion = ''
def mvnArgs = ''

pipeline {
  agent {
    dockerfile {
      label 'docker'
    }
  }

  stages {
    stage('Checkout') {
      steps{
        checkout scm

        script {
          def shortCommit = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
          echo "COMMIT: $shortCommit"

          def pom = readMavenPom file: 'pom.xml'
          buildVersion = "${pom.version}.AS${BUILD_ID}-${BRANCH_NAME}"
          echo "BUILD VERSION: ${buildVersion}"

          currentBuild.displayName = "${buildVersion}/${shortCommit}"
        }
      }
    }

    stage('Build') {
      steps {
        sh "/bin/bash make-atscale-hive.sh --build-version ${buildVersion}"
      }
    }

    stage('Upload to artifactory') {
      steps {
        script {
        def server = Artifactory.server('465784344@1383874667549')

        def uploadSpec = """{
          "files": [
            {
              "pattern": "packaging/target/apache-hive-${buildVersion}-bin.tar.gz",
              "target": "ext-packages/hive/"
            }
          ]
          }"""
        server.upload(uploadSpec)
        }
      }
    }
  }
}
