import XCTest
@testable import ImageCaptioning

final class ImageCaptioningTests: XCTestCase {
    func testExample() throws {
        let image = UIImage(resource: .baseball)
        let request = try ImageCaptioningRequest()
        let handler = ImageCaptioningRequestHandler(cgImage: image.cgImage!)
        try handler.perform(request)
        XCTAssertEqual(request.result, "野球をしている少年")
    }
}
