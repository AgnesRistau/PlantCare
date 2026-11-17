//
//  ViewController.swift
//  PlantCare
//
//  Created by Agnes Pontes Ristau on 11/11/26.
//

import UIKit

final class GardenViewController: UIViewController {

    // MARK: - Dados

    private var registeredPlants: [Plant] = []

    // MARK: - Título

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.text = "PlantCare"
        label.font = UIFont(name: "Georgia", size: 30)
            ?? .systemFont(ofSize: 30)

        label.textColor = AppColors.forest
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Saudação

    private let greetingLabel: UILabel = {
        let label = UILabel()

        label.text = "Olá, Agnes!"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = AppColors.forest
        label.numberOfLines = 0

        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()

        label.text = "Aqui está o seu jardim."
        label.font = .systemFont(ofSize: 15)
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
        field.font = .systemFont(ofSize: 15)
        field.borderStyle = .none
        field.clearButtonMode = .whileEditing
        field.returnKeyType = .search
        field.translatesAutoresizingMaskIntoConstraints = false

        let searchIcon = UIImageView(
            image: UIImage(systemName: "magnifyingglass")
        )

        searchIcon.tintColor = AppColors.forest
        searchIcon.contentMode = .center

        let iconContainer = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 44,
                height: 48
            )
        )

        searchIcon.frame = CGRect(
            x: 12,
            y: 0,
            width: 24,
            height: 48
        )

        iconContainer.addSubview(searchIcon)

        field.leftView = iconContainer
        field.leftViewMode = .always

        field.heightAnchor.constraint(
            equalToConstant: 48
        ).isActive = true

        return field
    }()

    // MARK: - Organização do cabeçalho

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

    // MARK: - Cards de exemplo

    private lazy var monsteraCard: PlantCardView = {
        let card = PlantCardView()

        card.configure(
            name: "Costela-de-adão",
            watering: "Exemplo • Próxima rega: 2 dias",
            image: UIImage(named: "monstera")
        )

        return card
    }()

    private lazy var pothosCard: PlantCardView = {
        let card = PlantCardView()

        card.configure(
            name: "Jiboia",
            watering: "Exemplo • Próxima rega: Hoje",
            image: UIImage(named: "jiboia")
        )

        return card
    }()

    // MARK: - Área de rolagem

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()

        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false

        return scroll
    }()

    // MARK: - Grade de plantas

    private lazy var cardsStack = CustomStack(
        axis: .vertical,
        arrangedSubviews: [],
        spacing: 12
    )

    // MARK: - Botão adicionar

    private let addButton: UIButton = {
        let button = UIButton(type: .system)

        button.setImage(
            UIImage(systemName: "plus"),
            for: .normal
        )

        button.tintColor = .white
        button.backgroundColor = AppColors.forest
        button.layer.cornerRadius = 30
        button.accessibilityLabel = "Adicionar planta"
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupSearch()
        refreshCards()
    }

    // MARK: - Interface

    private func setupUI() {

        view.backgroundColor = AppColors.background

        view.addSubview(titleLabel)
        view.addSubview(contentStack)
        view.addSubview(scrollView)
        view.addSubview(addButton)

        scrollView.addSubview(cardsStack)

        addButton.addTarget(
            self,
            action: #selector(openAddPlant),
            for: .touchUpInside
        )

        NSLayoutConstraint.activate([

            // Título

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

            // Cabeçalho

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
            ),

            // ScrollView

            scrollView.topAnchor.constraint(
                equalTo: contentStack.bottomAnchor,
                constant: 24
            ),

            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24
            ),

            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24
            ),

            scrollView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),

            // Grade

            cardsStack.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor
            ),

            cardsStack.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor
            ),

            cardsStack.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor
            ),

            cardsStack.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor,
                constant: -90
            ),

            cardsStack.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor
            ),

            // Botão +

            addButton.widthAnchor.constraint(
                equalToConstant: 60
            ),

            addButton.heightAnchor.constraint(
                equalToConstant: 60
            ),

            addButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24
            ),

            addButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            )
        ])
    }

    // MARK: - Pesquisa

    private func setupSearch() {

        searchField.addTarget(
            self,
            action: #selector(searchTextChanged),
            for: .editingChanged
        )
    }

    @objc private func searchTextChanged() {
        refreshCards()
    }

    // MARK: - Criar linhas de cards

    private func addCardRow(
        _ firstCard: PlantCardView,
        _ secondCard: PlantCardView? = nil
    ) {

        var cards: [UIView] = [firstCard]

        if let secondCard {
            cards.append(secondCard)
        } else {
            cards.append(UIView())
        }

        let row = CustomStack(
            axis: .horizontal,
            arrangedSubviews: cards,
            spacing: 12,
            distribution: .fillEqually
        )

        cardsStack.addArrangedSubview(row)
    }

    // MARK: - Abrir cadastro

    @objc private func openAddPlant() {

        let addVC = AddPlantViewController()

        addVC.onSave = { [weak self] plant in
            self?.addPlantToGarden(plant)
        }

        let navigation = UINavigationController(
            rootViewController: addVC
        )

        present(navigation, animated: true)
    }

    // MARK: - Adicionar planta

    private func addPlantToGarden(_ plant: Plant) {

        registeredPlants.append(plant)

        searchField.text = ""
        refreshCards()
    }

    // MARK: - Abrir detalhes de planta cadastrada

    private func openPlantDetails(_ plant: Plant) {

        let detailVC = PlantDetailViewController(
            plant: plant
        )

        // Atualização da planta

        detailVC.onPlantUpdated = { [weak self] updatedPlant in

            guard let self = self,
                  let index = self.registeredPlants.firstIndex(
                    where: { $0.id == updatedPlant.id }
                  ) else {
                return
            }

            self.registeredPlants[index] = updatedPlant
            self.refreshCards()
        }

        // Exclusão da planta

        detailVC.onPlantDeleted = { [weak self] plantID in

            guard let self = self else {
                return
            }

            self.registeredPlants.removeAll {
                $0.id == plantID
            }

            self.refreshCards()
        }

        presentDetail(detailVC)
    }

    // MARK: - Abrir detalhes dos exemplos

    private func openExampleDetails(
        name: String,
        species: String,
        image: UIImage?,
        wateringFrequency: Int
    ) {

        // Planta temporária de demonstração
        let examplePlant = Plant(
            name: name,
            species: species,
            image: image,
            wateringFrequency: wateringFrequency,
            reminderEnabled: false
        )

        let detailVC = PlantDetailViewController(
            plant: examplePlant
        )

        presentDetail(detailVC)
    }

    // MARK: - Apresentar tela de detalhes

    private func presentDetail(
        _ detailVC: PlantDetailViewController
    ) {

        let navigation = UINavigationController(
            rootViewController: detailVC
        )

        detailVC.navigationItem.leftBarButtonItem =
            UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(closePlantDetails)
            )

        present(navigation, animated: true)
    }

    // MARK: - Fechar detalhes

    @objc private func closePlantDetails() {
        dismiss(animated: true)
    }

    // MARK: - Atualizar favorito

    private func updateFavorite(
        plantID: UUID,
        isFavorite: Bool
    ) {

        guard let index = registeredPlants.firstIndex(
            where: { $0.id == plantID }
        ) else {
            return
        }

        registeredPlants[index].isFavorite = isFavorite
    }

    // MARK: - Atualizar cards

    private func refreshCards() {

        // Limpar linhas anteriores

        cardsStack.arrangedSubviews.forEach { row in
            cardsStack.removeArrangedSubview(row)
            row.removeFromSuperview()
        }

        var allCards: [PlantCardView] = []

        let searchText = searchField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            ?? ""

        // Mostrar exemplos se o jardim estiver vazio

        if registeredPlants.isEmpty {

            monsteraCard.onTap = { [weak self] in
                self?.openExampleDetails(
                    name: "Costela-de-adão",
                    species: "Monstera deliciosa",
                    image: UIImage(named: "monstera"),
                    wateringFrequency: 3
                )
            }

            pothosCard.onTap = { [weak self] in
                self?.openExampleDetails(
                    name: "Jiboia",
                    species: "Epipremnum aureum",
                    image: UIImage(named: "jiboia"),
                    wateringFrequency: 4
                )
            }

            let examples: [(String, PlantCardView)] = [
                ("Costela-de-adão", monsteraCard),
                ("Jiboia", pothosCard)
            ]

            allCards = examples
                .filter {
                    searchText.isEmpty ||
                    $0.0.localizedCaseInsensitiveContains(searchText)
                }
                .map { $0.1 }

        } else {

            // Filtrar plantas cadastradas

            let filteredPlants = registeredPlants.filter {
                searchText.isEmpty ||
                $0.name.localizedCaseInsensitiveContains(
                    searchText
                )
            }

            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.locale = Locale(identifier: "pt_BR")

            for plant in filteredPlants {

                let card = PlantCardView()

                card.configure(
                    name: plant.name,
                    watering: "Próxima rega: " +
                        formatter.string(
                            from: plant.nextWateringDate
                        ),
                    image: plant.image
                )

                card.setFavorite(plant.isFavorite)

                // Abrir detalhes

                card.onTap = { [weak self] in
                    self?.openPlantDetails(plant)
                }

                // Favoritar

                card.onFavoriteChanged = { [weak self] favorite in
                    self?.updateFavorite(
                        plantID: plant.id,
                        isFavorite: favorite
                    )
                }

                allCards.append(card)
            }
        }

        // Organizar em duas colunas

        var index = 0

        while index < allCards.count {

            let firstCard = allCards[index]

            let secondCard: PlantCardView? =
                index + 1 < allCards.count
                ? allCards[index + 1]
                : nil

            addCardRow(
                firstCard,
                secondCard
            )

            index += 2
        }
    }
}
