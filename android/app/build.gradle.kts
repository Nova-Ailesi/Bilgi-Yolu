plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.nova.bilgi_yolu"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.nova.bilgi_yolu"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("debug")
        }
        debug {
            applicationIdSuffix = ".debug"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.core:core-ktx:1.13.1")
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("com.google.android.gms:play-services-ads:23.3.0")
    implementation("androidx.work:work-runtime-ktx:2.9.1")
}
