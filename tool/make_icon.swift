import AppKit
import CoreGraphics

// FuelWise icon: teal gradient background, white map pin with a teal fuel drop.
// Usage: swift tool/make_icon.swift assets/icon && dart run flutter_launcher_icons
let outDir = CommandLine.arguments[1]
let size = 1024

func makeContext() -> CGContext {
    CGContext(data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0,
              space: CGColorSpace(name: CGColorSpace.sRGB)!,
              bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
}

let teal = CGColor(srgbRed: 0x0B/255, green: 0x8A/255, blue: 0x6F/255, alpha: 1)
let tealDark = CGColor(srgbRed: 0x05/255, green: 0x4F/255, blue: 0x40/255, alpha: 1)
let white = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
let lime = CGColor(srgbRed: 0xB8/255, green: 0xF2/255, blue: 0x5A/255, alpha: 1)

func drawBackground(_ c: CGContext) {
    let g = CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.sRGB)!,
                       colors: [teal, tealDark] as CFArray, locations: [0, 1])!
    c.drawLinearGradient(g, start: CGPoint(x: 0, y: CGFloat(size)), end: CGPoint(x: CGFloat(size), y: 0), options: [])
}

/// Draws the pin + drop centred, scaled by `scale` (1.0 = fills ~70% of canvas).
func drawGlyph(_ c: CGContext, scale: CGFloat) {
    let s = CGFloat(size)
    c.saveGState()
    c.translateBy(x: s / 2, y: s / 2)
    c.scaleBy(x: scale, y: scale)

    // Map pin: circle head + straight tangent lines to the tip (y up, origin at centre).
    let r: CGFloat = 250
    let headY: CGFloat = 90
    let tipY: CGFloat = -360
    let beta = acos(r / (headY - tipY))
    let pin = CGMutablePath()
    pin.addArc(center: CGPoint(x: 0, y: headY), radius: r,
               startAngle: -CGFloat.pi / 2 + beta, endAngle: -CGFloat.pi / 2 - beta, clockwise: false)
    pin.addLine(to: CGPoint(x: 0, y: tipY))
    pin.closeSubpath()
    c.setShadow(offset: CGSize(width: 0, height: -14), blur: 30,
                color: CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.25))
    c.setFillColor(white)
    c.addPath(pin)
    c.fillPath()
    c.setShadow(offset: .zero, blur: 0, color: nil)

    // Fuel drop inside the pin head: circle bottom + tangent lines to the apex.
    let dropCenter = CGPoint(x: 0, y: headY - 45)
    let dr: CGFloat = 112
    let apexY = dropCenter.y + dr * 1.95
    let gamma = acos(dr / (apexY - dropCenter.y))
    let drop = CGMutablePath()
    drop.addArc(center: dropCenter, radius: dr,
                startAngle: CGFloat.pi / 2 + gamma, endAngle: CGFloat.pi / 2 - gamma, clockwise: false)
    drop.addLine(to: CGPoint(x: 0, y: apexY))
    drop.closeSubpath()
    c.setFillColor(teal)
    c.addPath(drop)
    c.fillPath()

    // Small lime "savings" highlight on the drop.
    c.setFillColor(lime)
    c.fillEllipse(in: CGRect(x: -60, y: dropCenter.y - 40, width: 42, height: 42))
    c.restoreGState()
}

func save(_ c: CGContext, _ name: String) {
    let rep = NSBitmapImageRep(cgImage: c.makeImage()!)
    let data = rep.representation(using: .png, properties: [:])!
    try! data.write(to: URL(fileURLWithPath: "\(outDir)/\(name)"))
    print("wrote \(outDir)/\(name)")
}

// Full icon (iOS + legacy Android): opaque background.
let full = makeContext()
drawBackground(full)
drawGlyph(full, scale: 1.0)
save(full, "icon.png")

// Android adaptive foreground: transparent, glyph inside the 66% safe zone.
let fg = makeContext()
drawGlyph(fg, scale: 0.62)
save(fg, "icon_foreground.png")
