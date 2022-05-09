//
//  AccountInfoViewController.swift
//

import UIKit

final class AccountInfoViewController: UITableViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Int, AccountInfoContent>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Int, AccountInfoContent>
    
    private let presenter: AccountInfoPresenter
    private var dataSource: DataSource!
    
    required init?(coder: NSCoder) { fatalError() }
    
    init?(coder: NSCoder, presenter: AccountInfoPresenter) {
        self.presenter = presenter
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Localized.accountInfoNavigationTitle.value
        
        self.dataSource = DataSource(tableView: self.tableView) { tableView, indexPath, content in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            let hasAction = content.action != nil
            
            var config = cell.defaultContentConfiguration()
            config.text = content.localizedCaption.value
            config.secondaryText = content.secondaryText
            config.textProperties.color = hasAction ? .systemBlue : .label
            cell.contentConfiguration = config
            cell.selectionStyle = hasAction ? .default : .none
            
            return cell
        }
        
        var snapShot = SnapShot()
        for section in 0..<presenter.sections.count {
            snapShot.appendSections([section])
            snapShot.appendItems(presenter.sections[section],
                                 toSection: section)
        }
        self.dataSource.apply(snapShot)
        
        self.tableView.dataSource = self.dataSource
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            self.presenter.viewDidDismiss()
        }
        
        super.viewDidDisappear(animated)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.didSelect(at: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AccountInfoViewController {
    static func instantiate(presenter: AccountInfoPresenter) -> AccountInfoViewController {
        let storyboard = UIStoryboard(name: "AccountInfo", bundle: nil)
        
        guard let viewController = storyboard.instantiateInitialViewController(creator: { coder in
            AccountInfoViewController(coder: coder, presenter: presenter)
        }) else { fatalError() }
        
        return viewController
    }
}
