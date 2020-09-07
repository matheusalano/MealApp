//
//  QuickSpec+BDT.swift
//  MealAppTests
//
//  Created by Matheus Alano on 07/09/20.
//  Copyright © 2020 Matheus Alano. All rights reserved.
//

import Quick

extension QuickSpec {
    func given(_ description: String, flags: FilterFlags = [:], closure: () -> Void) {
        context(description, flags: flags, closure: closure)
    }

    func when(_ description: String, flags: FilterFlags = [:], closure: () -> Void) {
        context(description, flags: flags, closure: closure)
    }

    func then(_ description: String, flags: FilterFlags = [:], closure: @escaping () -> Void) {
        it(description, flags: flags, closure: closure)
    }
}
