//
//  Plant.swift
//  PlantCare
//
//  Created by Agnes Pontes Ristau on 12/11/26.
//


import UIKit

struct Plant {
    let id: UUID
    var name: String
    var species: String?
    var image: UIImage?
    var wateringFrequency: Int
    var lastWatered: Date
    var reminderEnabled: Bool
    var isFavorite: Bool

    init(
        name: String,
        species: String?,
        image: UIImage?,
        wateringFrequency: Int,
        reminderEnabled: Bool
    ) {
        self.id = UUID()
        self.name = name
        self.species = species
        self.image = image
        self.wateringFrequency = wateringFrequency
        self.lastWatered = Date()
        self.reminderEnabled = reminderEnabled
        self.isFavorite = false
    }

    var nextWateringDate: Date {
        Calendar.current.date(
            byAdding: .day,
            value: wateringFrequency,
            to: lastWatered
        ) ?? lastWatered
    }
}

