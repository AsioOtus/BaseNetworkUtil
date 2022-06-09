import Foundation
import Combine

@available(iOS 13.0, *)
public typealias Serial = SerialDecorator

@available(iOS 13.0, *)
public class SerialDecorator: NetworkController {
	private let semaphore: DispatchSemaphore

	public let controller: NetworkController
	public let identificationInfo: IdentificationInfo

	public init (
		_ controller: NetworkController,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.semaphore = DispatchSemaphore(value: 1)
		self.controller = controller
		self.identificationInfo = IdentificationInfo(
			module: Info.moduleName,
			type: String(describing: Self.self),
			file: file,
			line: line,
			label: label
		)
	}
}

@available(iOS 13.0, *)
public extension SerialDecorator {
	func send <RD: RequestDelegate> (_ requestDelegate: RD, label: String? = nil) -> AnyPublisher<RD.ContentType, RD.ErrorType> {
		let requestInfo = RequestInfo(
			uuid: UUID(),
			label: label,
			delegate: requestDelegate.name,
			controllers: [identificationInfo]
		)

		return send(requestDelegate, requestInfo)
	}

	func send <RD: RequestDelegate>(_ requestDelegate: RD, _ requestInfo: RequestInfo) -> AnyPublisher<RD.ContentType, RD.ErrorType> {
		Just(requestDelegate)
			.wait(for: semaphore)
			.mapError { requestDelegate.error(RequestError.generalFailure($0), requestInfo) }
            .flatMap { self.controller.send($0, requestInfo).eraseToAnyPublisher() }
			.signal(semaphore)
			.mapError { requestDelegate.error(RequestError.generalFailure($0), requestInfo) }
			.eraseToAnyPublisher()
	}
}

@available(iOS 13.0, *)
public extension NetworkController {
	func serial (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> Serial {
		.init(self, label: label, file: file, line: line)
	}
}
