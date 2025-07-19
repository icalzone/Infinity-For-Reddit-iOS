//
//  MultiColumnList.swift
//  Infinity for Reddit
//
//  Created by Docile Alligator on 2025-06-22.
//

import UIKit
import SwiftUI

struct MultiColumnList<Item>: UIViewRepresentable {
    let items: [Item]
    let viewForItem: (Item) -> AnyView
    let onItemAppear: ((Int, Item) -> Void)?

    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        return tableView
    }

    func updateUIView(_ uiView: UITableView, context: Context) {
        context.coordinator.items = items
        context.coordinator.onItemAppear = onItemAppear
        uiView.reloadData()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(items: items, viewForItem: viewForItem, onItemAppear: onItemAppear)
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var items: [Item]
        let viewForItem: (Item) -> AnyView
        var onItemAppear: ((Int, Item) -> Void)?

        init(items: [Item],
             viewForItem: @escaping (Item) -> AnyView,
             onItemAppear: ((Int, Item) -> Void)?) {
            self.items = items
            self.viewForItem = viewForItem
            self.onItemAppear = onItemAppear
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            items.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HostingCell") ??
                UITableViewCell(style: .default, reuseIdentifier: "HostingCell")

            cell.contentView.subviews.forEach { $0.removeFromSuperview() }

            let swiftUIView = viewForItem(items[indexPath.row])
            let hostingController = UIHostingController(rootView: swiftUIView)
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false

            cell.contentView.addSubview(hostingController.view)
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            ])

            return cell
        }

        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let index = indexPath.row
            guard index < items.count else { return }
            onItemAppear?(index, items[index])
        }
    }
}
