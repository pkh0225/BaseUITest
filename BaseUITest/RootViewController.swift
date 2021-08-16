//
//  RootViewController.swift
//  BaseUITest
//
//  Created by pkh on 2021/08/11.
//

import UIKit

class RootViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        NavigationManager.shared.mainNavigation = self.navigationController
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestTitle", for: indexPath)

        if #available(iOS 14, *) {
            cell.showsLargeContentViewer = true
            var content = cell.defaultContentConfiguration()
            if indexPath.row == 0 {
                content.text = "Button Test"
            }
            else if indexPath.row == 1 {
                content.text = "Label Test"
            }

            cell.contentConfiguration = content
        }
        else {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Button Test"
            }
            else if indexPath.row == 1 {
                cell.textLabel?.text = "Label Test"
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            ButtonTestViewController.pushViewController()
        }
        else if indexPath.row == 1 {
            LabelTestViewController.pushViewController()
        }
    }
}
