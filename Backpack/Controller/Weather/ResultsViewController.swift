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

    private var tableView = UITableView()
    private let reuseID = "cell"
    private var places: [Place] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    // MARK: - View

    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    func update(with places: [Place]) {
        tableView.isHidden = false
        self.places = places
        tableView.reloadData()
    }
}

// MARK: - tableView DataSource

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true

        let place = places[indexPath.row]
        GooglePlacesService.shared.resolveLocation(for: place) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let coordinate):
                DispatchQueue.main.async { self.delegate?.didTapPlace(with: coordinate) }

            case .failure(let error):
                presentAlert(.connectionFailed)
                print(error)
            }
        }
    }
}

// MARK: - tableView Delegate

extension ResultsViewController: UITableViewDelegate {}
