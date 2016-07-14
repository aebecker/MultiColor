import Glibc
import SwiftyGPIO
 
// 1 - get list of available GPIO ports for this hardware
let gpiodefs = SwiftyGPIO.GPIOs(for: .RaspberryPi2)
 
// 2 - State: We're common anode, so backwards
enum GPIOState:Int {
case Off = 1
case On  = 0
}
 
// 3
struct LedColor {
 static let Off    = (GPIOState.Off, GPIOState.Off) 
 static let Green  = (GPIOState.On,  GPIOState.Off)
 static let Orange = (GPIOState.On,  GPIOState.On)
 static let Red    = (GPIOState.Off, GPIOState.On)
}
 
// 4 - the ports we use 
let gpios = [gpiodefs[.P3]!, gpiodefs[.P4]!]
for gpio in gpios {
  gpio.direction = .OUT
  gpio.value     = GPIOState.Off.rawValue
}
 
// 5
func setLedColor(color:(GPIOState,GPIOState), gpios:[GPIO]) {
  gpios[0].value = color.0.rawValue
  gpios[1].value = color.1.rawValue
}
 
// 6
guard Process.arguments.count == 2 else {
  print("Usage:  ./main off|green|orange|red")
  exit(0)
}
 
let color = Process.arguments[1]
 
// 7
switch color {
  case "off":
    setLedColor(color: LedColor.Off, gpios:gpios)
  case "green":
    setLedColor(color: LedColor.Green, gpios:gpios)
  case "orange":
    setLedColor(color: LedColor.Orange, gpios:gpios)
  case "red":
    setLedColor(color: LedColor.Red, gpios:gpios)
  default:
    print("Invalid color")
}
