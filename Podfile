# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
# use_frameworks!

workspace 'ContactDetails'

project 'iOSContactDetails.xcodeproj'

def base_pod
  pod 'PromiseKit'
  pod 'AlamofireImage'
end

target 'iOSContactDetails' do
  project 'iOSContactDetails/iOSContactDetails.xcodeproj'
  base_pod
end

target 'iOSContactDetailsUnitTests' do
  project 'iOSContactDetails/iOSContactDetails.xcodeproj'
  base_pod
end
