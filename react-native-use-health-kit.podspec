require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-use-health-kit"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  This library allows app to read and write health data by HealthKit.
                   DESC
  s.homepage     = "https://github.com/yoshifumi4423/react-native-use-health-kit"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.authors      = { "Yoshifumi Kanno" => "ykpublicjp@gmail.com" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/yoshifumi4423/react-native-use-health-kit.git", :tag => "#{s.version}" }

  s.swift_version = '5.0'
  
  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
	
  # s.dependency "..."
end

