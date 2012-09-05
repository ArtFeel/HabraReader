Pod::Spec.new do |s|
  s.name = 'RSSKit'
  s.version = '0.0.1'
  s.summary = 'iOS framework to make development of RSS reader apps easier.'
  s.description = %{
    iOS framework to make development of RSS reader apps easier.

    This is pod for jameshays fork. Which implemeting asynchronous loading, arc and some fixes.
  }

  s.homepage = 'https://github.com/H2CO3/RSSKit'
  s.author = { 'Árpád Goretity' => 'arpad.goretity@gmail.com' }
  s.source = { :git => 'https://github.com/jameshays/RSSKit.git', 
               :commit => '1a9ad2c1f64518a17f4409d1dc8d88955464e4eb' }

  s.platform = :ios
  s.source_files = 'RSSKit/*.{h,m}'
  s.requires_arc = true
  s.frameworks = 'Foundation'
end