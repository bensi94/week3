node {
    checkout scm
    stage('Clean') {
        // Clean files from last build.
        sh 'git clean -dfxq'
        sh 'docker kill $(docker ps -q) || true'
        sh 'docker rm $(docker ps -a -q)|| true'
        sh 'docker rmi $(docker images -q) || true'
    }
    stage('Instalize') {
        echo 'Instantizing..'
        sh 'yarn install'
        dir('client') {
            sh 'yarn install'
        }
        sh 'yarn add jasmine-reporters'
    }
    stage('Test') {
        sh 'npm run startpostgres && sleep 10 && npm run migratedb:dev'
        sh 'npm run test:nowatch'
        dir('client') {
            sh 'npm run test:nowatch'
        }
        sh 'npm run startserver:ci & npm run apitest:nowatch && npm run loadtest:nowatch && sleep 10 && kill $!'
        junit '**/TestsResults/*.xml'
    }

    stage('Build'){
        sh 'docker stop $(docker ps -a -q) || true'
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
