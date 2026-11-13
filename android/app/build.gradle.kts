import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = System.getenv("MATSJEKK_KEY_PROPERTIES")
    ?.takeIf { it.isNotBlank() }
    ?.let { file(it) }
    ?: rootProject.file("key.properties")
val storeFileBase = System.getenv("MATSJEKK_STORE_FILE_BASE")
    ?.takeIf { it.isNotBlank() }
    ?.let { file(it) }
    ?: project.projectDir
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

fun signingValue(name: String): String =
    keystoreProperties.getProperty(name)?.trim().orEmpty()

fun resolvedStoreFile(): File {
    val raw = signingValue("storeFile")
    val direct = File(raw)
    return if (direct.isAbsolute) direct else File(storeFileBase, raw)
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
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.isFile &&
                signingValue("storeFile").isNotEmpty() &&
                resolvedStoreFile().isFile
            ) {
                keyAlias = signingValue("keyAlias")
                keyPassword = signingValue("keyPassword")
                storeFile = resolvedStoreFile()
                storePassword = signingValue("storePassword")
            }
        }
    }

    buildTypes {
        release {
            // Never fall back to the debug key. A release bundle is signed only
            // when the upload keystore is present; otherwise packaging fails closed.
            if (keystorePropertiesFile.isFile && resolvedStoreFile().isFile) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

gradle.taskGraph.whenReady {
    val needsUploadSignature = allTasks.any { task ->
        val name = task.name
        name == "bundleRelease" ||
            name == "assembleRelease" ||
            name == "signReleaseBundle" ||
            name.startsWith("packageRelease")
    }
    if (!needsUploadSignature) {
        return@whenReady
    }
    val missing = listOf("keyAlias", "keyPassword", "storeFile", "storePassword")
        .filter { signingValue(it).isEmpty() }
    if (!keystorePropertiesFile.isFile || missing.isNotEmpty() || !resolvedStoreFile().isFile) {
        throw GradleException(
            "Release signing is incomplete. Refusing to use the debug key."
        )
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
