//
//  EventTest.swift
//  SicrediChallengeTests
//
//  Created by Luiz Felipe Trindade on 22/10/20.
//

import XCTest
import RxSwift

@testable import SicrediChallenge

class EventTest: XCTestCase {
    
    var viewModel: EventListViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        viewModel = EventListViewModel()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }
    
    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        scheduler = nil
        super.tearDown()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
