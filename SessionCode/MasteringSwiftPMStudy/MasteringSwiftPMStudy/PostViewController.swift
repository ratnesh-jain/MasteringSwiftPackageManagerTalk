//
//  PostViewController.swift
//  MasteringSwiftPMStudy
//
//  Created by Ratnesh Jain on 10/09/24.
//

import Foundation
import UIKit
import ServiceFeature

class PostViewController: UIViewController {
    enum Section: Hashable {
        case main
    }
    
    var offset: Int = 0
    let limit: Int = 15
    private var posts: [Post] = []
    
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
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Post> = {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Post> { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier.title
            cell.contentConfiguration = configuration
        }
        let dataSource = UICollectionViewDiffableDataSource<Section, Post>(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        }
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        fetchPosts()
    }
    
    private func configureViews() {
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.navigationItem.title = "Posts"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchPosts() {
        let offset = self.offset
        let limit = self.limit
        Task {
            do {
                let posts = try await ServiceClient.shared.fetchPosts(offset: offset, limit: limit)
                if offset == 0 {
                    self.posts = posts
                } else {
                    self.posts.append(contentsOf: posts)
                }
                self.offset = self.posts.count
                self.applySnapshot(with: self.posts)
            }
        }
    }
    
    private func applySnapshot(with posts: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
        snapshot.appendSections([.main])
        snapshot.appendItems(posts, toSection: .main)
        dataSource.apply(snapshot)
    }
}

extension PostViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.posts.count - 1 {
            self.fetchPosts()
        }
    }
}

#Preview {
    UINavigationController(rootViewController: PostViewController())
}
