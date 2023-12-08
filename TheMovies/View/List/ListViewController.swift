//
//  ListViewController.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 19/04/22.
//

import UIKit

class ListViewController: UIViewController {

    private var viewModel: ListViewModel
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Trending Movies"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .cTheme
        return label
    }()
   
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.cellID)
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        
        return tableView
    }()
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        bindViewModel()
        viewModel.loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// Hide navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        /// Show navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    private func bindViewModel() {
        viewModel.didStartLoading = {
            LoadingView.show()
        }
        viewModel.didStopLoading = {
            LoadingView.hide()
        }
        viewModel.didShowError = { errorTitle, errorMessage in
            DispatchQueue.main.async {
                self.showAlert(title: errorTitle, message: errorMessage)
            }
        }
        viewModel.didReload = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Tableview Delegate & Datasource
extension ListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:ListTableViewCell.cellID, for: indexPath) as? ListTableViewCell ?? ListTableViewCell(style: .default, reuseIdentifier: ListTableViewCell.cellID)
        cell.configure(with: viewModel.getMovieData(index: indexPath.row), imageService: viewModel.imageService)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.handlePagination(at: indexPath.row)
    }
}
//MARK: - Setup
extension ListViewController {
    private func setupViews() {
        view.backgroundColor = .cBackground
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.darkText]
        tableView.backgroundColor = .clear
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            titleLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -20.0),
            titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20.0),
            titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20.0),
            tableView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8.0)
        ])
    }
}

