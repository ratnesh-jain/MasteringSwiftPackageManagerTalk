//
//  UsersViewController.swift
//  MasteringSwiftPMStudy
//
//  Created by Ratnesh Jain on 10/09/24.
//

import Foundation
import UIKit
import ServiceFeature

class UsersViewController: UIViewController {
    enum Section: Hashable {
        case main
    }
    
    var offset: Int = 0
    let limit: Int = 15
    private var users: [User] = []
    
    private lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout.list(using: .init(appearance: .grouped))
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, User> = {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, User> { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier.name
            cell.contentConfiguration = configuration
        }
        let dataSource = UICollectionViewDiffableDataSource<Section, User>(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        }
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        fetchUsers()
    }
    
    private func configureViews() {
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.navigationItem.title = "Users"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchUsers() {
        let offset = self.offset
        let limit = self.limit
        Task {
            do {
                let users = try await ServiceClient.shared.fetchUsers(offset: offset, limit: limit)
                if offset == 0 {
                    self.users = users
                } else {
                    self.users.append(contentsOf: users)
                }
                self.offset = self.users.count
                self.applySnapshot(with: self.users)
            }
        }
    }
    
    private func applySnapshot(with users: [User]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([.main])
        snapshot.appendItems(users, toSection: .main)
        dataSource.apply(snapshot)
    }
}

extension UsersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.users.count - 1 {
            self.fetchUsers()
        }
    }
}

#Preview {
    UINavigationController(rootViewController: UsersViewController())
}
