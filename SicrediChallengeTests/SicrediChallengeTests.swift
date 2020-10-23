//
//  SicrediChallengeTests.swift
//  SicrediChallengeTests
//
//  Created by Luiz Felipe Trindade on 17/10/20.
//

import RxSwift
import XCTest

@testable import SicrediChallenge

class SicrediChallengeTests: XCTestCase {

    var viewModel: GuestListViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!

    override func setUp() {
        super.setUp()
        let person =   Person(picture: "pic.jpge", name: "Luiz", eventID: "1", id: "1")
        let guests: [Person] = [person]
        viewModel = GuestListViewModel(person:guests)
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }

    func test_Pic() throws {
        let pic = viewModel.getPicAt(0)
        XCTAssertEqual(pic, "pic.jpge")
    }
}
