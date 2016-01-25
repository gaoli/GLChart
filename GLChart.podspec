Pod::Spec.new do |s|
  s.name             = "GLChart"
  s.version          = "1.0.0"
  s.summary          = "A beautiful chart library for iOS"

  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/gaoli/GLChart.git"
  s.license          = 'MIT'
  s.author           = { "高力" => "3071730@qq.com" }
  s.source           = { :git => "git@github.com:gaoli/GLChart.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.default_subspec = 'Core', 'LineChart'

  s.subspec 'Core' do |core|

    core.source_files = 'Pod/Classes/Core/*.{h,m}'

  end

  s.subspec 'LineChart' do |lineChart|

    lineChart.source_files = 'Pod/Classes/LineChart/*.{h,m}'

  end

  s.resource_bundles = {
    'GLChart' => ['Pod/Assets/*.png']
  }
end
