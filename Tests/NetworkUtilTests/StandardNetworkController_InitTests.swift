import XCTest
@testable import NetworkUtil

final class StandardNetworkController_InitTests: XCTestCase {
	func test_minimalInit () {
		// MARK: Act
		_ = StandardNetworkController(configuration: .empty)

		// MARK: Assert
		XCTAssert(true)
	}

//	func test_minimalSend () async throws {
//		// MARK: Arrange
//		let sending: SendingTypeErased = { _, _, _, _, _ in
//			(.init(), .init())
//		}
//
//		let sut = StandardNetworkController(
//			configuration: .init(
//				method: <#T##HTTPMethod?#>,
//				urlElements: <#T##RequestConfiguration.URLElements#>,
//				headers: <#T##RequestConfiguration.Headers#>,
//				timeout: <#T##Double?#>,
//				info: <#T##RequestConfiguration.Info#>
//			),
//			delegate: .delegate(sending: sending)
//		)
//
//		// MARK: Act
//		_ = try await sut.send(.get())
//
//		// MARK: Assert
//		XCTAssert(true)
//	}
}
