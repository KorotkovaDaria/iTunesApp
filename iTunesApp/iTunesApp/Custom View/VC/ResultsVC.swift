//
//  ResultsVC.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//

import UIKit

class ResultsVC: UIViewController {
    let tableView                    = UITableView()
    var previouslyReceived: [String] = []
    var searchSuggestions: [String]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureResultsVC() {
        view.backgroundColor = Resources.Colors.blue
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource      = self
        tableView.delegate        = self
        tableView.backgroundColor = Resources.Colors.blue
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    } 
    func updateSearchSuggestions(with suggestions: [String]) {
            searchSuggestions = suggestions
            tableView.reloadData()
        }
}

extension ResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell                 = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let arrowImage           = Resources.ImageTitle.arrowUpBackward
        let arrowImageView       = UIImageView(image: arrowImage)
        arrowImageView.tintColor = Resources.Colors.blue
        cell.selectionStyle      = .none
        cell.textLabel?.text     = searchSuggestions[indexPath.row]
        cell.backgroundColor     = Resources.Colors.seaBlue
        cell.accessoryView       = arrowImageView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSuggestion = searchSuggestions[indexPath.row]
        if let searchVC = presentingViewController as? SearchViewController {
            searchVC.searchController.searchBar.text = selectedSuggestion
            searchVC.viewModel.fetchMediaItem(term: selectedSuggestion)
        }
        dismiss(animated: true, completion: nil)
    }
}
