//
//  CustomStack.swift
//  PlantCare
//
//  Created by Agnes Pontes Ristau on 16/11/26.
//


import UIKit

final class CustomStack: UIStackView {

    init(
        axis: NSLayoutConstraint.Axis,
        arrangedSubviews: [UIView],
        spacing: CGFloat = 16,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill
    ) {

        super.init(frame: .zero)

        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution

        translatesAutoresizingMaskIntoConstraints = false

        arrangedSubviews.forEach {
            addArrangedSubview($0)
        }
    }

    required init(coder: NSCoder) {
        fatalError("Use inicialização programática")
    }
}
