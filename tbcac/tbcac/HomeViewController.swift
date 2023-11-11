//
//  HomeViewController.swift
//  tbcac
//
//  Created by user on 11/11/23.
//
import UIKit

enum SectionType: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

final class HomeViewController: UIViewController {
    
    // MARK: Properties
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    private var apiCaller = APICaller.shared
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavBar()
    }
    
    // MARK: UI Setup
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(homeFeedTable)
        configureTable()
        addHeaderView()
    }
    
    private func configureTable() {
        homeFeedTable.frame = view.bounds
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
    }
    
    private func addHeaderView() {
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
    }
    
    // MARK: Navigation Bar
    
    private func configureNavBar() {
        let image = UIImage(systemName: "movieclapper")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        let rightBarButtonItems: [UIBarButtonItem] = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationItem.rightBarButtonItems = rightBarButtonItems
        navigationController?.navigationBar.tintColor = .red
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        fetchDataForSection(indexPath.section) { titles, error in
            if let titles = titles {
                cell.configure(with: titles)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    // Other TableView Delegate Methods...
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset =  scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    // MARK: Data Fetching
    
    private func fetchDataForSection(_ section: Int, completion: @escaping ([String]?, Error?) -> Void) {
        guard let sectionType = SectionType(rawValue: section) else {
            completion(nil, NSError(domain: "SectionType Error", code: 0, userInfo: nil))
            return
        }
        
        switch sectionType {
        case .TrendingMovies:
            apiCaller.getTrendingMovies { result in handleData(result, completion: completion) }
        case .TrendingTv:
            apiCaller.getTrendingTVShows { result in handleData(result, completion: completion) }
        // Handle other cases...
        }
    }
    
    private func handleData(_ result: Result<[String], Error>, completion: @escaping ([String]?, Error?) -> Void) {
        switch result {
        case .success(let titles):
            completion(t
