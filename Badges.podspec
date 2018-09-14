Pod::Spec.new do |s|
  s.name         = "Badges"
  s.version      = "0.3.0"
  s.summary      = "Badges is a tool to add badge view to your projects."

  s.description  = <<-DESC
                      Badges is a tool to add badge view to your projects on ios platform using swift.
                      DESC

  s.homepage     = "https://github.com/devedbox/Badges"
  s.screenshots  = "http://ww2.sinaimg.cn/large/d2297bd2gw1f1kwshfqhwg20ab0i94b2.gif"

  s.license      = "MIT"
  s.author       = { "devedbox" => "devedbox@gmail.com" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/devedbox/Badges.git", :tag => "#{s.version}" }

  s.source_files = "Badge/Sources/*.swift"

  s.frameworks = "UIKit", "Foundation"
end
