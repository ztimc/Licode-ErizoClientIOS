Pod::Spec.new do |s|

  s.name         = "PodWebRTC"
  s.version      = "0.0.1"
  s.summary      = "PodWebRTC desc"

  s.homepage     = "https://github.com/lipku"
  s.license      = { type: 'MIT', file: 'LICENSE' }

  s.author       = { "lihengz" => "lipku@qq.com" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "~/Documents/code/mycode" }
  #s.source_files  = "**/*.{h}"

  s.requires_arc = true
  s.vendored_frameworks = 'WebRTC.framework'
end
