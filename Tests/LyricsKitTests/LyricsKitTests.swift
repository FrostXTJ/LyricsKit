import XCTest
@testable import LyricsService

final class LyricsKitTests: XCTestCase {
    
    func testBasic() {
        let url = Bundle.module.url(forResource: "銀の龍の背に乗って", withExtension: "lrcx", subdirectory: "Resources")!
        let str = try! String(contentsOf: url)
        let lrc = Lyrics(str)!
        XCTAssertEqual(lrc.lines.count, 61)
        XCTAssertEqual(lrc.idTags.count, 4)
        XCTAssertEqual(lrc.metadata.attachmentTags, [.timetag, .furigana, .translation(languageCode: "zh-Hans")])
        XCTAssert(lrc[0] == (nil, 0))
        XCTAssert(lrc[50] == (8, 9))
        XCTAssert(lrc[320] == (60, nil))
        lrc.timeDelay = 50
        XCTAssertEqual(lrc.offset, 50000)
        XCTAssertEqual(lrc[0] == (8, 9))
    }
    
    func testSearching() {
        let source = LyricsProviders.Group()
        var searchResultEx: XCTestExpectation? = expectation(description: "search succeed")
        let searchReq = LyricsSearchRequest(searchTerm: .info(title: "Uprising", artist: "Muse"), duration: 305)
        let token = source.lyricsPublisher(request: searchReq).sink { _ in
            searchResultEx?.fulfill()
            searchResultEx = nil
        }
        waitForExpectations(timeout: 10)
        token.cancel()
    }
}
