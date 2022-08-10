import Foundation

public protocol RequestDelegate {
	associatedtype RequestType: Request
	associatedtype ResponseType: Response = StandardResponse
	associatedtype ContentType
	associatedtype ErrorType: Error = ControllerError

	var name: String { get }

	func request (_ requestInfo: RequestInfo) throws -> RequestType

	func urlSession (_ urlSession: URLSession, _ requestInfo: RequestInfo) throws -> URLSession
	func urlRequest (_ urlRequest: URLRequest, _ requestInfo: RequestInfo) throws -> URLRequest

	func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType
	func content (_ response: ResponseType, _ requestInfo: RequestInfo) throws -> ContentType

	func error (_ error: ControllerError, _ requestInfo: RequestInfo) -> ErrorType
}

public extension RequestDelegate {
	var name: String { "\(Self.self)" }

	func urlSession (_ urlSession: URLSession, _ requestInfo: RequestInfo) throws -> URLSession { urlSession }
	func urlRequest (_ urlRequest: URLRequest, _ requestInfo: RequestInfo) throws -> URLRequest { urlRequest }
	func response (_ data: Data, _ urlResponse: URLResponse, _ requestInfo: RequestInfo) throws -> ResponseType { try ResponseType(data, urlResponse) }
	func content (_ response: ResponseType, _ requestInfo: RequestInfo) -> ResponseType { response }
}

public extension RequestDelegate where ContentType == Void {
	func content (_ response: ResponseType, _ requestInfo: RequestInfo) -> ContentType { }
}

public extension RequestDelegate where ErrorType == ControllerError {
	func error (_ error: ControllerError, _ requestInfo: RequestInfo) -> ErrorType { error }
}
