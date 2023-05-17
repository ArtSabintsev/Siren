Pod::Spec.new do |s|
  # Version
  s.version       = "6.1.2"
  s.swift_version = "5.5"

  # Meta
  s.name         = "Siren"
  s.summary      = "Notify users that a new version of your iOS app is available, and prompt them with the App Store link."
  s.homepage     = "https://github.com/ArtSabintsev/Siren"
  s.license      = "MIT"
  s.authors      = { "Arthur Ariel Sabintsev" => "arthur@sabintsev.com" }
  s.description  = <<-DESC
                    Notify your users when a new version of your iOS app is available, and prompt them with the App Store link.
                   DESC

  # Compatibility & Sources
  s.ios.deployment_target       = '13.0'
  s.tvos.deployment_target      = '13.0'
  s.source                      = { :git => "https://github.com/ArtSabintsev/Siren.git", :tag => s.version.to_s }
  s.source_files                = 'Sources/**/*.swift'
  s.resources                   = 'Sources/Siren.bundle'
  s.requires_arc                = true
end
