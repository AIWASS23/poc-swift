import SwiftUI

struct Home: View {
    
    @State private var allExpenses: [Expense] = []
    @State private var activeCardID: UUID?
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Hello SwiftUI")
                        .font(.largeTitle.bold())
                        .frame(height: 45)
                        .padding(.horizontal, 15)
                    
                    GeometryReader {
                        let rect = $0.frame(in: .scrollView)
                        let minY = rect.minY.rounded()
                        
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 0) {
                                ForEach(cards) { card in
                                    ZStack {
                                        if minY == 75.0 {
                                            CardView(card)
                                        } else {
                                            if activeCardID == card.id {
                                                CardView(card)
                                            } else {
                                                Rectangle()
                                                    .fill(.clear)
                                            }
                                        }
                                    }
                                    .containerRelativeFrame(.horizontal)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollPosition(id: $activeCardID)
                        .scrollTargetBehavior(.paging)
                        .scrollClipDisabled()
                        .scrollIndicators(.hidden)
                        .scrollDisabled(minY != 75.0)
                    }
                    .frame(height: 125)
                }
                
                LazyVStack(spacing: 15) {
                    Menu {
                        
                    } label: {
                        HStack(spacing: 4) {
                            Text("Filter By")
                            Image(systemName: "chevron.down")
                        }
                        .font(.caption)
                        .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)

                    ForEach(allExpenses) { expense in
                        ExpenseCardView(expense)
                    }
                }
                .padding(15)
                .mask {
                    Rectangle()
                        .visualEffect { content, proxy in
                            content.offset(y: backgroundLimitOffset(proxy))
                        }
                }
                .background {
                    GeometryReader {
                        let rect = $0.frame(in: .scrollView)
                        let minY = min(rect.minY - 125, 0)
                        let progress = max(min(-minY / 25, 1), 0)
                        
                        RoundedRectangle(cornerRadius: 30 * progress)
                            .fill(scheme == .dark ? .black : .white)
                            .visualEffect { content, proxy in
                                content
                                    .offset(y: backgroundLimitOffset(proxy))
                            }
                    }
                }
            }
            .padding(.vertical, 15)
        }
        .scrollTargetBehavior(CustomScrollBehavior())
        .scrollIndicators(.hidden)
        .onAppear {
            if activeCardID == nil {
                activeCardID = cards.first?.id
            }
        }
        .onChange(of: activeCardID) {
            withAnimation(.snappy) {
                allExpenses = expenses.shuffled()
            }
        }
    }
    
    @ViewBuilder
    func CardView(_ card: Card) -> some View {
        GeometryReader {
            let rect = $0.frame(in: .scrollView(axis: .vertical))
            let minY = rect.minY
            let topValue: CGFloat = 75
            
            let offsetY = min(minY - topValue, 0)
            let progress = max(min(-offsetY/topValue, 1), 0)
            let scale: CGFloat = 1 + progress
            
            ZStack {
                Rectangle()
                    .fill(card.bgColor)
                    .overlay(alignment: .leading) {
                        Circle()
                            .fill(card.bgColor)
                            .overlay {
                                Circle()
                                    .fill(.white.opacity(0.2))
                            }
                            .scaleEffect(2, anchor: .topLeading)
                            .offset(x: -50, y: -40)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .scaleEffect(scale, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                VStack(alignment: .leading, spacing: 4) {
                    Spacer(minLength: 0)
                    
                    Text("Current Balance \(progress)")
                        .font(.callout)
                    
                    Text(card.balance)
                        .font(.title.bold())
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(15)
                .offset(y: progress * -25)
            }
            .offset(y: -offsetY)
            .offset(y: progress * -topValue)
        }
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    func ExpenseCardView(_ expense: Expense) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.product)
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text(expense.spendType)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer(minLength: 0)
            
            Text(expense.amountSpent)
                .fontWeight(.bold)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 6)
    }
    
    func backgroundLimitOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        return minY < 100 ? -minY + 100 : 0
    }
}


struct CustomScrollBehavior: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 75 {
            target.rect = .zero
        }
    }
}


#Preview {
    ContentView()
}
