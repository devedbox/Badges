Pod::Spec.new do |s|
  s.name         = "AXBadgeView-Swift"
  s.version      = "0.3.0"
  s.summary      = "AXBadgeView-Swift is a tool to add badge view to your projects."

  s.description  = <<-DESC
                      AXBadgeView-Swift is a tool to add badge view to your projects on ios platform using swift.
                      DESC

  s.homepage     = "https://github.com/devedbox/AXBadgeView-Swift"
  s.screenshots  = "http://ww2.sinaimg.cn/large/d2297bd2gw1f1kwshfqhwg20ab0i94b2.gif"

  s.license      = "MIT"
  s.author       = { "devedbox" => "devedbox@gmail.com" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/devedbox/AXBadgeView-Swift.git", :tag => "#{s.version}" }

  s.source_files = "AXBadgeView-Swift/AXBadgeView/AXBadgeView.swift", "AXBadgeView-Swift/AXBadgeView/misc.swift"

  s.frameworks = "UIKit", "Foundation"
end
