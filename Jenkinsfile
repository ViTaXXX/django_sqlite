pipeline {
    environment {
        LOGIN = 'USER_DOCKERHUB'
        SSH_CREDENTIALS_ID = 'SSH_KEY3'
    }
    agent any
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
                stage('Requisitos') {
                    steps {
                        sh 'pip install -r requirements.txt'
                    }
                }
                stage('Test') {
                    steps {
                        sh 'python manage.py test'
                    }
                }
            }
        }
        stage("Crear_la_imagen") {
            stages {
                stage('Construir_imagen') {
                    steps {
                        script {
                            newApp = docker.build("andresdocker77/django_icdc:latest", "--no-cache .")
                        }
                    }
                }
                stage('Subirla') {
                    steps {
                        script {
                            docker.withRegistry('', LOGIN) {
                                newApp.push()
                            }
                        }
                    }
                }
                stage('Borrarla') {
                    steps {
                        sh "docker rmi andresdocker77/django_icdc:latest"
                    }
                }
            }
        }
        stage("Desplegar") {
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
