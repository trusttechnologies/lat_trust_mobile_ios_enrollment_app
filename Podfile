# Uncomment the next line to define a global platform for your project
  platform :ios, '12.1'
  
  source 'https://github.com/trusttechnologies/auditpodspecs.git'
  source 'https://github.com/trusttechnologies/TrustDeviceInfoPodSpecs.git'
  source 'https://github.com/CocoaPods/Specs.git'

  use_frameworks!

target 'enrollment' do
  pod 'MaterialComponents/TextFields'
  pod 'MaterialComponents/Buttons'
  pod 'MaterialComponents/Buttons+ButtonThemer'
  pod 'MaterialComponents/Snackbar+TypographyThemer'
  pod 'MaterialComponents/BottomNavigation'
  pod 'MaterialComponents/BottomNavigation+TypographyThemer'
  pod 'MaterialComponents/BottomNavigation+ColorThemer'

  pod 'TrustDeviceInfo'
  pod 'Audit'

  pod 'IQKeyboardManagerSwift'

  pod 'RealmSwift'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = ‘4.2’
      end
    end
    
    installer.pods_project.build_configurations.each do |config|
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end
end
