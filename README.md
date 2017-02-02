iTunes Applications
=====================

Made by [![Appus Studio](https://github.com/appus-studio/Appus-Splash/blob/master/image/logo.png)](http://appus.pro)

'iTunes Applications' show list of applications from iTunes with details.

![iTunes Applications: Show list of applications from iTunes with details](https://github.com/ilya-borshchov-appus/TestApplicationRepo/blob/master/AppusApplications/Resources/IMG_7827.PNG)
![iTunes Applications: Show list of applications from iTunes with details](https://github.com/ilya-borshchov-appus/TestApplicationRepo/blob/master/AppusApplications/Resources/IMG_7828.PNG)
![iTunes Applications: Show list of applications from iTunes with details](https://github.com/ilya-borshchov-appus/TestApplicationRepo/blob/master/AppusApplications/Resources/IMG_7829.PNG)

#Setup
```Ruby
pod 'iTunesApplications'
```

```swift

import iTunesApplications

// Declare vc
var iTunesApplications : AppsViewController?

override func viewDidLoad() {
    super.viewDidLoad()

	// Init
	self.iTunesApplications = AppsViewController.sharedAppsViewController()
	// Set list of application ids, also application details can be fetched from file with ids, from file with ids by url and by developer id
	self.iTunesApplications?.type = .array(["858525203","578979413","919087726","507125352","642665353",
                                    "664457128","1023583941", "849600010","640097569","875063456"])
        
	// Set star image for rating
	SettingsManager.shared.filledRatingImage = UIImage(named: "StarEmpty")
	SettingsManager.shared.emptyRatingImage = UIImage(named: "StarFull")

	// Configure UI style        
	SettingsManager.shared.textColor = UIColor.green
	// Hide cancel button if vc will be pushed
	SettingsManager.shared.cancelButtonHidden = true
}

// Push vc
@IBAction func showApplicationListClicked(_ sender: Any) {
        self.navigationController?.pushViewController(self.iTunesApplications!, animated: true)
}
```

Developed By
------------

* Ilya Borshchov, Vladimir Grigoriev Appus Studio

License
--------

Copyright 2015 Appus Studio.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
