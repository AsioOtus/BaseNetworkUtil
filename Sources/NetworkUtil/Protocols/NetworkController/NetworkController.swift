import Combine

@available(iOS 13.0, *)
public protocol NetworkController {
	func send <RD: RequestDelegate> (_ requestDelegate: RD, label: String?) -> AnyPublisher<RD.ContentType, RD.ErrorType>
	func send <RD: RequestDelegate> (_ requestDelegate: RD, _ requestInfo: RequestInfo) -> AnyPublisher<RD.ContentType, RD.ErrorType>
}
