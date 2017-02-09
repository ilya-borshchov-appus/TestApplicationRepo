#
#  Be sure to run `pod spec lint AppCollection.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "AppCollection"
  s.version      = "0.0.4"
  s.summary      = "AppCollection allow you to use customisable page control with many featues"
  s.homepage     = "http://appus.pro"
  s.license      = { :type => "Apache", :file => "LICENSE" }
  s.author             = { "Ilya Borshchov" => "ilya.borshchov@appus.me" }
  s.platform     = :ios
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/ilya-borshchov-appus/TestApplicationRepo.git", :tag => "0.0.4" }

  s.exclude_files = 'AppCollection/**/*.{AppDelegate.swift, IMG_7827.png, IMG_7828.png, IMG_7829.png}'
  s.source_files = "AppCollection/**/*.{swift}"
  s.resources = "AppCollection/**/*.{png,jpeg,jpg,txt,csv}"
  s.frameworks             = 'Foundation', 'UIKit'

  s.resource_bundles = {
'AppCollection' => ['AppCollection/**/*.{lproj,storyboard}']
}


  s.dependency "Alamofire"
  s.dependency "AlamofireImage"
  s.dependency "SwiftyJSON"
  s.dependency "PKHUD"
  s.requires_arc = true
end



