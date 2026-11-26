# HMS Core IAP (huawei flavor). Rules from Huawei's IAP integration guide.
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keep class com.huawei.hianalytics.**{*;}
-keep class com.huawei.updatesdk.**{*;}
-keep class com.huawei.hms.**{*;}

# Optional classes referenced by HMS Core that are not on the classpath.
-dontwarn com.huawei.android.os.BuildEx$VERSION
-dontwarn com.huawei.hianalytics.**
-dontwarn com.huawei.hms.iapfull.**
-dontwarn com.huawei.libcore.io.**
-dontwarn org.bouncycastle.crypto.**
