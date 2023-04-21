# Setup Logback

This Logback example provide `console` and `file` (daily rotated) appenders.

<br/>

## XML configuration file example
[logback.xml](logback.xml)

<br/>

## Environment variables
`Logback` configuration file need to be defined in `JAVA_OPTS` environment variable.  
Default `Log level` is `INFO`, it can be changed using environment variable `LOGBACK_LOG_LEVEL`.  
i.e. :
```bash
export LOGBACK_LOG_LEVEL=DEBUG
export JAVA_OPTS=-Dlogback.configurationFile=/my-path/my-app/logback.xml
```

## Java example
```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Test {

    private static final Logger LOGGER = LoggerFactory.getLogger(RestTerminalContext.class);
    
    public static void main(String[] args) {
        LOGGER.info("This is an info");
        LOGGER.error("This is an error");
    }
}
```

## Gradle dependencies
Add these dependencies to your build.gradle :
```groovy
implementation 'org.slf4j:slf4j-api:X.X.X'
implementation 'ch.qos.logback:logback-classic:X.X.X'
```