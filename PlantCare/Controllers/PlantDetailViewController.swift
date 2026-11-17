//
//  PlantDetailViewController.swift
//  PlantCare
//
//  Created by Agnes Pontes Ristau on 12/11/26.
//


import UIKit

final class PlantDetailViewController: UIViewController {

    // MARK: - Dados

    private var plant: Plant

    var onPlantUpdated: ((Plant) -> Void)?
    var onPlantDeleted: ((UUID) -> Void)?

    private var wateringHistory: [Date] = []

    // MARK: - Componentes

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let plantImageView = UIImageView()
    private let nameLabel = UILabel()
    private let speciesLabel = UILabel()

    private let frequencyValueLabel = UILabel()
    private let nextWateringValueLabel = UILabel()

    private let favoriteButton = UIButton(type: .system)
    private let waterButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)

    private let historyTitleLabel = UILabel()
    private let historyStack = UIStackView()

    // MARK: - Inicialização

    init(plant: Plant) {
        self.plant = plant
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Use init(plant:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
        updateInformation()
        updateHistory()
    }

    // MARK: - Interface

    private func setupUI() {

        view.backgroundColor = AppColors.background
        navigationItem.title = ""

        // Coração de favoritos

        favoriteButton.tintColor = AppColors.forest

        favoriteButton.addTarget(
            self,
            action: #selector(toggleFavorite),
            for: .touchUpInside
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: favoriteButton
        )

        // ScrollView

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        contentStack.axis = .vertical
        contentStack.spacing = 16

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        // Fotografia

        plantImageView.contentMode = .scaleAspectFill
        plantImageView.clipsToBounds = true
        plantImageView.layer.cornerRadius = 24
        plantImageView.backgroundColor = AppColors.sage
        plantImageView.translatesAutoresizingMaskIntoConstraints = false

        plantImageView.heightAnchor.constraint(
            equalToConstant: 220
        ).isActive = true

        // Nome

        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0

        // Espécie

        speciesLabel.font = .italicSystemFont(ofSize: 15)
        speciesLabel.textColor = .darkGray
        speciesLabel.numberOfLines = 0

        // Cards de informações

        let frequencyCard = makeInfoCard(
            icon: "drop.fill",
            title: "Rega",
            valueLabel: frequencyValueLabel
        )

        let nextWateringCard = makeInfoCard(
            icon: "bell",
            title: "Próxima rega",
            valueLabel: nextWateringValueLabel
        )

        let infoRow = UIStackView(
            arrangedSubviews: [
                frequencyCard,
                nextWateringCard
            ]
        )

        infoRow.axis = .horizontal
        infoRow.spacing = 12
        infoRow.distribution = .fillEqually

        // Botão registrar rega

        waterButton.setTitle(
            "Registrar rega",
            for: .normal
        )

        waterButton.setImage(
            UIImage(systemName: "drop.fill"),
            for: .normal
        )

        waterButton.tintColor = .white
        waterButton.setTitleColor(.white, for: .normal)
        waterButton.backgroundColor = AppColors.forest
        waterButton.layer.cornerRadius = 24

        waterButton.titleLabel?.font =
            .boldSystemFont(ofSize: 16)

        waterButton.heightAnchor.constraint(
            equalToConstant: 52
        ).isActive = true

        waterButton.addTarget(
            self,
            action: #selector(registerWatering),
            for: .touchUpInside
        )

        // Histórico

        historyTitleLabel.text = "Histórico de regas"
        historyTitleLabel.font = .boldSystemFont(ofSize: 18)
        historyTitleLabel.textColor = .black

        historyStack.axis = .vertical
        historyStack.spacing = 8

        // Botão excluir planta

        deleteButton.setTitle(
            "Excluir planta",
            for: .normal
        )

        deleteButton.setImage(
            UIImage(systemName: "trash"),
            for: .normal
        )

        deleteButton.tintColor = .systemRed

        deleteButton.setTitleColor(
            .systemRed,
            for: .normal
        )

        deleteButton.titleLabel?.font =
            .boldSystemFont(ofSize: 16)

        deleteButton.layer.cornerRadius = 14
        deleteButton.layer.borderWidth = 1
        deleteButton.layer.borderColor =
            UIColor.systemRed.cgColor

        deleteButton.heightAnchor.constraint(
            equalToConstant: 50
        ).isActive = true

        deleteButton.addTarget(
            self,
            action: #selector(deletePlant),
            for: .touchUpInside
        )

        // Organizar componentes

        [
            plantImageView,
            nameLabel,
            speciesLabel,
            infoRow,
            waterButton,
            historyTitleLabel,
            historyStack,
            deleteButton
        ].forEach {
            contentStack.addArrangedSubview($0)
        }

        contentStack.setCustomSpacing(
            8,
            after: nameLabel
        )

        contentStack.setCustomSpacing(
            24,
            after: speciesLabel
        )

        contentStack.setCustomSpacing(
            24,
            after: infoRow
        )

        contentStack.setCustomSpacing(
            24,
            after: waterButton
        )

        contentStack.setCustomSpacing(
            24,
            after: historyStack
        )
    }

    // MARK: - Card de informações

    private func makeInfoCard(
        icon: String,
        title: String,
        valueLabel: UILabel
    ) -> UIView {

        let card = UIView()

        card.backgroundColor = AppColors.card
        card.layer.cornerRadius = 14

        let iconView = UIImageView(
            image: UIImage(systemName: icon)
        )

        iconView.tintColor = AppColors.forest
        iconView.contentMode = .scaleAspectFit

        iconView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20)
        ])

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .black

        valueLabel.font = .systemFont(ofSize: 12)
        valueLabel.textColor = .darkGray
        valueLabel.numberOfLines = 2

        let textStack = UIStackView(
            arrangedSubviews: [
                titleLabel,
                valueLabel
            ]
        )

        textStack.axis = .vertical
        textStack.spacing = 5

        let row = UIStackView(
            arrangedSubviews: [
                iconView,
                textStack
            ]
        )

        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .center

        row.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(row)

        NSLayoutConstraint.activate([

            row.topAnchor.constraint(
                equalTo: card.topAnchor,
                constant: 14
            ),

            row.leadingAnchor.constraint(
                equalTo: card.leadingAnchor,
                constant: 10
            ),

            row.trailingAnchor.constraint(
                equalTo: card.trailingAnchor,
                constant: -10
            ),

            row.bottomAnchor.constraint(
                equalTo: card.bottomAnchor,
                constant: -14
            )
        ])

        return card
    }

    // MARK: - Constraints

    private func setupConstraints() {

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            contentStack.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor,
                constant: 16
            ),

            contentStack.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor,
                constant: 24
            ),

            contentStack.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor,
                constant: -24
            ),

            contentStack.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor,
                constant: -24
            ),

            contentStack.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor,
                constant: -48
            )
        ])
    }

    // MARK: - Atualizar informações

    private func updateInformation() {

        plantImageView.image = plant.image
        nameLabel.text = plant.name

        speciesLabel.text =
            plant.species ?? "Espécie não informada"

        frequencyValueLabel.text =
            "A cada \(plant.wateringFrequency) dias"

        let calendar = Calendar.current

        let today = calendar.startOfDay(
            for: Date()
        )

        let nextDay = calendar.startOfDay(
            for: plant.nextWateringDate
        )

        let days = calendar.dateComponents(
            [.day],
            from: today,
            to: nextDay
        ).day ?? 0

        if days < 0 {
            nextWateringValueLabel.text = "Atrasada"
        } else if days == 0 {
            nextWateringValueLabel.text = "Hoje"
        } else if days == 1 {
            nextWateringValueLabel.text = "Amanhã"
        } else {
            nextWateringValueLabel.text =
                "Em \(days) dias"
        }

        let heartIcon = plant.isFavorite
            ? "heart.fill"
            : "heart"

        favoriteButton.setImage(
            UIImage(systemName: heartIcon),
            for: .normal
        )
    }

    // MARK: - Favoritar

    @objc private func toggleFavorite() {

        plant.isFavorite.toggle()

        updateInformation()

        onPlantUpdated?(plant)
    }

    // MARK: - Registrar rega

    @objc private func registerWatering() {

        let today = Date()

        let alreadyWateredToday = wateringHistory.contains {
            Calendar.current.isDate(
                $0,
                inSameDayAs: today
            )
        }

        if alreadyWateredToday {

            let alert = UIAlertController(
                title: "Planta já regada! 🌱",
                message: "Você já registrou uma rega hoje.",
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default
                )
            )

            present(alert, animated: true)
            return
        }

        plant.lastWatered = today

        wateringHistory.insert(
            today,
            at: 0
        )

        updateInformation()
        updateHistory()

        onPlantUpdated?(plant)

        let alert = UIAlertController(
            title: "Rega registrada! 🌱",
            message: "A próxima rega foi atualizada.",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)
    }

    // MARK: - Histórico de regas

    private func updateHistory() {

        historyStack.arrangedSubviews.forEach { view in
            historyStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        if wateringHistory.isEmpty {

            let emptyLabel = UILabel()

            emptyLabel.text =
                "Nenhuma rega registrada ainda."

            emptyLabel.font =
                .systemFont(ofSize: 14)

            emptyLabel.textColor = .darkGray

            historyStack.addArrangedSubview(
                emptyLabel
            )

            return
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "pt_BR")

        for date in wateringHistory {

            let row = UIStackView()

            row.axis = .horizontal
            row.alignment = .center
            row.spacing = 12

            let calendarIcon = UIImageView(
                image: UIImage(systemName: "calendar")
            )

            calendarIcon.tintColor = AppColors.forest

            let dateLabel = UILabel()
            dateLabel.text = formatter.string(from: date)
            dateLabel.font = .systemFont(ofSize: 14)

            let checkIcon = UIImageView(
                image: UIImage(systemName: "checkmark")
            )

            checkIcon.tintColor = AppColors.forest

            row.addArrangedSubview(calendarIcon)
            row.addArrangedSubview(dateLabel)
            row.addArrangedSubview(UIView())
            row.addArrangedSubview(checkIcon)

            let container = UIView()

            container.backgroundColor = AppColors.card
            container.layer.cornerRadius = 12

            row.translatesAutoresizingMaskIntoConstraints = false

            container.addSubview(row)

            NSLayoutConstraint.activate([

                row.topAnchor.constraint(
                    equalTo: container.topAnchor,
                    constant: 14
                ),

                row.leadingAnchor.constraint(
                    equalTo: container.leadingAnchor,
                    constant: 12
                ),

                row.trailingAnchor.constraint(
                    equalTo: container.trailingAnchor,
                    constant: -12
                ),

                row.bottomAnchor.constraint(
                    equalTo: container.bottomAnchor,
                    constant: -14
                )
            ])

            historyStack.addArrangedSubview(
                container
            )
        }
    }

    // MARK: - Excluir planta

    @objc private func deletePlant() {

        let alert = UIAlertController(
            title: "Excluir planta?",
            message: "A planta e seu histórico de regas serão excluídos. Essa ação não poderá ser desfeita.",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(
            title: "Cancelar",
            style: .cancel
        )

        let deleteAction = UIAlertAction(
            title: "Excluir planta",
            style: .destructive
        ) { [weak self] _ in

            guard let self = self else {
                return
            }

            self.onPlantDeleted?(self.plant.id)

            self.dismiss(animated: true)
        }

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true)
    }
}
