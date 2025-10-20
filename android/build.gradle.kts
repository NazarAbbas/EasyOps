allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Force androidx.core to a version compatible with AGP 8.7.x
subprojects {
    configurations.all {
        resolutionStrategy.eachDependency {
            if (requested.group == "androidx.core" &&
                (requested.name == "core" || requested.name == "core-ktx")) {
                useVersion("1.13.1")
                because("androidx.core 1.17.0 requires AGP 8.9.1+, but this project uses AGP 8.7.3")
            }
        }
    }
}

