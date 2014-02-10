#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "CSStickyHeaderFlowLayout"
  s.version      = "0.1.0"
  s.summary      = "Parallax and Sticky header done right using UICollectionViewLayout"
  s.description  = <<-DESC
                    An optional longer description of CSStickyHeaderFlowLayout

                    * Markdown format.
                    * Don't worry about the indent, we strip it!
                   DESC
  s.homepage     = "http://github.com/jamztang/CSStickyHeaderFlowLayout"
  s.screenshots  = "https://d262ilb51hltx0.cloudfront.net/max/800/1*pev9ZXJAZ2MYoF8-R_nbRA.gif"
  s.license      = 'MIT'
  s.author       = { "James Tang" => "jamz@jamztang.com" }
  s.source       = { :git => "https://github.com/jamztang/CSStickyHeaderFlowLayout.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Assets'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.dependency 'JSONKit', '~> 1.4'
end
