# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'

target 'MealApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MealApp
  pod 'SwiftLint'
  pod 'SwiftFormat/CLI'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'SnapKit', '~> 5'
  pod 'RxNuke', '~> 1'
  pod 'RxDataSources', '~> 4.0'

  target 'MealAppTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxTest', '~> 5'
    pod 'Quick', '~> 3'
    pod 'Nimble', '~> 8'
    pod 'SnapshotTesting'
  end

  target 'MealAppUITests' do
    # Pods for testing
  end

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
end
