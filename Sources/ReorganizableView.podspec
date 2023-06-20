Pod::Spec.new do |spec|

  spec.name         = "ReorganizableView"
  spec.version      = "1.0.0"
  spec.summary      = "A view that allows to organize multiple views into multiple stackviews"
  spec.description  = <<-DESC
  A view that allows to organize multiple views into multiple stackviews like Jira or Trello tickets
                   DESC
  spec.homepage     = "https://github.com/sonnyfournier/ReorganizableView"
  spec.license      = "MIT"
  spec.author             = { "Sonny Fournier" => "sonny.fournier@protonmail.com" }
  spec.source       = { :git => "https://github.com/sonnyfournier/ReorganizableView.git", :tag => "#{spec.version}" }
  spec.source_files  = "ReorganizableView/**/*.swift"

end
