//
//  PlantCardView.swift
//  PlantCare
//
//  Created by Agnes Pontes Ristau on 12/11/26.
//


import UIKit

final class PlantCardView: UIView {

    // MARK: - Ações

    var onTap: (() -> Void)?
    var onFavoriteChanged: ((Bool) -> Void)?

    // MARK: - Imagem

    private let plantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColors.sage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Nome

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = AppColors.forest
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Próxima rega

    private let wateringLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Favoritos

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: "heart"),
            for: .normal
        )
        button.tintColor = AppColors.forest
        button.accessibilityLabel = "Favoritar planta"
        return button
    }()

    private var isFavorite = false

    // MARK: - Inicialização

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("Use inicialização programática")
    }

    // MARK: - Interface

    private func setupUI() {
        backgroundColor = AppColors.card
        layer.cornerRadius = 16
        clipsToBounds = true

        let titleStack = CustomStack(
            axis: .horizontal,
            arrangedSubviews: [
                nameLabel,
                favoriteButton
            ],
            spacing: 4,
            alignment: .center
        )

        favoriteButton.setContentHuggingPriority(
            .required,
            for: .horizontal
        )

        let infoStack = CustomStack(
            axis: .vertical,
            arrangedSubviews: [
                titleStack,
                wateringLabel
            ],
            spacing: 8
        )

        addSubview(plantImageView)
        addSubview(infoStack)

        NSLayoutConstraint.activate([

            plantImageView.topAnchor.constraint(
                equalTo: topAnchor
            ),

            plantImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            plantImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),

            plantImageView.heightAnchor.constraint(
                equalTo: plantImageView.widthAnchor,
                multiplier: 0.85
            ),

            infoStack.topAnchor.constraint(
                equalTo: plantImageView.bottomAnchor,
                constant: 12
            ),

            infoStack.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 12
            ),

            infoStack.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -12
            ),

            infoStack.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -12
            )
        ])

        // Toque no card
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(cardTapped)
        )

        addGestureRecognizer(tapGesture)

        // Toque no coração
        favoriteButton.addTarget(
            self,
            action: #selector(toggleFavorite),
            for: .touchUpInside
        )
    }

    // MARK: - Configurar planta

    func configure(
        name: String,
        watering: String,
        image: UIImage?
    ) {
        nameLabel.text = name
        wateringLabel.text = watering
        plantImageView.image = image
    }

    // MARK: - Atualizar favorito

    func setFavorite(_ favorite: Bool) {
        isFavorite = favorite

        let icon = favorite ? "heart.fill" : "heart"

        favoriteButton.setImage(
            UIImage(systemName: icon),
            for: .normal
        )

        favoriteButton.accessibilityLabel = favorite
            ? "Remover dos favoritos"
            : "Favoritar planta"
    }

    // MARK: - Abrir detalhes

    @objc private func cardTapped() {
        onTap?()
    }

    // MARK: - Favoritar

    @objc private func toggleFavorite() {
        setFavorite(!isFavorite)
        onFavoriteChanged?(isFavorite)
    }
}
