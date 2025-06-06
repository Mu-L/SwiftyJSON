//  SequenceTypeTests.swift
//
//  Copyright (c) 2014 - 2017 Pinglin Tang
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import XCTest
import SwiftyJSON

class SequenceTypeTests: XCTestCase {

    var testData: Data?

    func testJSONFile() {
        if let file = Bundle.module.url(forResource: "Tests", withExtension: "json") {
            self.testData = try? Data(contentsOf: file)
            guard let json = try? JSON(data: self.testData!) else {
                XCTFail("Unable to parse the data")
                return
            }
            for (index, sub) in json {
                switch (index as NSString).integerValue {
                case 0:
                    XCTAssertTrue(sub["id_str"] == "240558470661799936")
                case 1:
                    XCTAssertTrue(sub["id_str"] == "240556426106372096")
                case 2:
                    XCTAssertTrue(sub["id_str"] == "240539141056638977")
                default:
                    continue
                }
            }
        } else {
            XCTFail("Can't find the test JSON file")
        }
    }

    func testArrayAllNumber() {
        var json: JSON = [1, 2.0, 3.3, 123456789, 987654321.123456789]
        XCTAssertEqual(json.count, 5)

        var index = 0
        var array = [NSNumber]()
        for (i, sub) in json {
            XCTAssertEqual(sub, json[index])
            XCTAssertEqual(i, "\(index)")
            array.append(sub.number!)
            index += 1
        }
        XCTAssertEqual(index, 5)
        XCTAssertEqual(array, [1, 2.0, 3.3, 123456789, 987654321.123456789])
    }

    func testArrayAllBool() {
        var json: JSON = JSON([true, false, false, true, true])
        XCTAssertEqual(json.count, 5)

        var index = 0
        var array = [Bool]()
        for (i, sub) in json {
            XCTAssertEqual(sub, json[index])
            XCTAssertEqual(i, "\(index)")
            array.append(sub.bool!)
            index += 1
        }
        XCTAssertEqual(index, 5)
        XCTAssertEqual(array, [true, false, false, true, true])
    }

    func testArrayAllString() {
        var json: JSON = JSON(rawValue: ["aoo", "bpp", "zoo"] as NSArray)!
        XCTAssertEqual(json.count, 3)

        var index = 0
        var array = [String]()
        for (i, sub) in json {
            XCTAssertEqual(sub, json[index])
            XCTAssertEqual(i, "\(index)")
            array.append(sub.string!)
            index += 1
        }
        XCTAssertEqual(index, 3)
        XCTAssertEqual(array, ["aoo", "bpp", "zoo"])
    }

    func testArrayWithNull() {
        var json: JSON = JSON(rawValue: ["aoo", "bpp", NSNull(), "zoo"] as NSArray)!
        XCTAssertEqual(json.count, 4)

        var index = 0
        var array = [AnyObject]()
        for (i, sub) in json {
            XCTAssertEqual(sub, json[index])
            XCTAssertEqual(i, "\(index)")
            array.append(sub.object as AnyObject)
            index += 1
        }
        XCTAssertEqual(index, 4)
        XCTAssertEqual(array[0] as? String, "aoo")
        XCTAssertEqual(array[2] as? NSNull, NSNull())
    }

    func testArrayAllDictionary() {
        var json: JSON = [["1": 1, "2": 2], ["a": "A", "b": "B"], ["null": NSNull()]]
        XCTAssertEqual(json.count, 3)

        var index = 0
        var array = [AnyObject]()
        for (i, sub) in json {
            XCTAssertEqual(sub, json[index])
            XCTAssertEqual(i, "\(index)")
            array.append(sub.object as AnyObject)
            index += 1
        }
        XCTAssertEqual(index, 3)
        XCTAssertEqual((array[0] as! [String: Int])["1"]!, 1)
        XCTAssertEqual((array[0] as! [String: Int])["2"]!, 2)
        XCTAssertEqual((array[1] as! [String: String])["a"]!, "A")
        XCTAssertEqual((array[1] as! [String: String])["b"]!, "B")
        XCTAssertEqual((array[2] as! [String: NSNull])["null"]!, NSNull())
    }

    func testDictionaryAllNumber() {
        var json: JSON = ["double": 1.11111, "int": 987654321]
        XCTAssertEqual(json.count, 2)

        var index = 0
        var dictionary = [String: NSNumber]()
        for (key, sub) in json {
            XCTAssertEqual(sub, json[key])
            dictionary[key] = sub.number!
            index += 1
        }

        XCTAssertEqual(index, 2)
        XCTAssertEqual(dictionary["double"]! as NSNumber, 1.11111)
        XCTAssertEqual(dictionary["int"]! as NSNumber, 987654321)
    }

    func testDictionaryAllBool() {
        var json: JSON = ["t": true, "f": false, "false": false, "tr": true, "true": true]
        XCTAssertEqual(json.count, 5)

        var index = 0
        var dictionary = [String: Bool]()
        for (key, sub) in json {
            XCTAssertEqual(sub, json[key])
            dictionary[key] = sub.bool!
            index += 1
        }

        XCTAssertEqual(index, 5)
        XCTAssertEqual(dictionary["t"]! as Bool, true)
        XCTAssertEqual(dictionary["false"]! as Bool, false)
    }

    func testDictionaryAllString() {
        var json: JSON = JSON(rawValue: ["a": "aoo", "bb": "bpp", "z": "zoo"] as NSDictionary)!
        XCTAssertEqual(json.count, 3)

        var index = 0
        var dictionary = [String: String]()
        for (key, sub) in json {
            XCTAssertEqual(sub, json[key])
            dictionary[key] = sub.string!
            index += 1
        }

        XCTAssertEqual(index, 3)
        XCTAssertEqual(dictionary["a"]! as String, "aoo")
        XCTAssertEqual(dictionary["bb"]! as String, "bpp")
    }

    func testDictionaryWithNull() {
        var json: JSON = JSON(rawValue: ["a": "aoo", "bb": "bpp", "null": NSNull(), "z": "zoo"] as NSDictionary)!
        XCTAssertEqual(json.count, 4)

        var index = 0
        var dictionary = [String: AnyObject]()
        for (key, sub) in json {
            XCTAssertEqual(sub, json[key])
            dictionary[key] = sub.object as AnyObject?
            index += 1
        }

        XCTAssertEqual(index, 4)
        XCTAssertEqual(dictionary["a"]! as? String, "aoo")
        XCTAssertEqual(dictionary["bb"]! as? String, "bpp")
        XCTAssertEqual(dictionary["null"]! as? NSNull, NSNull())
    }

    func testDictionaryAllArray() {
        var json: JSON = JSON (["Number": [NSNumber(value: 1), NSNumber(value: 2.123456), NSNumber(value: 123456789)], "String": ["aa", "bbb", "cccc"], "Mix": [true, "766", NSNull(), 655231.9823]])

        XCTAssertEqual(json.count, 3)

        var index = 0
        var dictionary = [String: AnyObject]()
        for (key, sub) in json {
            XCTAssertEqual(sub, json[key])
            dictionary[key] = sub.object as AnyObject?
            index += 1
        }

        XCTAssertEqual(index, 3)
        XCTAssertEqual((dictionary["Number"] as! NSArray)[0] as? Int, 1)
        XCTAssertEqual((dictionary["Number"] as! NSArray)[1] as? Double, 2.123456)
        XCTAssertEqual((dictionary["String"] as! NSArray)[0] as? String, "aa")
        XCTAssertEqual((dictionary["Mix"] as! NSArray)[0] as? Bool, true)
        XCTAssertEqual((dictionary["Mix"] as! NSArray)[1] as? String, "766")
        XCTAssertEqual((dictionary["Mix"] as! NSArray)[2] as? NSNull, NSNull())
        XCTAssertEqual((dictionary["Mix"] as! NSArray)[3] as? Double, 655231.9823)
    }

    func testDictionaryIteratingPerformance() {
        var json: JSON = [:]
        for i in 1...1000 {
            json[String(i)] = "hello"
        }
        measure {
            for (key, value) in json {
                print(key, value)
            }
        }
    }
}
