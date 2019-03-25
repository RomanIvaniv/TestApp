##Key Features

The app is divided into three layers: Presentation, Application and Core.
The Presentation layer is built using MVP architecture.
The Core layer is built using SOA.
For current tasks i didn't use dependency injection framework, just to not overload the application. (I'd like to use Swinject / Typhoon frameworks). For the same reason i didn't use Encodable protocol while parse response.

##Optional tasks:

***TASK 1:​ Handle “offline mode” in the app.:*** I store movie list response into UserDefaults. And if there no internet connection, i'm trying to load this response from memory. To provide "offline mode" to movie trailer, i added additional navigation bar button on movie detail screen. On click event i download the video and store it localy in documents folder. After success download you will be able to watch trailer offline.

***OPTIONAL TASK 2: ​create a search functionality in the catalog page by filtering
content downloaded:*** I added search bar into tableView header + dataSource filtering logic.

***OPTIONAL TASK 3:​ support both iOS device types (iPad and iPhone):*** I decided to use UISplitViewController to provide best user expeciance for both device types. For iPhone i support landscape and portraint orientations. The layout is similar to provided mockups. For iPad as master screen i show movie list and for detail screen - movie detail. First movie from the list i show as default on detail screen.

***OPTIONAL TASK 4:​ create at least one unit test!*** Added few unit tests for different response structure. 
