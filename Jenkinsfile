node {
    checkout scm
    stage('Clean') {
        // Clean files from last build.
        sh 'git clean -dfxq'
    }
    stage('Instalize') {
        echo 'Instantizing..'
        sh 'yarn install'
        sh 'npm run startpostgres && sleep 10 && npm run migratedb:dev'
        dir('client') {
            sh 'yarn install'
        }
    }
    stage('Test') {
        sh 'npm run test:nowatch'
        dir('client') {
            sh 'npm run test:nowatch'
        }
        sh 'docker stop $(docker ps -a -q)'
    }
    stage('Build'){
        withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USER')]) {
            sh 'docker login -u $DOCKER_USER -p $DOCKER_PASSWORD'
            sh './dockerbuild.sh'
        }
    }

    stage('Deploy') {
        dir('provisioning') {
            sh './deploy.sh'
        }
    }
}
