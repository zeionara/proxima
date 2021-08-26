import Foundation

infix operator ** : MultiplicationPrecedence

func ** (num: Double, power: Double) -> Double{
    return pow(num, power)
}
