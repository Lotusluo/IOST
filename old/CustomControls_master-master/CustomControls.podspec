#
#  Be sure to run `pod spec lint CustomControls.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "CustomControls"
  s.version      = "1.0.0"
  s.summary      = "常用的自定义控件，可在storyboard和Xib中实时渲染"
  s.description  = "常用的自定义控件，可在storyboard和Xib中实时渲染，添加与cocoapod支持"
  s.homepage     = "https://github.com/rongshuizhou/CustomControls_master.git"
  s.social_media_url   = "http://www.jianshu.com/u/2f2c98d64124"
  s.license= { :type => "MIT", :file => "LICENSE" }
  s.author       = { "menday" => "1013620104@qq.com" }
  s.source       = { :git => "https://github.com/rongshuizhou/CustomControls_master.git", :tag => s.version }
  s.source_files = "CustomControls/*.{h,m}"
  s.ios.deployment_target = '8.0'
  s.frameworks   = 'UIKit'
  s.requires_arc = true

end
