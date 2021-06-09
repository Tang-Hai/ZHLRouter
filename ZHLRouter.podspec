#
# Be sure to run `pod lib lint ZHLRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZHLRouter'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ZHLRouter.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://111.204.225.50:18845/gitlab/ZHLPrimaryStudy/ios/ZHLPrimaryStudy'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tanghai' => 'tanghai4053@dingtalk.com' }
  s.source           = { :git => 'http://111.204.225.50:18845/gitlab/ZHLPrimaryStudy/ios/ZHLPrimaryStudy.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ZHLRouter/Classes/**/*'
  
  s.public_header_files = 'ZHLRouter/Classes/**/*.h'
  s.requires_arc = true
 
#  s.prepare_command = <<-EOF
#
#    # 业务Module
#    rm -rf ZHLRouter/Classes/Modules
#    mkdir ZHLRouter/Classes/Modules
#    touch ZHLRouter/Classes/Modules/module.modulemap
#    cat <<-EOF > ZHLRouter/Classes/Modules/module.modulemap
#    framework module ZHLRouter {
#      umbrella header "ZHLRouter.h"
#      export *
#    }
#    \EOF
#
#  EOF
  
  # s.resource_bundles = {
  #   'ZHLRouter' => ['ZHLRouter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
