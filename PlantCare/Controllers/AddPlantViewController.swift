//
//  AddPlantViewController.swift
//  PlantCare
//
//  Created by Agnes Pontes Ristau on 12/11/26.
//


import UIKit
import PhotosUI

final class AddPlantViewController: UIViewController {

    // MARK: - Comunicação com o Jardim

    var onSave: ((Plant) -> Void)?

    // MARK: - Componentes

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let photoButton = UIButton(type: .system)

    private let plantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameField = UITextField()
    private let speciesField = UITextField()
    private let frequencyField = UITextField()
    private let reminderSwitch = UISwitch()
    private let saveButton = UIButton(type: .system)

    // Guarda a fotografia selecionada
    private var selectedImage: UIImage?

    // MARK: - Ciclo de vida

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
    }

    // MARK: - Configuração da interface

    private func setupUI() {

        view.backgroundColor = AppColors.background

        title = "Adicionar planta"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )

        // ScrollView

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 20

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        // MARK: - Área da fotografia

        photoButton.setTitle(
            "Adicionar foto da planta",
            for: .normal
        )

        photoButton.setTitleColor(
            AppColors.forest,
            for: .normal
        )

        photoButton.titleLabel?.font = .systemFont(
            ofSize: 17,
            weight: .medium
        )

        photoButton.backgroundColor = AppColors.sage
        photoButton.layer.cornerRadius = 16
        photoButton.clipsToBounds = true
        photoButton.translatesAutoresizingMaskIntoConstraints = false

        photoButton.heightAnchor.constraint(
            equalToConstant: 170
        ).isActive = true

        // UIImageView dentro do botão

        photoButton.addSubview(plantImageView)

        NSLayoutConstraint.activate([

            plantImageView.topAnchor.constraint(
                equalTo: photoButton.topAnchor
            ),

            plantImageView.leadingAnchor.constraint(
                equalTo: photoButton.leadingAnchor
            ),

            plantImageView.trailingAnchor.constraint(
                equalTo: photoButton.trailingAnchor
            ),

            plantImageView.bottomAnchor.constraint(
                equalTo: photoButton.bottomAnchor
            )
        ])

        photoButton.addTarget(
            self,
            action: #selector(selectPhoto),
            for: .touchUpInside
        )

        photoButton.accessibilityLabel = "Selecionar foto da planta"

        // MARK: - Campos de cadastro

        configureField(
            nameField,
            placeholder: "Nome da planta"
        )

        configureField(
            speciesField,
            placeholder: "Espécie (opcional)"
        )

        configureField(
            frequencyField,
            placeholder: "Frequência de rega (dias)"
        )

        frequencyField.keyboardType = .numberPad

        // MARK: - Lembrete de rega

        let reminderLabel = UILabel()

        reminderLabel.text = "Ativar lembrete de rega"
        reminderLabel.font = .systemFont(ofSize: 16)
        reminderLabel.numberOfLines = 0

        reminderSwitch.onTintColor = AppColors.forest

        let reminderStack = UIStackView(
            arrangedSubviews: [
                reminderLabel,
                reminderSwitch
            ]
        )

        reminderStack.axis = .horizontal
        reminderStack.alignment = .center
        reminderStack.spacing = 12

        reminderSwitch.setContentHuggingPriority(
            .required,
            for: .horizontal
        )

        // MARK: - Botão salvar

        saveButton.setTitle(
            "Salvar planta",
            for: .normal
        )

        saveButton.backgroundColor = AppColors.forest

        saveButton.setTitleColor(
            .white,
            for: .normal
        )

        saveButton.titleLabel?.font = .boldSystemFont(
            ofSize: 17
        )

        saveButton.layer.cornerRadius = 14

        saveButton.heightAnchor.constraint(
            equalToConstant: 52
        ).isActive = true

        saveButton.addTarget(
            self,
            action: #selector(savePlant),
            for: .touchUpInside
        )

        // MARK: - Organizar componentes

        [
            photoButton,
            nameField,
            speciesField,
            frequencyField,
            reminderStack,
            saveButton
        ].forEach {
            contentStack.addArrangedSubview($0)
        }
    }

    // MARK: - Configuração dos campos

    private func configureField(
        _ field: UITextField,
        placeholder: String
    ) {

        field.placeholder = placeholder
        field.backgroundColor = .white
        field.borderStyle = .roundedRect
        field.font = .systemFont(ofSize: 16)

        field.heightAnchor.constraint(
            equalToConstant: 50
        ).isActive = true
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
                constant: 24
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

    // MARK: - Abrir galeria

    @objc private func selectPhoto() {

        var configuration = PHPickerConfiguration()

        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(
            configuration: configuration
        )

        picker.delegate = self

        present(
            picker,
            animated: true
        )
    }

    // MARK: - Cancelar cadastro

    @objc private func cancelTapped() {

        dismiss(animated: true)
    }

    // MARK: - Salvar planta

    @objc private func savePlant() {

        let name = nameField.text?
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            ) ?? ""

        // Validar nome

        guard !name.isEmpty else {

            showAlert(
                "Informe o nome da planta."
            )

            return
        }

        // Validar frequência

        guard let frequency = Int(
            frequencyField.text ?? ""
        ), frequency > 0 else {

            showAlert(
                "Informe uma frequência válida em dias."
            )

            return
        }

        // Espécie opcional

        let species = speciesField.text?
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        // Criar planta

        let plant = Plant(
            name: name,
            species: species?.isEmpty == true
                ? nil
                : species,
            image: selectedImage,
            wateringFrequency: frequency,
            reminderEnabled: reminderSwitch.isOn
        )

        // Enviar planta para o Jardim

        onSave?(plant)

        // Fechar cadastro

        dismiss(animated: true)
    }

    // MARK: - Mensagens de alerta

    private func showAlert(_ message: String) {

        let alert = UIAlertController(
            title: "Atenção",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(
            alert,
            animated: true
        )
    }
}

// MARK: - Seleção de fotografias

extension AddPlantViewController: PHPickerViewControllerDelegate {

    func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {

        // Fechar galeria

        picker.dismiss(animated: true)

        // Verificar se uma fotografia foi escolhida

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(
                ofClass: UIImage.self
              ) else {
            return
        }

        // Carregar fotografia

        provider.loadObject(
            ofClass: UIImage.self
        ) { [weak self] object, error in

            guard let image = object as? UIImage else {
                return
            }

            // Atualizar interface na thread principal

            DispatchQueue.main.async {

                // Guardar fotografia
                self?.selectedImage = image

                // Mostrar fotografia
                self?.plantImageView.image = image

                // Remover texto inicial
                self?.photoButton.setTitle(
                    nil,
                    for: .normal
                )

                self?.photoButton.accessibilityLabel =
                    "Alterar foto da planta"
            }
        }
    }
}
