//
//  ProfileViewTests.swift
//  FunImagesTests
//
//  Created by Eugene Kolesnikov on 20.08.2023.
//

import XCTest
@testable import FunImages

final class ProfileViewTests: XCTestCase {
    func testUpdateProfileInfo() {
        //given
        let sut = ProfileViewController()
        
        //when
        let profile = Profile(userName: "A", name: "A", logName: "A", bio: "A")
        sut.setProfileInfo(profile: profile)
        
        //then
        XCTAssertEqual(sut.profileNameLabel.text, "A")
    }

}
