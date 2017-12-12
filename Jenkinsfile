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
        def exists1 = fileExists 'test-api-incoming-events.log'
        def exists2 = fileExists 'test-api-outgoing-commands.log'
        if (!exists1 && !exists2) {
            sh 'touch test-api-incoming-events.log'
            sh 'touch test-api-outgoing-commands.log'
        }

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
