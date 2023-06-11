struct PackedBubbleChart: View {
    
    @Binding var data: [DataPoint]
    // space between bubbles
    var spacing: CGFloat
    // Angle in degrees -360 to 360
    var startAngle: Int
    var clockwise: Bool
    
    struct BubbleSize {
        var xMin: CGFloat = 0
        var xMax: CGFloat = 0
        var yMin: CGFloat = 0
        var yMax: CGFloat = 0
    }
    
    @State private var bubbleSize = BubbleSize()
    
    var body: some View {
        
        let xSize = (bubbleSize.xMax - bubbleSize.xMin) == 0 ? 1 : (bubbleSize.xMax - bubbleSize.xMin)
        let ySize = (bubbleSize.yMax - bubbleSize.yMin) == 0 ? 1 : (bubbleSize.yMax - bubbleSize.yMin)
        
        GeometryReader { geo in
            
            let xScale = geo.size.width / xSize
            let yScale = geo.size.height / ySize
            let scale = min(xScale, yScale)
            
            ZStack {
                ForEach(data, id: \.id) { item in
                    bubble(item: item, scale: scale)
                    .offset(x: item.offset.width * scale, y: item.offset.height * scale)
                }
            }
            .offset(x: xOffset() * scale, y: yOffset() * scale)
        }
        .onAppear {
            setOffets()
            bubbleSize = absoluteSize()
        }
    }
    
    func bubble(item: DataPoint, scale: CGFloat) -> some View {
        ZStack {
            Circle()
                .frame(width: CGFloat(item.value) * scale,
                       height: CGFloat(item.value) * scale)
                .foregroundStyle(item.color.gradient)
                .opacity(item.opacity)
            VStack {
                Text(item.title)
                    .bold()
                Text(item.value.formatted())
            }
        }
    }
    
    // X-Axis offset
    func xOffset() -> CGFloat {
        if data.isEmpty { return 0.0 }
        let size = data.max{$0.value < $1.value}?.value ?? data[0].value
        let xOffset = bubbleSize.xMin + size / 2
        return -xOffset
    }
    
    // Y-Axis offset
    func yOffset() -> CGFloat {
        if data.isEmpty { return 0.0 }
        let size = data.max{$0.value < $1.value}?.value ?? data[0].value
        let yOffset = bubbleSize.yMin + size / 2
        return -yOffset
    }
    
    
    // calculate and set the offsets
    func setOffets() {
        if data.isEmpty { return }
        // first circle
        data[0].offset = CGSize.zero
        
        if data.count < 2 { return }
        // second circle
        let b = (data[0].value + data[1].value) / 2 + spacing
        
        // start Angle
        var alpha: CGFloat = CGFloat(startAngle) / 180 * CGFloat.pi
        
        data[1].offset = CGSize(width:  cos(alpha) * b,
                                height: sin(alpha) * b)
        
        // other circles
        for i in 2..<data.count {
            
            // sides of the triangle from circle center points
            let c = (data[0].value + data[i-1].value) / 2 + spacing
            let b = (data[0].value + data[i].value) / 2 + spacing
            let a = (data[i-1].value + data[i].value) / 2 + spacing
            
            alpha += calculateAlpha(a, b, c) * (clockwise ? 1 : -1)
            
            let x = cos(alpha) * b
            let y = sin(alpha) * b
            
            data[i].offset = CGSize(width: x, height: y )
        }
    }
    
    // Calculate alpha from sides - 1. Cosine theorem
    func calculateAlpha(_ a: CGFloat, _ b: CGFloat, _ c: CGFloat) -> CGFloat {
        return acos(
            ( pow(a, 2) - pow(b, 2) - pow(c, 2) )
            /
            ( -2 * b * c ) )
        
    }
    
    // calculate max dimensions of offset view
    func absoluteSize() -> BubbleSize {
        let radius = data[0].value / 2
        let initialSize = BubbleSize(xMin: -radius, xMax: radius, yMin: -radius, yMax: radius)
        
        let maxSize = data.reduce(initialSize, { partialResult, item in
            let xMin = min(
                partialResult.xMin,
                item.offset.width - item.value / 2 - spacing
            )
            let xMax = max(
                partialResult.xMax,
                item.offset.width + item.value / 2 + spacing
            )
            let yMin = min(
                partialResult.yMin,
                item.offset.height - item.value / 2 - spacing
            )
            let yMax = max(
                partialResult.yMax,
                item.offset.height + item.value / 2 + spacing
            )
            return BubbleSize(xMin: xMin, xMax: xMax, yMin: yMin, yMax: yMax)
        })
        return maxSize
    }
    
}