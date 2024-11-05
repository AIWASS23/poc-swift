//
//  Math+Extensions.swift
//  
//
//  Created by Marcelo de Araújo
//

import simd
import Spatial

let π = Float.pi

public extension Double {

    /// Returns a single precision representation of this double value.
    var singlePrecision: Float {
        Float(self)
    }
}

public extension Float {

    /// Provides a constant used for halving.
    static let half: Float = 0.5

    /// Degrees to radians.
    var radians: Float {
        (self / 180) * π
    }

    /// Radians to degrees.
    var degrees: Float {
      (self / π) * 180
    }
}

public extension Int {

    /// Denotes an empty / non-existent.
    static let empty = Int(-1)
}

public extension Int32 {

    /// Denotes an empty / non-existent.
    static let empty = Int32(-1)
}

public extension Int64 {

    /// Denotes an empty / non-existent.
    static let empty = Int64(-1)
}

extension SIMD3 where Scalar == Float {

    static var xpositive: SIMD3<Scalar> {
        [1, 0, 0]
    }

    static var xnegative: SIMD3<Scalar> {
        [-1, 0, 0]
    }

    static var ypositive: SIMD3<Scalar> {
        [0, 1, 0]
    }

    static var ynegative: SIMD3<Scalar> {
        [0, -1, 0]
    }

    static var zpositive: SIMD3<Scalar> {
        [0, 0, 1]
    }

    static var znegative: SIMD3<Scalar> {
        [0, 0, -1]
    }

    var inverse: SIMD3<Scalar> {
        [Float(Int(x) ^ 1), Float(Int(y) ^ 1), Float(Int(z) ^ 1)]
    }

    var negate: SIMD3<Scalar> {
        self * -1
    }

    var isNan: Bool {
        x.isNaN || y.isNaN || z.isNaN
    }

    var radians: SIMD3<Scalar> {
        (self / 180) * π
    }

    static func > (_ lhs: SIMD3<Scalar>, rhs: SIMD3<Scalar>) -> Bool {
        lhs.x > rhs.x && lhs.y > rhs.y && lhs.z > rhs.z
    }

    static func >= (_ lhs: SIMD3<Scalar>, rhs: SIMD3<Scalar>) -> Bool {
        lhs.x >= rhs.x && lhs.y >= rhs.y && lhs.z >= rhs.z
    }

    static func < (_ lhs: SIMD3<Scalar>, rhs: SIMD3<Scalar>) -> Bool {
        lhs.x < rhs.x && lhs.y < rhs.y && lhs.z < rhs.z
    }

    static func <= (_ lhs: SIMD3<Scalar>, rhs: SIMD3<Scalar>) -> Bool {
        lhs.x <= rhs.x && lhs.y <= rhs.y && lhs.z <= rhs.z
    }
}

extension SIMD4 where Scalar: BinaryFloatingPoint {

    static var invalid: SIMD4<Scalar> {
        [.infinity, .infinity, .infinity, .infinity]
    }

    var xyz: SIMD3<Scalar> {
        [x, y, z]
    }

    var homogenized: SIMD4<Scalar> {
        if w == .zero || w == 1 {
            return self
        }
        let value = 1 / w
        return [x * value, y * value, z * value, 1]
    }
}

extension float4x4 {

    static let identity = matrix_identity_float4x4

    init(up: SIMD3<Float>, position: SIMD3<Float> = .zero, direction: SIMD3<Float> = .zero, scale: Float = 1.0) {
        var temp: float4x4 = .identity
        var forward = cross(up, .xpositive)
        if forward == .zero { // Make sure the forward vector doesn't equal 0
            forward = cross(up, .ypositive)
        }
        let right = cross(forward, up)
        temp.right = right
        temp.up = up
        temp.forward = forward
        temp.position = position
        temp.scale(scale)
        self.init([temp.columns.0, temp.columns.1, temp.columns.2, temp.columns.3])
    }

    @discardableResult
    mutating func scale(_ value: Float) -> Self {
        columns.0.x *= value
        columns.1.y *= value
        columns.2.z *= value
        return self
    }


    mutating func scale(_ factor: SIMD3<Float>) {
        columns.0.x *= factor.x
        columns.1.y *= factor.y
        columns.2.z *= factor.z
    }

    var right: SIMD3<Float> {
        get { columns.0.xyz }
        set(value) {
            columns.0 = [value.x, value.y, value.z, columns.0.w]
        }
    }

    var up: SIMD3<Float> {
        get { columns.1.xyz }
        set(value) {
            columns.1 = [value.x, value.y, value.z, columns.1.w]
        }
    }

    var forward: SIMD3<Float> {
        get { columns.2.xyz }
        set(value) {
            columns.2 = [value.x, value.y, value.z, columns.2.w]
        }
    }

    var position: SIMD3<Float> {
        get { columns.3.xyz }
        set(value) {
            columns.3 = [value.x, value.y, value.z, columns.3.w]
        }
    }

    var decomposition: (right: SIMD3<Float>, up: SIMD3<Float>, forward: SIMD3<Float>, translation: SIMD3<Float>, scale: SIMD3<Float>, quaternion: simd_quatf) {
        let right = columns.0.xyz
        let up = columns.1.xyz
        let forward = columns.2.xyz
        let translation = columns.3.xyz
        let scale: SIMD3<Float> = [columns.0.x, columns.1.y, columns.2.z]
        return (right: right,
                up: up,
                forward: forward,
                translation: translation,
                scale: scale,
                quaternion: simd_quaternion(self)
        )
    }

    @discardableResult
    mutating func rotate(by rotation: SIMD3<Float>) -> Self {
        let x = rotation.x
        let y = rotation.y
        let z = rotation.z
        var matrix: float4x4 = .identity
        matrix.columns.0.x = cos(y) * cos(z)
        matrix.columns.0.y = cos(z) * sin(x) * sin(y) - cos(x) * sin(z)
        matrix.columns.0.z = cos(x) * cos(z) * sin(y) + sin(x) * sin(z)
        matrix.columns.1.x = cos(y) * sin(z)
        matrix.columns.1.y = cos(x) * cos(z) + sin(x) * sin(y) * sin(z)
        matrix.columns.1.z = -cos(z) * sin(x) + cos(x) * sin(y) * sin(z)
        matrix.columns.2.x = -sin(y)
        matrix.columns.2.y = cos(y) * sin(x)
        matrix.columns.2.z = cos(x) * cos(y)
        matrix.columns.3.w = 1.0
        self *= matrix
        return self
    }

    @discardableResult
    mutating func rotate(around axis: SIMD3<Float>, by angle: Float) -> Self {
        let a = normalize(axis)
        let x = a.x
        let y = a.y
        let z = a.z
        let c = cos(angle)
        let s = sin(angle)
        let t = 1 - c
        var matrix: float4x4 = .identity

        matrix.columns.0.x = t * x * x + c
        matrix.columns.0.y = t * x * y + z * s
        matrix.columns.0.z = t * x * z - y * s
        matrix.columns.0.w = 0
        matrix.columns.1.x = t * x * y - z * s
        matrix.columns.1.y = t * y * y + c
        matrix.columns.1.z = t * y * z + x * s
        matrix.columns.1.w = 0
        matrix.columns.2.x = t * x * z + y * s
        matrix.columns.2.y = t * y * z - x * s
        matrix.columns.2.z = t * z * z + c
        matrix.columns.2.w = 0

        self *= matrix
        return self
    }

    var float3x3: float3x3 {
        simd_float3x3(columns.0.xyz, columns.1.xyz, columns.2.xyz)
    }
}

extension double4x4 {

    var singlePrecision: simd_float4x4 {
        let matrix: simd_float4x4 = .init(
            [columns.0.x.singlePrecision, columns.0.y.singlePrecision, columns.0.z.singlePrecision, columns.0.w.singlePrecision],
            [columns.1.x.singlePrecision, columns.1.y.singlePrecision, columns.1.z.singlePrecision, columns.1.w.singlePrecision],
            [columns.2.x.singlePrecision, columns.2.y.singlePrecision, columns.2.z.singlePrecision, columns.2.w.singlePrecision],
            [columns.3.x.singlePrecision, columns.3.y.singlePrecision, columns.3.z.singlePrecision, columns.3.w.singlePrecision]
        )
        return matrix
    }
}

extension ProjectiveTransform3D {

     // https://developer.apple.com/documentation/compositorservices/drawing_fully_immersive_content_using_metal#4225665
    init(tangents: SIMD4<Float>, depthRange: SIMD2<Float>, _ reverseZ: Bool = false) {
        self.init(
            leftTangent: Double(tangents.x),
            rightTangent: Double(tangents.y),
            topTangent: Double(tangents.z),
            bottomTangent: Double(tangents.w),
            nearZ: Double(depthRange.y),
            farZ: Double(depthRange.x),
            reverseZ: reverseZ)
    }

    init(fovyRadians: Float, aspectRatio: Float, nearZ: Float, farZ: Float, reverseZ: Bool = false) {
        let fovY: Angle2D = .init(radians: Double(fovyRadians))
        self.init(
            fovY: fovY,
            aspectRatio: Double(aspectRatio),
            nearZ: Double(nearZ),
            farZ: Double(farZ),
            reverseZ: reverseZ
        )
    }
}


func unproject(point: SIMD3<Float>, viewMatrix: float4x4, projectionMatrix: float4x4, viewport: SIMD4<Float>) -> SIMD3<Float> {

    let inverse = (projectionMatrix * viewMatrix).inverse
    var tmp = SIMD4<Float>(point, 1)
    tmp.x = (tmp.x - viewport.x) / viewport.z
    tmp.y = (tmp.y - viewport.y) / viewport.w
    tmp = tmp * 2 - 1

    var result = inverse * tmp
    result /= result.w
    return result.xyz
}

func project(point: SIMD3<Float>, modelViewMatrix: float4x4, projectionMatrix: float4x4, viewport: SIMD4<Float>) -> SIMD3<Float> {

    var tmp = SIMD4<Float>(point, 1)
    tmp = modelViewMatrix * tmp
    tmp = projectionMatrix * tmp
    tmp /= tmp.w
    tmp = tmp * .half
    tmp += .half
    tmp.x = tmp.x * viewport.z + viewport.x
    tmp.y = tmp.y * viewport.w + viewport.y
    return tmp.xyz
}

//  Matrix Cheatsheet
//        Right, Up, Forward, Position
//  ---------------------------------------
//  |      Rx      Ux      Fx     Px      |
//  |      Ry      Uy      Fy     Py      |
//  |      Rz      Uz      Fz     Pz      |
//  |       0       0       0     1       |
//  ---------------------------------------
//              Translation
//  ---------------------------------------
//  |       1       0       0     tx      |
//  |       0       1       0     ty      |
//  |       0       0       1     tz      |
//  |       0       0       0     1       |
//  ---------------------------------------
//              Scale
//  ---------------------------------------
//  |      sx       0       0      0      |
//  |      0        sy      0      0      |
//  |      0        0       sz     0      |
//  |      0        0       0      1      |
//  ---------------------------------------
//
//              Rotation X
//  ---------------------------------------
//  |      1       0       0       0      |
//  |      0     cos(x)  sin(x)    0      |
//  |      0     -sin(x) cos(x)    0      |
//  |      0        0       0      1      |
//  ---------------------------------------
//                Rotation Y
//  ---------------------------------------
//  |    cos(y)    0     -sin(y)   0      |
//  |      0       1       0       0      |
//  |    sin(y)    0     cos(y)    0      |
//  |      0       0       0       1      |
//  ---------------------------------------
//                Rotation Z
//  ---------------------------------------
//  |    cos(z)  -sin(z)    0      0      |
//  |    sin(z)   cos(z)    0      0      |
//  |      0       1        0      0      |
//  |      0       0        0      1      |
//  ---------------------------------------
