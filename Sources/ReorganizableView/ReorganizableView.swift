//
//  ReorganizableView.swift
//  ReorganizableView
//
//  Created by Sonny Fournier on 20/06/2023.
//

import UIKit

public protocol ReorganizableViewDelegate: AnyObject {
    func reorganizableView(didMoveViews views: [[UIView]])
}

public class ReorganizableView: UIView {

    // MARK: - UI elements
    private let mainStackView = UIStackView()

    // MARK: - Private properties
    private var initialMovingViewCenter: CGPoint = .zero
    private var shouldUpdateViews: Bool = true

    // MARK: - Public properties
    public weak var delegate: ReorganizableViewDelegate?
    public var columns: Int = 3 { didSet { setupColumns() } }
    public var views: [[UIView]] = [] { didSet { setupViews() } }
    public var inset: CGFloat = 10 {
        didSet {
            mainStackView.spacing = inset
            for subview in mainStackView.arrangedSubviews {
                (subview.subviews.first as? UIStackView)?.spacing = inset
            }
        }
    }
    public var radius: CGFloat = 10 {
        didSet {
            for subview in mainStackView.arrangedSubviews {
                subview.layer.cornerRadius = radius
            }
        }
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI setup
    private func setupUI() {
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = inset
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
    }

    // MARK: - Constraints setup
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
        ])
    }

    // MARK: - Actions
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        guard let movingView = panGesture.view else { return }

        // Save initial center
        if panGesture.state == .began { initialMovingViewCenter = movingView.center }

        // Get translation
        let translation = panGesture.translation(in: self)
        panGesture.setTranslation(CGPoint(x: 0.0, y: 0.0), in: self)

        // Bring the moving view to the front
        var superview = movingView.superview
        while superview != nil {
            superview?.superview?.bringSubview(toFront: superview!)
            superview = superview?.superview
        }
        movingView.superview?.bringSubview(toFront: movingView)

        // Move it
        movingView.center = CGPoint(x: movingView.center.x + translation.x, y: movingView.center.y + translation.y)

        // Re-position moving view when pan ends
        if panGesture.state == .ended {
            let convertedMovingFrame = movingView.convert(movingView.bounds, to: self)
            var containerViewsFrames: [CGRect] = []
            for subview in mainStackView.arrangedSubviews {
                containerViewsFrames.append(subview.convert(subview.bounds, to: self))
            }

            let movingViewCenter = CGPoint(x: convertedMovingFrame.origin.x + (convertedMovingFrame.width / 2),
                                           y: convertedMovingFrame.origin.y + (convertedMovingFrame.height / 2))

            for (index, frame) in containerViewsFrames.enumerated() where frame.contains(movingViewCenter) {
                for (index, views) in views.enumerated() {
                    for view in views where view == movingView {
                        self.views[index].removeAll(where: { $0 == movingView })
                    }
                }
                shouldUpdateViews = false
                views[index].append(movingView)
                shouldUpdateViews = true
                movingView.removeFromSuperview()
                (mainStackView.arrangedSubviews[index].subviews.first as? UIStackView)?.addArrangedSubview(movingView)
                delegate?.reorganizableView(didMoveViews: views)
                layoutSubviews()
            }

            movingView.center = initialMovingViewCenter
        }
    }

    // MARK: - Functions
    private func setupColumns() {
        for subview in mainStackView.arrangedSubviews { mainStackView.removeArrangedSubview(subview) }

        for _ in 0..<columns {
            let containerView = UIView()
            containerView.backgroundColor = .secondarySystemBackground
            containerView.layer.cornerRadius = radius
            mainStackView.addArrangedSubview(containerView)

            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = inset
            stackView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(stackView)

            NSLayoutConstraint.activate([
                stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: inset),
                stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -inset),
                stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: inset),
                stackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -inset)
            ])
        }
    }

    private func setupViews() {
        guard shouldUpdateViews else { return }

        // Remove all previous views
        for mainSubview in mainStackView.arrangedSubviews {
            for subview in (mainSubview.subviews.first as? UIStackView)?.arrangedSubviews ?? [] {
                (mainSubview.subviews.first as? UIStackView)?.removeArrangedSubview(subview)
            }
        }

        // Add views in stackviews
        for (index, views) in views.enumerated() {
            guard mainStackView.arrangedSubviews.count > index else { return }

            for view in views {
                let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(panGesture:)))
                view.addGestureRecognizer(gestureRecognizer)
                view.isUserInteractionEnabled = true
                (mainStackView.arrangedSubviews[index].subviews.first as? UIStackView)?.addArrangedSubview(view)
            }
        }
    }

}

