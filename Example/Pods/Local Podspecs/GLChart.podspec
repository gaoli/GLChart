Pod::Spec.new do |s|
  s.name             = "GLChart"
  s.version          = "1.0.3"
  s.summary          = "A beautiful chart library for iOS"

  s.description      = <<-DESC
                        GLChart is A beautiful chart library for iOS
                       DESC

  s.homepage         = "https://github.com/gaoli/GLChart.git"
  s.license          = 'MIT'
  s.author           = { "gaoli" => "3071730@qq.com" }
  s.source           = { :git => "https://github.com/gaoli/GLChart.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.default_subspec = 'Core', 'Components', 'Charts'

  s.subspec 'Core' do |core|

    core.source_files = 'Pod/Classes/Core/*.{h,m}'

  end

  s.subspec 'Components' do |components|

    components.source_files = 'Pod/Classes/Components/*.{h,m}'
    components.dependency 'GLChart/Core'

  end

  s.subspec 'Charts' do |charts|

    charts.source_files = 'Pod/Classes/Charts/*.{h,m}'
    charts.dependency 'GLChart/Core'
    charts.dependency 'GLChart/Components'

  end

  s.resource_bundles = {
    'GLChart' => ['Pod/Assets/*.png']
  }
end
