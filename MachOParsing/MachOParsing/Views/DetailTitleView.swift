//
//  DetailTitleView.swift
//  MachOParsing
//
//  Created by 小七 on 2023/11/26.
//

import SwiftUI

struct DetailTitleView: View {
    
    private let orientationPublisher = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
    
    @State private var minWidth: CGFloat = UIScreen.main.bounds.width / 5.5
    var minHeight: CGFloat = 40
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            Text("Offset")
                .frame(minWidth: minWidth, minHeight: minHeight, alignment: .center)
            
            Text("Data")
                .frame(minWidth: minWidth, minHeight: minHeight, alignment: .center)

            Text("Description")
                .frame(minWidth: minWidth, minHeight: minHeight, alignment: .center)
            
            Text("Value")
                .frame(minWidth: minWidth, minHeight: minHeight, alignment: .center)
            
        }   // HStack
        .font(.headline)
        .onReceive(orientationPublisher) { _ in
            switch (UIDevice.current.orientation){
            case .portrait:
                self.minWidth = UIScreen.main.bounds.width / 5.5
            case .landscapeLeft, .landscapeRight:
                self.minWidth = UIScreen.main.bounds.width / 5
            default:
                break
            }
        }
    }
}

struct DetailTitleView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTitleView()
            .previewLayout(.sizeThatFits)
    }
}
