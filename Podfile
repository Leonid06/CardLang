# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CardLang' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for CardLang
  pod 'CardSlider'
  pod 'Shuffle-iOS'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'RealmSwift', '~>10'
  pod 'IQKeyboardManagerSwift'
  pod 'RSKPlaceholderTextView'
  pod 'Differ'
  pod 'EmptyStateKit'
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = 
'12.0'
               end
          end
   end
end

