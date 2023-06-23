//
//  WeaponView.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 12/06/23.
//

import SwiftUI
import xlsxwriter


struct WeaponView: View {
    @State private var searchQuery: String = ""
    
    @StateObject private var viewModel: WeaponViewModel = WeaponViewModel()
    
    @State private var showFileExported: Bool = false
    
    @State private var csvDocument: CSVDocument = CSVDocument()
    
    @State private var pathBook: String = ""
    
    @State private var shareSheet: Bool = false
    
    @State private var items: [Any] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Button("Test XLSX"){
//                    ExportXlsxService().export()
                    generateExcelFile(weapons: viewModel.weapon)
    
                }
                .popover(isPresented: $shareSheet) {
                    ShareSheetView(items: $items)
                }
                
                
                if viewModel.weapon.isEmpty {
                        LottieView(name: "Empty", loopMode: .loop)
                            .frame(maxHeight: 240)
                        
                        Text("Oops, data empty or not found")
                        .font(.system(.title3).bold())
                        .foregroundColor(.primaryLabel)
                        .padding(.top, -16)
                        .padding(.horizontal, 16)
                } else {
                    List {
                        ForEach($viewModel.weapon, id: \.id){ $weapon in
                            NavigationLink {
                                DetailWeaponView(id: weapon.id, imageUrl: weapon.imageUrl , addedAt: weapon.addedAt ,name: weapon.name, price: "\(weapon.price)", stock: "\(weapon.stock)", currentImage: getImage(imageUrl: weapon.imageUrl), statusSelected: weapon.status, locationSelected: weapon.location)
                            } label: {
                                WeaponItemView(weapon: $weapon)
                                    .hLeading()
                                    .alignmentGuide(.listRowSeparatorLeading){ _ in
                                        0
                                    }
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            withAnimation {
                                                viewModel.deleteWeapon(id: weapon.id) { result in
                                                    switch(result){
                                                    case .success :
                                                        viewModel.fetchWeapon()
                                                    case .failure(let error):
                                                        print("error")
                                                        print(error.localizedDescription)
                                                    }
                                                }
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash.circle.fill")
                                        }
                                        .tint(.red)
                                    }
                            }
                            
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .onAppear {
                viewModel.fetchWeapon()
            }
            .onChange(of: self.searchQuery){ newQuery in
                withAnimation {
                    viewModel.filterSearch(query: newQuery)
                }
            }
            .searchable(text: self.$searchQuery)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Text("Weapon")
                        .font(.system(.title).bold())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(alignment: .center, spacing: 0) {
                        NavigationLink {
                            AddWeaponView()
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName: "plus.circle")
                                    .font(.system(.title3))
                                    .foregroundColor(.primaryAccent)
                                Text("Tambah")
                                    .font(.system(.body))
                                    .foregroundColor(.primaryAccent)
                                
                            }
                        }
                        
                        Button {
                            
                            var number = 0
                            var csvHead = "No,Name,Price,Stock,Status,Location\n"
                            
                            for weaponItem in viewModel.weapon {
                                number += 1
                                csvHead.append("\(number),\(weaponItem.name),\(weaponItem.price),\(weaponItem.stock),\(weaponItem.status),\(weaponItem.location)\n")
                            }
                            
                            
                            self.csvDocument = CSVDocument(initialText: csvHead)
                            self.showFileExported = true
                            
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName: "square.and.arrow.up.circle")
                                    .font(.system(.title3))
                                    .foregroundColor(.secondaryAccent)
                                Text("Export")
                                    .font(.system(.body))
                                    .foregroundColor(.secondaryAccent)
                                
                            }
                        }
//                        .fileExporter(isPresented: $showFileExported, document: csvDocument, contentType: .commaSeparatedText, defaultFilename: generateFileExportName()) { result in
//                            switch result {
//                            case .success(let url):
//                                print("Saved to \(url)")
//                            case .failure(let error):
//                                print(error.localizedDescription)
//                            }
//                        }
                    }
                }
            }
        }
        .tint(.secondaryAccent)
    }
    
    func generateFileExportName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-dd-MM"
        return "Weapon \(formatter.string(from: Date.now))"
    }
    
    func getImage(imageUrl: String) -> UIImage {
        let imagesDefaultURL = URL(fileURLWithPath: "/images/")
        let imagesFolderUrl = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: imagesDefaultURL, create: true)
        let imageUrl = imagesFolderUrl.appendingPathComponent(imageUrl)
        
        do {
            let imageData = try Data(contentsOf: imageUrl)
            
            if let imageResult = UIImage(data: imageData){
                return imageResult
            }
        } catch {
            print("Not able to load image")
        }
        
        return UIImage(systemName: "exclamationmark.triangle.fill")!
        
    }
    
    private func docDirectoryPath() -> String{
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask,
                                                           true)
        return dirPaths[0]
    }
    
    private func minRatio(left: (Double, Double), right: (Double, Double)) -> Double {
        min(left.0 / right.0, left.1 / right.1)
    }
    
    /// Update NSData to buffer for xlsxwriter
    private func getArrayOfBytesFromImage(imageData: NSData) -> [UInt8] {
        //Determine array size
        let count = imageData.length / MemoryLayout.size(ofValue: UInt8())
        //Create an array of the appropriate size
        var bytes = [UInt8](repeating: 0, count: count)
        //Copy image data as bytes into the array
        imageData.getBytes(&bytes, length:count * MemoryLayout.size(ofValue: UInt8()))

        return bytes
    }
        
    
    private func generateExcelFile(weapons: [Weapon]){
        let filename = "export_database.xlsx"
        
        //cell size
        let cell_width: Double = 50
        let cell_height: Double = 50

        var workbook: UnsafeMutablePointer<lxw_workbook>?
        var worksheet: UnsafeMutablePointer<lxw_worksheet>?
        var format_header: UnsafeMutablePointer<lxw_format>?
        var format_1: UnsafeMutablePointer<lxw_format>?
        
        var writingLine: UInt32 = 0
        
        var destination_path = docDirectoryPath()
        destination_path.append(filename)
        pathBook = destination_path

        workbook = workbook_new(destination_path)
        worksheet = workbook_add_worksheet(workbook, nil)
        
        
        // Add style
        format_header = workbook_add_format(workbook)
        format_set_bold(format_header)
        format_1 = workbook_add_format(workbook)
        format_set_bg_color(format_1, 0xDDDDDD)
        
        
        //build header
        writingLine = 0
        let format = format_header
        format_set_bold(format)
        worksheet_write_string(worksheet, writingLine, 0, "No", format)
        worksheet_write_string(worksheet, writingLine, 1, "Image", format)
        worksheet_write_string(worksheet, writingLine, 2, "Name", format)
        worksheet_write_string(worksheet, writingLine, 3, "Price", format)
        worksheet_write_string(worksheet, writingLine, 4, "Stock", format)
        worksheet_write_string(worksheet, writingLine, 5, "Status", format)
        worksheet_write_string(worksheet, writingLine, 6, "Location", format)
        
        var numberItem = 0
        for weapon in weapons {
            numberItem+=1
            writingLine += 1
            let lineFormat = (writingLine % 2 == 1) ? format_1 : nil //set format
            
            
            worksheet_write_string(worksheet, writingLine, 0, "\(numberItem)", nil)
            worksheet_write_string(worksheet, writingLine, 2, weapon.name, nil)
            worksheet_write_number(worksheet, writingLine, 3, weapon.price, nil)
            worksheet_write_number(worksheet, writingLine, 4, Double(weapon.stock), nil)
            worksheet_write_string(worksheet, writingLine, 5, weapon.status, nil)
            worksheet_write_string(worksheet, writingLine, 6, weapon.location, nil)
            
        }
        
        for (index, weapon) in weapons.enumerated() {
            let row = UInt32(index + 1)
            worksheet_set_row(worksheet, row, Double(cell_height), nil)
            let image = getImage(imageUrl: weapon.imageUrl)
                var options = lxw_image_options()
                // Pixel size is Point size x image scale
                let imageScale = image.scale
                let uiimageSizeInPixel = (Double(image.size.width * imageScale), Double(image.size.height * imageScale))
                let scale = minRatio(left: (cell_width, cell_height),
                                     right: uiimageSizeInPixel )
                options.x_offset = 10
                options.y_offset = 1
                options.x_scale = scale
                options.y_scale = scale
                options.object_position = 1
                
                if let nsdata = image.jpegData(compressionQuality: 0.9) as NSData? {
                    let buffer = getArrayOfBytesFromImage(imageData: nsdata)
                    worksheet_insert_image_buffer_opt(worksheet, row, 1, buffer, buffer.count, &options)
                }
            
        }
        
        workbook_close(workbook)
        
        let path = URL(fileURLWithPath: pathBook)
        
        items = [path as Any]
        
        shareSheet = true
        print(pathBook)
        
        
    }
}

struct WeaponView_Previews: PreviewProvider {
    static var previews: some View {
        WeaponView()
    }
}
