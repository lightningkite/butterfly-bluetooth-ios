Pod::Spec.new do |s|
  s.name = "ButterflyBluetooth"
  s.version = "0.2.0"
  s.summary = "Bluetooth for Butterfly"
  s.description = "Shared code for bluetooth using Butterfly.  This is the iOS portion."
  s.homepage = "https://github.com/lightningkite/butterfly"

  s.license = "GPL"
  s.author = { "Captain" => "joseph@lightningkite.com" }
  s.platform = :ios, "11.0"
  s.source = { :git => "https://github.com/lightningkite/butterfly.git", :tag => "#{s.version}" }
  s.source_files =  "ios-bluetooth/ButterflyBluetooth/**/*.swift" # path to your classes. You can drag them into their own folder.

  s.pod_target_xcconfig = { "DEFINES_MODULE" => "YES" }

  s.requires_arc = true
  s.swift_version = '5.3'
  s.xcconfig = { 'SWIFT_VERSION' => '5.3' }
  # Dependency on Butterfly not representable at the moment
  s.dependency "Butterfly/Core"
  s.dependency "RxBluetoothKit"
end
