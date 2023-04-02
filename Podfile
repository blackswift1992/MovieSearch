# Uncomment the next line to define a global platform for your project
 platform :ios, '15.0'

target 'MovieSearch' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MovieSearch
  pod 'CLTypingLabel', '~> 0.4.0'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseStorage'
  pod 'FirebaseFirestoreSwift'
  pod 'RealmSwift'
  pod 'Alamofire', '~> 4.4'
  pod 'SwiftyJSON'
  pod 'SDWebImage'

  #fix Xcode 14.3 beta building bug
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
           end
      end
    end
  end

end


