//
//  ViewController.swift
//  iOS-fetch-GitHub
//
//  Created by David Anglin on 10/9/20.
//

import UIKit

class CommitsViewController: UIViewController {
        
    // MARK: Properties
    weak var coordinator: MainCoordinator?
    internal var viewModel: CommitsVMContract!
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    init(viewModel: CommitsVMContract) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Commits"
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.register(UINib.init(nibName: CommitCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CommitCell.reuseIdentifier)
        
        viewModel.commitsUpdated = tableView.reloadData
        
        viewModel.errorOccured = { [weak self] error in
            guard let error = error else { return }
            self?.showAlert(with: error)
        }
    }
    
    private func showAlert(with error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alertController, animated: true)
    }
}

// MARK: TableView Methods
extension CommitsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.commits.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommitCell.reuseIdentifier, for: indexPath) as? CommitCell,
            indexPath.row < viewModel.commits.count
        else { return UITableViewCell() }
        
        let commit = viewModel.commits[indexPath.row]
        cell.configure(with: commit)
        return cell
    }
}
