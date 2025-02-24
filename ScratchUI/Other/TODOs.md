# To-Dos

- Implement diffable data source
- Implement refresh logic (fetch data again to keep ui "fresh")
- compose VIPER screen in "router"


- Analytics Engine Tracker
- on viper implement dynamicKey memberlookup to viewState, so I can do:
    view.set(\.title), view.set(\.contacts), view.set(\.tableData)

- Make `setTableData(contacts: [ContactEntity])` operations parallel

- Refactor Navigation Bar to be shared between grid and list
- Fix hide navigation when switching to grid

- Have UI drive the size of thumbnails fetched

- Add Tests

- refactor Table and Collection Data Source 
 
-  Consolidate tableView and collectionView

- Fix URL composition

- Implement some sort of design pattern that allows the ContactDataSource to be SOLID:
shouldn't import UIKit or use NSObject, should be able to support Collections and Tables  

# Architecture
- (technically) When creating modules, protocols should not be in the same files as the source code. It creates a source code dependency at the file level.

## Viper 

Try changing the presenter to return values, so the reference to the view is not needed. Instead of having:

        //Presenter
        func onViewDidLoad() {
            view.setTitle(with: title)
        }

        //View
        func getTitle() {
            navigationItem.title = presenter.getTitle()
        }
    
Try creating a shared "observable" object for the presenter and the view.
The view asks for a value, the value is a computed property 



## VIP

protocol InteractorProtocol {
    onViewDidLoad()
    onSwitchLayout()
}



 # TODO:
 - Instead of first name, chose another field to show in the table and sortBy that field
 - Support re arranging cells (disables sorted alphabetically)
 - Support search filtering, desirably fuzzy match, and search all fields
 - add pull to refresh
 - Bar item toggle to show contacts as collection view with its profile pictures (pre fetched)
 - Get all data fetching off main thread an then move the UI updates to main  thread
 - support sort alphabetically
 - support delete, add and modify
 - support swiftData persistance


- For UITableViewController: make a custom data struct that acts as an array. Takes a subscript and returns that element. Elements are served on-demand, instead of setting all elements at once
