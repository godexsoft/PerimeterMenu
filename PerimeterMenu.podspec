#
# Be sure to run `pod lib lint PerimeterMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PerimeterMenu'
  s.version          = '1.1'
  s.summary          = 'Pinterest inspired long press menu button.'
  s.description      = <<-DESC
PerimeterMenu is a fancy animated menu for iOS applications written in swift with Storyboard design support.
Similar to Pinterest long press menu (button).
                       DESC
  s.homepage         = 'https://github.com/godexsoft/PerimeterMenu'
  s.license          = {
      :type => 'MIT',
      :file => 'LICENSE'
  }
  s.authors          = {
      'Alex Kremer' => 'godexsoft@gmail.com',
      'Valera Chevtaev' => 'myltik@gmail.com'
  }
  s.source           = {
      :git => 'https://github.com/godexsoft/PerimeterMenu.git', 
      :tag => s.version.to_s 
  }
  s.ios.deployment_target = '10.0'
  s.swift_version = '4.0'
  s.source_files = 'PerimeterMenu/Classes/**/*'
  s.frameworks = 'UIKit'
end
