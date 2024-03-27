//
//  DetailRowView.swift
//  MachOParsing
//
//  Created by 小七 on 2023/11/26.
//

import SwiftUI

struct DetailRowView: View {
    
    let detail: DetailModel
    
    @State private var isPortrait:Bool = (UIScreen.main.bounds.height > UIScreen.main.bounds.width)
    //通过宽高判断初始化方向
    private let orientationPublisher = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
    
    @State private var minWidth: CGFloat = UIScreen.main.bounds.width / 5.5
    var minHeight: CGFloat = 45
    var height: CGFloat = 35
    
    var body: some View {
        
        HStack(spacing: isPortrait ? 1 : 6) {
            
            Text(detail.offset)
                .frame(minWidth: minWidth, minHeight: minHeight, alignment: .center)
            
            Divider()
                .frame(height: height)
            
            Text(detail.data)
                .frame(minWidth: minWidth, minHeight: minHeight, alignment: .center)
            
            Divider()
                .frame(height: height)
            
            Text(detail.description)
                .frame(minWidth: minWidth, minHeight: minHeight, alignment: .center)
            
            Divider()
                .frame(height: height)
            
            Text(detail.value)
                .frame(minWidth: minWidth, minHeight: minHeight, alignment: .center)
            
        }   // HStack
        .font(.caption)
        .onReceive(orientationPublisher) { _ in
            switch (UIDevice.current.orientation){
            case .portrait:
                self.isPortrait = true
                self.minWidth = UIScreen.main.bounds.width / 5.5
            case .landscapeLeft, .landscapeRight:
                self.isPortrait = false
                self.minWidth = UIScreen.main.bounds.width / 5
            default:
                break
            }
        }
    }
}

struct DetailRowView_Previews: PreviewProvider {
    static var previews: some View {
        DetailRowView(detail: DetailModel(offset: "00000000", data: "FEEDFACF", description: "Magic Number", value: "MH_MAGIC_64"))
            .previewLayout(.sizeThatFits)
    }
}
