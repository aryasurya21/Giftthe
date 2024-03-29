Pod::Spec.new do |spec|
    spec.name                     = 'Gifthe'
    spec.version                  = '1.0.5'
    spec.homepage                 = 'https://github.com/aryasurya21/Giftthe.git'
    spec.source                   = { :git => "https://github.com/aryasurya21/Giftthe.git", :tag => "#{spec.version}" }
    spec.authors                  = { "Arya" => "arya.surya021@gmail.com" }
    spec.license                  = { :type => "MIT", :file => "LICENSE" }
    spec.summary                  = 'Some description for the Shared Module'
    spec.libraries                = 'c++'
    spec.source_files              = 'Gifthe/**/*.{kt}'
    spec.ios.deployment_target = '13.0'

    if !Dir.exist?('build/cocoapods/framework/Gifthe.framework') || Dir.empty?('build/cocoapods/framework/Gifthe.framework')
        raise "

        Kotlin framework 'Gifthe' doesn't exist yet, so a proper Xcode project can't be generated.
        'pod install' should be executed after running ':generateDummyFramework' Gradle task:

            ./gradlew :Gifthe:generateDummyFramework

        Alternatively, proper pod installation is performed during Gradle sync in the IDE (if Podfile location is set)"
    end
                
    spec.pod_target_xcconfig = {
        'KOTLIN_PROJECT_PATH' => ':Gifthe',
        'PRODUCT_MODULE_NAME' => 'Gifthe',
    }
                
    spec.script_phases = [
        {
            :name => 'Build Gifthe',
            :execution_position => :before_compile,
            :shell_path => '/bin/sh',
            :script => <<-SCRIPT
                if [ "YES" = "$OVERRIDE_KOTLIN_BUILD_IDE_SUPPORTED" ]; then
                  echo "Skipping Gradle build task invocation due to OVERRIDE_KOTLIN_BUILD_IDE_SUPPORTED environment variable set to \"YES\""
                  exit 0
                fi
                set -ev
                REPO_ROOT="$PODS_TARGET_SRCROOT"
                "$REPO_ROOT/../gradlew" -p "$REPO_ROOT" $KOTLIN_PROJECT_PATH:syncFramework \
                    -Pkotlin.native.cocoapods.platform=$PLATFORM_NAME \
                    -Pkotlin.native.cocoapods.archs="$ARCHS" \
                    -Pkotlin.native.cocoapods.configuration="$CONFIGURATION"
            SCRIPT
        }
    ]
                
end