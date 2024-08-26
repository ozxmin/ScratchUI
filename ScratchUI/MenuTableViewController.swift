//
//  MenuTableViewController.swift
//  ScratchUI
//
//  Created by Ozmin Vazquez on 22/08/24.
//

import UIKit

struct DemoInfo: Hashable, RawRepresentable, ExpressibleByStringLiteral {
    var rawValue: RawValue {
        screen
    }
    typealias RawValue = UIViewController.Type

    let name: String
    let screen: RawValue

    init(stringLiteral: StringLiteralType) {
        name = String(stringLiteral)
        switch stringLiteral {
            case "ContactTableViewController": screen = ContactTableViewController.self
            default: screen = ContactDetailViewController.self
        }
    }

    init?(rawValue: RawValue) {
        screen = rawValue
        name = String(describing: rawValue)
    }

    static func == (lhs: DemoInfo, rhs: DemoInfo) -> Bool {
        lhs.screen.self == rhs.screen.self
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(String(describing: screen))
    }
}

enum Demos: DemoInfo, CaseIterable {
    case contacts
    case test
    //case three = DemoInfo(rawValue: ContactTableViewController.self)
    //case dream = ContactTableViewController.self
    var rawValue: DemoInfo {
        switch self {
            case .contacts: return DemoInfo(rawValue: ContactTableViewController.self)!
            case .test: return DemoInfo(rawValue: ContactDetailViewController.self)!
        }
    }

    init?(rawValue: DemoInfo) {
        switch rawValue.screen {
            case is ContactTableViewController.Type: self = .contacts
            case is ContactDetailViewController.Type: self = .test
            default: return nil
        }
    }

    static subscript(index: Int) -> Demos? {
        guard index >= 0 && index < Self.allCases.count else {
            return nil
        }
        return Self.allCases[index]
    }

    func index() -> Int? {
        return Self.allCases.firstIndex(of: self)
    }
}



class MenuTableViewController: UITableViewController {

//    let items: KeyValuePairs<String, UIViewController.Type> = ["Contacts": ContactTableViewController.self]
    let items = Demos.allCases

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground
        title = "Menu"
        selectDemo(option: .contacts)
    }

    func selectDemo(option: Demos) {
        guard let position = option.index() else {
            return
        }
        tableView(tableView, didSelectRowAt: IndexPath(row: position, section: 0))
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let name = items[indexPath.row].rawValue.name
        cell.textLabel?.text = name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //navigationController?.pushViewController(ContactTableViewController(), animated: true)
//        show(ContactTableViewController(), sender: nil)
        let screen = items[indexPath.row].rawValue.screen.init()
        show(screen, sender: nil)
    }

}




/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
