/*
    Define um grupo de vistas com geometria sincronizada usando um identificador e namespace que você fornece.
*/

@State var show: Bool = false
@Namespace var namespace

if show {
    Rectangle ()
        .matchedGeometryEffect(id: "shape", in: namespace)
        •frame (width: 100, height: 100)
} else {
    Rectangle ()
    . matchedGeometryEffect(id: "shape", in: namespace)
    •  frame (maxWidth: .infinity, maxHeight: 400)
