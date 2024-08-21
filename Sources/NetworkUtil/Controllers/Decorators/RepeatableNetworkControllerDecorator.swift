import Foundation

public struct RepeatableNetworkControllerDecorator: NetworkControllerDecorator {
	public let maxAttempts: Int?
	public let delayStrategy: (Int) -> Int

	public let networkController: NetworkController

	public init (
		maxAttempts: Int?,
		delayStrategy: @escaping (Int) -> Int,
		networkController: NetworkController
	) {
		self.maxAttempts = maxAttempts
		self.delayStrategy = delayStrategy
		self.networkController = networkController
	}

	public func send <RQ: Request, RS: Response> (
		_ request: RQ,
		response: RS.Type,
		delegate: some NetworkControllerSendingDelegate<RQ, RS.Model>,
		configurationUpdate: RequestConfiguration.Update?
	) async throws -> RS {
		try await networkController.send(
			request,
			response: response,
			delegate: .standard(sending: self.sending).merge(with: delegate),
			configurationUpdate: configurationUpdate
		)
	}

	func sending <RQ: Request> (
		_ sendingModel: SendingModel<RQ>,
		_ sendingAction: SendAction<RQ>
	) async throws -> (Data, URLResponse) {
		let maxAttempts = (sendingModel.configuration.info[RequestConfiguration.repeatAttemptCountInfoKey] as? Int) ?? maxAttempts
		var attempts = 0

		repeat {
			do {
				let (data, urlResponse) = try await sendingAction(sendingModel.urlSession, sendingModel.urlRequest)
				return (data, urlResponse)
			} catch {
				if let maxAttempts, attempts == maxAttempts - 1 {
					throw error
				}
				try await Task.sleep(nanoseconds: delayInNanoseconds(attempts))
				attempts += 1
			}
		} while true
	}

	func delayInNanoseconds (_ attemptCount: Int) -> UInt64 {
		UInt64(delayStrategy(attemptCount)) * NSEC_PER_SEC
	}
}

public extension RequestConfiguration {
	static var repeatAttemptCountInfoKey: String {
		"infoKey.RepeatableNetworkControllerDecorator.repeatAttemptCount"
	}
}

public extension NetworkController {
	func repeatable (
		maxAttempts: Int?,
		delayStrategy: @escaping (Int) -> Int
	) -> RepeatableNetworkControllerDecorator {
		RepeatableNetworkControllerDecorator(
			maxAttempts: maxAttempts,
			delayStrategy: delayStrategy,
			networkController: self
		)
	}
}