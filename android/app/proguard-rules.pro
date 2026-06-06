-ignorewarnings
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable

# HMS Core
-keep class com.huawei.hms.** { *; }
-keep class com.huawei.hianalytics.** { *; }
-keep class com.huawei.android.** { *; }
-keep interface com.huawei.hms.** { *; }

# AGConnect
-keep class com.huawei.agconnect.** { *; }

# HMS IAP
-keep class com.huawei.hms.iap.** { *; }
-keep class com.huawei.hms.iapfull.** { *; }
