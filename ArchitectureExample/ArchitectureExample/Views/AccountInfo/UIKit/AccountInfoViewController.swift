//
//  AccountInfoViewController.swift
//

import UIKit
import Combine

final class AccountInfoViewController: UITableViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Int, AccountInfoContentID>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Int, AccountInfoContentID>

    private let presenter: AccountInfoUIKitPresenter
    private var dataSource: DataSource!
    private var cancellables: Set<AnyCancellable> = .init()

    static func instantiate(presenter: AccountInfoUIKitPresenter) -> AccountInfoViewController {
        let storyboard = UIStoryboard(name: "AccountInfo", bundle: nil)

        guard let viewController = storyboard.instantiateInitialViewController(creator: { coder in
            AccountInfoViewController(coder: coder, presenter: presenter)
        }) else { fatalError() }

        return viewController
    }

    required init?(coder: NSCoder) { fatalError() }

    init?(coder: NSCoder, presenter: AccountInfoUIKitPresenter) {
        self.presenter = presenter
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = Localized.accountInfoNavigationTitle.value

        self.dataSource = DataSource(tableView: self.tableView) { [weak self] tableView, indexPath, contentId in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

            var config = cell.defaultContentConfiguration()

            if let presenter = self?.presenter {
                let content = presenter.content(for: contentId)
                let hasAction = content.action != nil
                config.text = content.localizedCaption.value
                config.secondaryText = content.secondaryText
                config.textProperties.color = hasAction ? .systemBlue : .label
                cell.contentConfiguration = config
                cell.selectionStyle = hasAction ? .default : .none
            } else {
                cell.contentConfiguration = config
                cell.selectionStyle = .none
            }

            return cell
        }

        self.tableView.dataSource = self.dataSource

        var snapShot = SnapShot()
        for section in 0..<self.presenter.contentIds.count {
            snapShot.appendSections([section])
            snapShot.appendItems(self.presenter.contentIds[section],
                                 toSection: section)
        }
        self.dataSource.apply(snapShot)

        self.presenter.$name
            .dropFirst()
            .sink { [weak self] _ in
                guard let self = self else { return }
                var snapShot = self.dataSource.snapshot()
                snapShot.reloadItems([.name])
                self.dataSource.apply(snapShot)
            }.store(in: &self.cancellables)
    }

    override func viewDidDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            self.presenter.viewDidRemoveFromParent()
        }

        super.viewDidDisappear(animated)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let contentID = self.dataSource.itemIdentifier(for: indexPath) {
            self.presenter.didSelect(contentId: contentID)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
