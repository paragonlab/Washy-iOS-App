// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Washy",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Washy",
            targets: ["Washy"]),
    ],
    dependencies: [
        // Firebase
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0"),
        
        // MapKit
        .package(url: "https://github.com/mapbox/mapbox-maps-ios.git", from: "10.0.0"),
        
        // QR Scanner
        .package(url: "https://github.com/dagronf/QRCode.git", from: "3.0.0"),
        
        // Networking
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0"),
        
        // Image Loading
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "Washy",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "MapboxMaps", package: "mapbox-maps-ios"),
                .product(name: "QRCode", package: "QRCode"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Kingfisher", package: "Kingfisher")
            ]),
        .testTarget(
            name: "WashyTests",
            dependencies: ["Washy"]),
    ]
) 