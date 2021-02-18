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
        stage('Prepare Env') {
            steps {
                PrepareEnv() 
           // sh 'false'    
            }
        }
        stage('Build Env') {
            steps {
                BuildEnv() 
           // sh 'false'    
            }
        }
        stage('Config1 Env') {
            steps {
                Config1Env() 
           // sh 'false'    
            }
        }
        stage('Config2 Env') {
            steps {
                Config2Env() 
           // sh 'false'    
            }
        }
        stage('Remove Env') {
            steps {
                RemoveEnv() 
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
        git branch: 'main', credentialsId: 'f495bb99-db9e-4896-8601-3a171f50d275', url: 'https://github.com/sproutitgithub/test.git'
      } catch(Exception ex) {
         println(ex.message);
         if (ex){
            throw ex
            println ("Failed in Test")
         }
      
      }
		
}


def PrepareEnv() {
    def err = null
    def pspath1 = "${env.WORKSPACE}\\Script-VMM-BuildVDA-Prepare-environment.ps1"
      try {
         echo "About to Launch ${env.WORKSPACE}\\Script-VMM-BuildVDA-Prepare-environment.ps1"
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
/*
def BuildEnv() {
    def err = null
        def pspath2 = "${env.WORKSPACE}\\Script-VMM-BuildVDA-Build-Environment.ps1"
      try {
         echo "About to Launch ${env.WORKSPACE}\\Script-VMM-BuildVDA-Build-Environment.ps1"
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
		
def Config1Env() {
    def err = null
        def pspath3 = "${env.WORKSPACE}\\Script-VMM-BuildVDA-Configure-environment-Step1.ps1"
      try {
         echo "About to Launch ${env.WORKSPACE}\\Script-VMM-BuildVDA-Configure-environment-Step1.ps1"
         sleep 2
     powershell pspath3
      } catch(Exception ex) {
         println(ex.message);
         if (ex){
            throw ex
            println ("Failed in config1")
         }
      
      }
}

def Config2Env() {
    def err = null
        def pspath4 = "${env.WORKSPACE}\\Script-VMM-BuildVDA-Configure-environment-Step2.ps1"
      try {
         echo "About to Launch ${env.WORKSPACE}\\Script-VMM-BuildVDA-Configure-environment-Step2.ps1"
         sleep 2
     powershell pspath4
      } catch(Exception ex) {
         println(ex.message);
         if (ex){
            throw ex
            println ("Failed in config2")
         }
      
      }
}

def RemoveEnv() {
    def err = null
        def pspath5 = "${env.WORKSPACE}\\Script-VMM-BuildVDA-Remove-environment.ps1"
      try {
         echo "About to Launch ${env.WORKSPACE}\\Script-VMM-BuildVDA-Remove-environment.ps1"
         sleep 2
     powershell pspath5
      } catch(Exception ex) {
         println(ex.message);
         if (ex){
            throw ex
            println ("Failed in Remove")
         }
      
      }
}
*/