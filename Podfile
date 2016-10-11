platform :ios, '8.0'

# ignore all warnings from all pods
inhibit_all_warnings!

source 'https://github.com/CocoaPods/Specs.git'

target :rtc_oc_mvvm_frame do

##Helper
pod 'ReactiveCocoa', '2.5'
pod 'BlocksKit', '2.2.5'
pod 'RZDataBinding', '~> 2.1.0'
pod 'LKDBHelper', '~> 2.3.3'
pod 'YYModel', '~> 1.0.4'
pod 'YYCache', '~> 1.0.3'
pod 'SDWebImage', '~> 3.8.1'

##Network
pod 'AFNetworking', '~> 3.1.0'
pod 'SocketRocket', '0.5.1'

##UI
pod 'Masonry', '~> 1.0.1'
pod 'Toast', '~> 3.0'
pod 'IQKeyboardManager', '~> 3.2.3'
#pod 'DZNEmptyDataSet', '~> 1.8.1'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = "NO"
    end
  end
end
