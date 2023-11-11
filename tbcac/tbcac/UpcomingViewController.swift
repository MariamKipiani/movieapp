//
//  UpcomingViewController.swift
//  tbcac
//
//  Created by user on 11/11/23.
//

import UIKit

final class UpcomingViewController: UIViewController {
    private var titles: [Title] = []
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(upcomingTable)
        configureTableView()
    }
    
    private func configureTableView() {
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
                case .success(let titles):
                    self?.titles = titles
                    DispatchQueue.main.async {
                        self?.upcomingTable.reloadData()
                    }
                case .failure(let error):
                    print("Error fetching upcoming movies: \(error.localizedDescription)")
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        if let title = titles[safe: indexPath.row] {
            let titleName = title.originalTitle ?? title.originalName ?? "Unknown title name"
            let posterURL = title.posterPath ?? ""
            cell.configure(with: TitleViewModel(titleName: titleName, posterURL: posterURL))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
