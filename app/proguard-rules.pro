-renamesourcefileattribute SourceFile
-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,*Annotation*,EnclosingMethod

# Compat support lib
-keep class android.support.** { *; }
-keepclassmembers class android.support.** { *; }
-keep interface android.support.**
-keepclassmembers interface android.support.** { *; }

# Butterknife
-keep class butterknife.** { *; }
-dontwarn butterknife.internal.**
-keep class **$$ViewInjector { *; }
-keepclasseswithmembernames class * {
    @butterknife.* <fields>;
}

-keepclasseswithmembernames class * {
    @butterknife.* <methods>;
}

# Guava
-dontwarn sun.misc.Unsafe
-dontwarn com.google.common.collect.MinMaxPriorityQueue

-keep,allowoptimization class com.google.inject.** { *; }
-keep,allowoptimization class javax.inject.** { *; }
-keep,allowoptimization class javax.annotation.** { *; }
-keep,allowoptimization class com.google.inject.Binder

-keepclasseswithmembers public class * {
    public static void main(java.lang.String[]);
}

-keepclassmembers,allowoptimization class com.google.common.* {
    void finalizeReferent();
    void startFinalizer(java.lang.Class,java.lang.Object);
}

-keepclassmembers class * {
       @com.google.common.eventbus.Subscribe *;
}
