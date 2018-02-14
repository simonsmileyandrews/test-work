Android Project Setup
=====================

##Setup Android Studio project

1. Create a new directory for your project workspace on your machine
2. Move into the directory you just created
3. Clone this project in the current dir

		git clone git@bitbucket.org:outware/omprojectkotlin-android.git .

4. Remove all git tracking from the project

		rm -rf .git

5. Push content of current folder to your BitBucket project repo

		git init
		git remote add origin git@bitbucket.org:outware/<your-repo-name-here>.git

6. Add local repository to SourceTree (If you want)
7. Commit
8. Push!

##Create signing key

1. Create a signing key using the following command, replacing {app name} with the name of your project. Use the same password for both the keystore and the alias

		keytool -genkey -v -keystore {app name}.keystore -alias production -keyalg RSA -keysize 2048 -validity 10000
		
2. Give this signing key and the details for it to the team lead, who will then upload it to the signing service. The key details should be in the format of 

		{app name}.keystore:
    		alias:      production
    		password:   {password}

##Setup HockeyApp

1. Get a team lead to create an entry for your app in HockeyApp and give you the API key
2. Update the applications build.gradle to include the keystore name and HockeyApp API key
		
		ext {
		    ...
		    keyStore = 'Put your key store name here'
		    hockeyAppToken = "Put your token here"
		    ...
		}
		
##Setup Jenkins with Docker

1. Edit the `docker/android-docker-ec2-host.sh` file replacing the Docker image name `IMAGE_BASE_NAME` with the project name and platform (eg. `link-miraqle-android`)

2. Edit the `docker/Dockerfile` file to download and install only the required SDKs, build tools and libraries. Delete the non required dependency lines.

3. Ask a team lead or dev-ops to setup the Dev, OMQA and DropClient Jenkins jobs.

4. Configure all three Jenkins jobs to match the OM Project Kotlin [Jenkins job configuration](https://ci.omdev.io/job/OMProjectkotlin-Android-Dev/configure).

5. On the Dev Jenkins job configuration enable the following lines and save the configuration for the first build in order to build the container:

        # Enable these lines to re-build Docker container
        #cd docker
        #bash ./android-docker-ec2-host.sh -r
        #cd ../
        
6. If the build is successful comment out the previously de-commented lines and save the configuration.

###Common Issues

####Non executable scripts

If the build fails with an issue similar to the following, one or more of the scripts may be not executable.

        docker: Error response from daemon: oci runtime error: container_linux.go:247: starting container process caused "exec: \"/usr/local/bin/entrypoint.sh\": permission denied"
        
Try to run in the root folder of your workspace:

        chmod +x local-docker-build.sh
        cd docker
        chmod +x android-docker-ec2-host.sh
        chmod +x entrypoint.sh
        
This should make all scripts executable.

##Setup tests

Create a new unit test run configuration:

1. In Android Studio open `Edit Configurations...` next to the Run action

2. Define the configuration name, eg. `tests`

3. Add a new configuration of type `Android JUnit`

4. Select test kind `All in package`

5. Specify app package name

6. Save configuration

**Note:** To simplify testing of Kotlin final classes and methods the project is configured to use a Mockito experimental feature that allows to mock final classes and methods. This feature is enabled in the `org.mockito.plugins.MockMaker` resources file. More details on the [Mockito Wiki](https://github.com/mockito/mockito/wiki/What%27s-new-in-Mockito-2).