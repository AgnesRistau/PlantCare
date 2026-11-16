//
//  ViewController.swift
//  PlantCare
//
//  Created by Agnes Pontes Ristau on 11/11/26.
//


import UIKit

final class GardenViewController: UIViewController {

    // MARK: - Título

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "PlantCare"
        label.textColor = AppColors.forest

        let font = UIFont(name: "Georgia", size: 30)
            ?? .systemFont(ofSize: 30)

        label.font = UIFontMetrics(
            forTextStyle: .largeTitle
        ).scaledFont(for: font)

        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.accessibilityTraits.insert(.header)

        return label
    }()

    // MARK: - Saudação

    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Olá! 🌿"
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = AppColors.forest
        label.numberOfLines = 0
        label.accessibilityTraits.insert(.header)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Aqui está o seu jardim."
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Pesquisa

    private let searchField: UITextField = {
        let field = UITextField()

        field.placeholder = "Buscar planta..."
        field.backgroundColor = AppColors.card
        field.layer.cornerRadius = 14
        field.borderStyle = .none

        field.font = .preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true

        field.accessibilityLabel = "Buscar planta"
        field.returnKeyType = .search
        field.clearButtonMode = .whileEditing

        let icon = UIImageView(
            image: UIImage(systemName: "magnifyingglass")
        )
        icon.tintColor = AppColors.forest
        icon.contentMode = .center

        let container = UIView(
            frame: CGRect(x: 0, y: 0, width: 44, height: 48)
        )

        icon.frame = CGRect(x: 12, y: 0, width: 24, height: 48)
        container.addSubview(icon)

        field.leftView = container
        field.leftViewMode = .always

        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(
            greaterThanOrEqualToConstant: 48
        ).isActive = true

        return field
    }()

    // MARK: - Organização

    private lazy var greetingStack = CustomStack(
        axis: .vertical,
        arrangedSubviews: [
            greetingLabel,
            subtitleLabel
        ],
        spacing: 6
    )

    private lazy var contentStack = CustomStack(
        axis: .vertical,
        arrangedSubviews: [
            greetingStack,
            searchField
        ],
        spacing: 24
    )

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = AppColors.background

        navigationController?.setNavigationBarHidden(
            true,
            animated: false
        )

        view.addSubview(titleLabel)
        view.addSubview(contentStack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),

            titleLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            titleLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.leadingAnchor,
                constant: 24
            ),

            titleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: view.trailingAnchor,
                constant: -24
            ),

            contentStack.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 36
            ),

            contentStack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24
            ),

            contentStack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24
            )
        ])
    }
}
