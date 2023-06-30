//
//  ViewController.swift
//  ReorganizableViewExampleApp
//
//  Created by Sonny Fournier on 20/06/2023.
//

import UIKit
import ReorganizableView

class ViewController: UIViewController {

    // MARK: - UI elements
    private let reorganizableView = ReorganizableView()

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

        reorganizableView.translatesAutoresizingMaskIntoConstraints = false

        var views1: [UIView] = []
        let view1Texts = ["Text 1", "Text 1"]
        for text in view1Texts {
            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
            label.backgroundColor = .systemBackground
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.systemGray3.cgColor
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([label.heightAnchor.constraint(equalToConstant: 40)])
            views1.append(label)
        }

        var views2: [UIView] = []
        let view2Texts = ["Text 2", "Text 2"]
        for text in view2Texts {
            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
            label.backgroundColor = .systemBackground
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.systemGray3.cgColor
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([label.heightAnchor.constraint(equalToConstant: 40)])
            views2.append(label)
        }

        var views3: [UIView] = []
        let view3Texts = ["Text 3", "Text 3"]
        for text in view3Texts {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "star")
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([imageView.heightAnchor.constraint(equalToConstant: 40)])
            views3.append(imageView)
        }

        reorganizableView.delegate = self
        reorganizableView.columns = 3
        reorganizableView.views = [views1, views2, views3]
        view.addSubview(reorganizableView)
    }

    // MARK: - Constraints setup
    private func setupConstraints() {
        reorganizableView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            reorganizableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            reorganizableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            reorganizableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }

}

// MARK: - ReorganizableView Delegate
extension ViewController: ReorganizableViewDelegate {

    func reorganizableView(didMoveViews views: [[UIView]]) {
        print("Views[0]: \(views[0])")
        print("Views[1]: \(views[1])")
        print("Views[2]: \(views[2])")
        print()
    }

}
