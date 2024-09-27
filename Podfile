# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'ISSTracker' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ISSTracker
	pod 'GoogleMaps'
 	pod 'GooglePlaces'
	pod 'Alamofire'
  pod 'MaterialComponents/Buttons'
  pod 'Eureka'

  target 'ISSTrackerTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "13.0"
    end
  end
end
