# TextOutlineShapeView
This View converts the text to UIBezierPath and adds lines and shadows to the outline and displays it.
  
![sample](https://user-images.githubusercontent.com/5406126/53006951-a676c700-3479-11e9-8c4a-6ef9eabab0cb.png)

## Usage
```swift
let str = "我が家の猫は7.4kg\nゆえに重い"
guard let font = UIFont(name: "HiraKakuProN-W6", size: 36) else { return }

let textOptions = TextOutlineShapeView.TextOptions(text: str,
                                                    font: font,
                                                    lineSpacing: 10,
                                                    textAlignment: .left)
let shapeOptions = TextOutlineShapeView.ShapeOptions(lineJoin: .round,
                                                        fillColor: UIColor.white.cgColor,
                                                        strokeColor: UIColor.blue.cgColor,
                                                        lineWidth: 5,
                                                        shadowColor: UIColor.black.cgColor,
                                                        shadowOffset: CGSize(width: 3, height: 3),
                                                        shadowRadius: 5,
                                                        shadowOpacity: 0.6)
let shapeView = TextOutlineShapeView(textOptions: textOptions, shapeOptions: shapeOptions)
self.view.addSubview(shapeView)
```

## Licence
This software is released under the MIT License, see LICENSE.txt.
