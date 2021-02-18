pipeline {
    agent any

    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
                echo "${env.WORKSPACE}"
            }
        }
        stage('Pull Git') {
            steps {
                PullGit()
            }
        }
        stage('Test Env') {
            steps {
                TestEnv() 
           // sh 'false'    
            }
        }
        stage('Build Env') {
            steps {
                BuildEnv() 
           // sh 'false'    
            }
        }
    }
}

// steps
// steps
def PullGit() {
    def err = null
      try {
        //git branch: 'main', credentialsId: 'fdf49ef4-7dfa-4564-b864-de29c2555d28', url: 'https://github.com/sidlocal5269/jenkinsProjects.git'
        git branch: 'main', credentialsId: '91d5fd22-255c-436f-9a6d-2a221f3555a1', url: 'https://github.com/sidlocal5269/jenkinsProjects.git'
      } catch(Exception ex) {
         println(ex.message);
         if (ex){
            throw ex
            println ("Failed in Test")
         }
      
      }
		
}


def TestEnv() {
    def err = null
    def pspath1 = "${env.WORKSPACE}\\testenv.ps1"
      try {
         echo "About to Launch ${env.WORKSPACE}\\testenv.ps1"
         sleep 2
        powershell pspath1
      } catch(Exception ex) {
         println(ex.message);
         if (ex){
            throw ex
            println ("Failed in Test")
         }
      
      }
		
}

def BuildEnv() {
    def err = null
        def pspath2 = "${env.WORKSPACE}\\Buildenv.ps1"
      try {
         echo "About to Launch ${env.WORKSPACE}\\BuildEvenv.ps1"
         sleep 2
     powershell pspath2
      } catch(Exception ex) {
         println(ex.message);
         if (ex){
            throw ex
            println ("Failed in Build")
         }
      
      }
}
		
