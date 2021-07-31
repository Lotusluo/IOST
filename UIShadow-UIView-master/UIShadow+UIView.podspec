Pod::Spec.new do |s|
s.name = "UIShadow+UIView"
s.version = "1.0"
s.license = { :type => "MIT", :file => "LICENSE" }
s.platform = :ios, "8.0"
s.summary = "UIShadow+UIView"
s.homepage = "https://github.com/wangxiaocan/UIShadow-UIView"
s.authors = { "xiaocan" => "1217272889@qq.com" }
s.source = { :git => "https://github.com/wangxiaocan/UIShadow-UIView.git", :tag => "#{s.version}" }
s.requires_arc = true
s.source_files = "UIShadow+UIView/*.{h,m}"
s.frameworks = "UIKit"
end
