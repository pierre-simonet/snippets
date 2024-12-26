# Working with Gradle dependencies offline

1. Add `flatDir` property in [settings.grade](settings.gradle) :

```groovy
pluginManagement {
  repositories {
    mavenCentral()
    gradlePluginPortal()
    flatDir {
        dirs 'libs'
    }
  }
}
```

2. Create a direcotry `libs` and put jar dependencies inside
