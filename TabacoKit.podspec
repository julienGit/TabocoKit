Pod::Spec.new do |spec|

	spec.name    = "TabacoKit"
	spec.version = "0.0.1"
	spec.summary = "Tabaco The description is shorter than the summary."
	spec.description = <<-DESC  
						Tabaco组件 
						DESC
	spec.homepage = "www.baidu.com"
	spec.license  = "MIT"
	spec.author   = {"zy" => "15680075675@163.com"}
	spec.platform = :ios, "9.0"
	spec.ios.deployment_target = "9.0"
	spec.source   = { :git => "git@github.com:julienGit/TabocoKit.git" , :tag => '#{spec.version}'}
	spec.static_framework = true
	spec.pod_target_xcconfig = {
		'ENABLE_BITCODE' => 'NO'
	}
	spec.source_files = "TabacoKit" , "TabacoKit/**/*.{h,m}"
	spec.public_header_files = "TabacoKit/**/*.h"
	
	spec.dependency 'Masonry'

end