import Glibc
import SwiftyGPIO
 
// 1 - get list of available GPIO ports for this hardware
let gpiodefs = SwiftyGPIO.GPIOs(for: .RaspberryPi2)
 
// 2 - State: We're common anode, so backwards
enum GPIOState:Int {
case Off = 1
case On  = 0
}
 
// 3 Color > GPIO state mapping
struct LedColor { //  GREEN          RED            BLUE
 static let Off    = (GPIOState.Off, GPIOState.Off, GPIOState.Off)
 static let Green  = (GPIOState.On,  GPIOState.Off, GPIOState.Off)
 static let Red    = (GPIOState.Off, GPIOState.On,  GPIOState.Off)
 static let Blue   = (GPIOState.Off, GPIOState.Off, GPIOState.On)
    
 static let Purple    = (GPIOState.Off, GPIOState.On,  GPIOState.On)
 static let Yellow    = (GPIOState.On,  GPIOState.On,  GPIOState.Off)
 static let BlueGreen = (GPIOState.On,  GPIOState.Off, GPIOState.On)
    
 static let White  = (GPIOState.On,  GPIOState.On,  GPIOState.On)
}
 
// 4 - the ports we use 
let gpios = [gpiodefs[.P3]!, gpiodefs[.P4]!, gpiodefs[.P2]!]
for gpio in gpios {
  gpio.direction = .OUT
  gpio.value     = GPIOState.Off.rawValue
}
 
// 5 Map state to GPIO
func setLedColor(color:(GPIOState, GPIOState, GPIOState), gpios:[GPIO]) {
  gpios[0].value = color.0.rawValue
  gpios[1].value = color.1.rawValue
  gpios[2].value = color.2.rawValue
}
 
// 6 - sanity check
guard Process.arguments.count == 2 else {
  print("Usage: ./MultiColor off|green|red|blue|purple|yellow|bg|white")
  exit(0)
}
 
let color = Process.arguments[1]
 
// 7
switch color {
  case "off":
    setLedColor(color: LedColor.Off, gpios:gpios)
  case "green":
    setLedColor(color: LedColor.Green, gpios:gpios)
  case "red":
    setLedColor(color: LedColor.Red, gpios:gpios)
  case "blue":
    setLedColor(color: LedColor.Blue, gpios:gpios)
  case "white":
    setLedColor(color: LedColor.White, gpios:gpios)
  case "purple":
    setLedColor(color: LedColor.Purple, gpios:gpios)
  case "orange":
    setLedColor(color: LedColor.Yellow, gpios:gpios)
  case "bg":
    setLedColor(color: LedColor.BlueGreen, gpios:gpios)
  default:
    print("Invalid color")
}
