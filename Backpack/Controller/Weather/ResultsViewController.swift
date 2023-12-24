//
//  ResultsViewController.swift
//  Backpack
//
//  Created by Sylvain Druaux on 29/01/2023.
//

import UIKit

protocol ResultsViewControllerDelegate: AnyObject {
    func didTapPlace(with coordinates: Coordinates)
}

final class ResultsViewController: UIViewController {
    // MARK: - Properties

    weak var delegate: ResultsViewControllerDelegate?

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    private var places: [Place] = []

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func update(with places: [Place]) {
        tableView.isHidden = false
        self.places = places
        tableView.reloadData()
    }
}

// MARK: - Extensions

// MARK: - tableView DataSource

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true

        let place = places[indexPath.row]
        GooglePlacesService.shared.resolveLocation(for: place) { [weak self] result in
            switch result {
            case .success(let coordinate):
                DispatchQueue.main.async {
                    self?.delegate?.didTapPlace(with: coordinate)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - tableView Delegate

extension ResultsViewController: UITableViewDelegate {}
