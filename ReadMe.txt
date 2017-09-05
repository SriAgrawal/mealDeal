
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
You may encounter the following error:
Diff: /Podfile.lock: No such file or directory
Diff: /Manifest.lock: No such file or directory

Reason:

gitignore for avoid commit/push in project repository for unnecessary files and frameworks(downloaded via pods)

TODO:

Go to pod file or .xcworkspace directory in cloned project and run below command on terminal
pod install

Wait for a while, it may take some time.
After installing all dependancies open .xcworkspace instead of .xcodeproj

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
