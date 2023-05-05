# MavenLocal

This example explain how to share library locally built from a project to another (on the same machine).

<br/>

## Project generating artefact
1. Add this to `repositories` in your `build.gradle` : `mavenLocal()`
2. Generate and publish artefact : `./gradlew clean assemble publishToMavenLocal`

## Project using artefact
1. Add this to `repositories` in your `build.gradle` : `mavenLocal()`
2. Add version to your artefact : `compile 'com.java:MY-ARTEFACT:1.0.0-123456789'`  
If not sure of the version, check version in Manifest inside artefact or in `~/.m2/repository/` folder
3. Rebuild project using : `./gradlew clean assemble`