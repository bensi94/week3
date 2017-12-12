node {
    checkout scm
    stage('Clean') {
        // Clean files from last build.
        sh 'git clean -dfxq'
        sh 'docker kill $(docker ps -q)'
        sh 'docker rm $(docker ps -a -q)'
        sh 'docker rmi $(docker images -q)'
    }
    stage('Instalize') {
        echo 'Instantizing..'
        sh 'yarn install'
        dir('client') {
            sh 'yarn install'
        }
    }
    stage('Test') {
        sh 'npm run startpostgres && sleep 10 && npm run migratedb:dev'
        sh 'npm run test:nowatch'
        dir('client') {
            sh 'npm run test:nowatch'
        }
        sh 'npm run apitest:nowatch'
        sh 'npm run loadtest:nowatch'
    }

    stage('Build'){
        sh 'docker stop $(docker ps -a -q)'
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
