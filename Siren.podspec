Pod::Spec.new do |s|
  s.name         = "Siren"
  s.version      = "0.1.0"
  s.summary      = "Notify users when a new version of your iOS app is available, and prompt them with the App Store link.."

  s.description  = <<-DESC
Siren is checks a user’s currently installed version of your iOS app against the version that is currently available in the App Store. If a new version is available, an instance of UIAlertView (iOS 7) or UIAlertController (iOS 8) can be presented to the user informing them of the newer version, and giving them the option to update the application. Alternatively, Siren can notify your app programmatically, so that you can inform the user through alternative means.

Siren is built to work with the Semantic Versioning system.
Siren is a Swift port of Harpy, an Objective-C library that achieves the same functionality.
Siren is actively maintained by Arthur Sabintsev and Aaron Brager.
                   DESC

  s.homepage     = "https://github.com/ArtSabintsev/Siren"
  s.license      = "MIT"
  s.authors      = { "Arthur Sabintsev" => "arthur@sabintsev.com", "Aaron Brager" => "getaaron@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/ArtSabintsev/Siren.git", :tag => "0.1.0" }
  s.source_files = 'Siren/Siren/*.swift'
  s.resources    = 'Siren/Source/Siren.bundle'
  s.requires_arc = true

end
