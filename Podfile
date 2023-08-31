source 'https://github.com/CocoaPods/Specs.git' 
platform :ios, '13.0'

def appPods
   pod 'RxSwift', '6.5.0'
   pod 'RxCocoa', '6.5.0'
   pod 'SnapKit', '5.6.0'
end

target 'BestShot' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BestShot
    appPods

  target 'BestShotTests' do
    inherit! :search_paths
    # Pods for testing
    appPods
    pod 'RxBlocking', '6.5.0'
    pod 'RxTest', '6.5.0'
  end

  target 'BestShotUITests' do
    # Pods for testing
  end

end
