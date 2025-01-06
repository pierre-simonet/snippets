# Working with Gradle dependencies offline

On the computer **with** internet :
1. Delete `~/.gradle/caches` folder
2. Compile project `./gradlew clean build`
3. Compress `caches` folder

On the computer **without** internet :
1. Delete `~/.gradle/caches` folder
2. Copy `caches` compressed folder and uncompress it to `~/.gradle/caches`
2. Compile project `./gradlew clean build`