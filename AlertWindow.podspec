Pod::Spec.new do |s|
  s.name         = 'AlertWindow'
  s.version      = '0.0.1'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.summary      = 'A library for swift 3.0 to use AlertView and ActionSheet.'
  s.homepage     = 'https://github.com/XiaXianBing'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'XiaXianBing' => '635954948@qq.com' }
  s.source       = { :git => 'https://github.com/XiaXianBing/AlertWindow.git', :tag => s.version }
  s.source_files = 'Source/*.swift'
end
