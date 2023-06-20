//
//  ViewController.swift
//  ReorganizableViewExampleApp
//
//  Created by Sonny Fournier on 20/06/2023.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - UI elements
    //

    // MARK: - Properties
    //

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
    }

    // MARK: - UI setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }

    // MARK: - Constraints setup
    private func setupConstraints() {
        //
    }

    // MARK: - Actions
    //

    // MARK: - Functions
    //

}
