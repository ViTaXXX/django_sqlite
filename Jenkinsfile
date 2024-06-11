pipeline {
    environment {
        IMAGEN = "andresdocker77/django_icdc"
        LOGIN = 'USER_DOCKERHUB'
    }
    agent none
    stages {
        stage("Imagen") {
            agent {
                docker {
                    image "python:3"
                    args '-u root:root'
                }
            }
            stages {
                stage('repositorio') {
                    steps {
                        git branch: 'v1sqlite', url: 'https://github.com/ViTaXXX/django_sqlite.git'
                    }
                }
                stage('requisitos') {
                    steps {
                        sh 'pip install -r requirements.txt'
                    }
                }
                stage('Test') {
                    steps {
                        sh 'python3 manage.py test'
                    }
                }
            }
        }
        stage("crear_la_imagen") {
            agent any
            stages {
                stage('imagen2') {
                    steps {
                        git branch: 'master', url: 'https://github.com/ViTaXXX/django2jenkins.git'
                    }
                }
                stage('generarimagen') {
                    steps {
                        script {
                            newApp = docker.build "$IMAGEN:latest"
                        }
                    }
                }
                stage('subirla') {
                    steps {
                        script {
                            docker.withRegistry('', LOGIN) {
                                newApp.push()
                            }
                        }
                    }
                }
                stage('eliminarla') {
                    steps {
                        sh "docker rmi $IMAGEN:latest"
                    }
                }
            }
        }
        stage('despliegue') {
            agent any
            steps {
                script {
                    sshagent(credentials: ['SSH_KEY3']) {
                        sh 'ssh -o StrictHostKeyChecking=no andres@rinnegan.fernandezds.es wget https://raw.githubusercontent.com/ViTaXXX/django_sqlite/v1sqlite/docker-compose.yaml -O docker-compose.yaml'
                        sh 'ssh -o StrictHostKeyChecking=no andres@rinnegan.fernandezds.es docker compose up -d --force-recreate'
                    }
                }
            }
        }
    }
}
