//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 14/09/24.
//

import Foundation
import UIKit
import ServiceFeature

public class CommentsViewController: UIViewController {
    enum Section: Hashable {
        case main
    }
    
    var offset: Int = 0
    let limit: Int = 15
    private var comments: [Comment] = []
    
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
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Comment> = {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Comment> { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier.name
            cell.contentConfiguration = configuration
        }
        let dataSource = UICollectionViewDiffableDataSource<Section, Comment>(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            return cell
        }
        return dataSource
    }()
    
    public override func viewDidLoad() {
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
        self.navigationItem.title = "Comments"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchPosts() {
        let offset = self.offset
        let limit = self.limit
        Task {
            do {
                let comments = try await ServiceClient.shared.fetchComments(offset: offset, limit: limit)
                if offset == 0 {
                    self.comments = comments
                } else {
                    self.comments.append(contentsOf: comments)
                }
                self.offset = self.comments.count
                self.applySnapshot(with: self.comments)
            }
        }
    }
    
    private func applySnapshot(with comments: [Comment]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Comment>()
        snapshot.appendSections([.main])
        snapshot.appendItems(comments, toSection: .main)
        dataSource.apply(snapshot)
    }
}

extension CommentsViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.comments.count - 1 {
            self.fetchPosts()
        }
    }
}

#Preview {
    CommentsViewController()
}
