Pod::Spec.new do |s|

  s.name         = "PodSwiss"
  s.version      = "0.0.1"
  s.summary      = "Swiss desc"

  s.homepage     = "https://github.com/ztimc"
  s.license      = { type: 'MIT', file: 'LICENSE' }

  s.author       = { "ztimc" => "ztimc@qq.com" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "~/Documents/code/mycode" }
  #s.source_files  = "**/*.{h}"

  s.requires_arc = true
  s.vendored_frameworks = 'Swiss.framework'
end
