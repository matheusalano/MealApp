//
//  MACategoriesViewModelTests.swift
//  MealAppTests
//
//  Created by Matheus Alano on 07/09/20.
//  Copyright © 2020 Matheus Alano. All rights reserved.
//

import Nimble
import Quick
import RxSwift
import RxTest

@testable import MealApp

final class MACategoriesViewModelTests: QuickSpec {
    private var sut: MACategoriesViewModel!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func spec() {
        super.spec()

        start()
    }

    private func setup() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()

        sut = MACategoriesViewModel()
    }

    private func start() {
        describe("MACategoriesViewModel") {
            when("when left bar button is pressed") {
                beforeEach {
                    self.setup()

                    self.scheduler.createHotObservable([.next(300, ())])
                        .bind(to: self.sut.didTapLeftBarButton)
                        .disposed(by: self.disposeBag)
                }

                then("then settings scene must be requested") {
                    let observer = self.scheduler.start({ self.sut.navigationTarget.asObservable() })
                    expect(observer.events).to(equal([.next(300, .settings)]))
                }
            }
        }
    }
}
