import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.mat_sjekk"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.ebors.matsjekk"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["huaweiAppId"] = ""
    }

    flavorDimensions += "store"
    productFlavors {
        create("play") {
            dimension = "store"
            isDefault = true
        }
        create("huawei") {
            dimension = "store"
            val huaweiProperties = Properties()
            val huaweiPropertiesFile = rootProject.file("huawei.properties")
            if (huaweiPropertiesFile.exists()) {
                huaweiProperties.load(FileInputStream(huaweiPropertiesFile))
            }
            val huaweiAppId = huaweiProperties.getProperty("appId") ?: ""
            manifestPlaceholders["huaweiAppId"] = huaweiAppId
            buildConfigField("String", "HUAWEI_APP_ID", "\"$huaweiAppId\"")
        }
    }

    buildFeatures {
        buildConfig = true
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Use the upload keystore from key.properties when present (release builds /
            // Play uploads). Falls back to debug signing on machines/CI without the key
            // so `flutter run --release` and analyze still work.
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    add("huaweiImplementation", "com.huawei.hms:iap:6.13.0.300")
}

// The Flutter plugin graph adds in_app_purchase_android to every variant.
// The huawei flavor must not package Play Billing or declare its permission.
configurations.configureEach {
    if (name.contains("huawei")) {
        exclude(group = "com.android.billingclient", module = "billing")
    }
}
