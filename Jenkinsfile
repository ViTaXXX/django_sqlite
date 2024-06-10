pipeline {
    environment {
        LOGIN = 'USER_DOCKERHUB'
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
            agent any
            stages {
                stage('Construir_imagen') {
                    steps {
                        script {
                            newApp = docker.build("andresdocker77/django_icdc:latest")
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
    }
}
