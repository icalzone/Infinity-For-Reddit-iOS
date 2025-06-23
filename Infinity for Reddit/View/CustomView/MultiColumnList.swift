//
//  MultiColumnList.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-22.
//

import UIKit
import SwiftUI

struct MultiColumnList: UIViewRepresentable {
    let items: [String]

    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = context.coordinator
        return tableView
    }

    func updateUIView(_ uiView: UITableView, context: Context) {
        uiView.reloadData()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(items: items)
    }

    class Coordinator: NSObject, UITableViewDataSource {
        var items: [String]

        init(items: [String]) {
            self.items = items
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            items.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ??
                UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell.textLabel?.text = items[indexPath.row]
            return cell
        }
    }
}
