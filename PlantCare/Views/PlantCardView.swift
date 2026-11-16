//
//  PlantCardView.swift
//  PlantCare
//
//  Created by Agnes Pontes Ristau on 12/11/26.
//

import UIKit

class PlantCardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .white

        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
}
