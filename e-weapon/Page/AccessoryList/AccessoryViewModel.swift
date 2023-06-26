//
//  AccessoryViewModel.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 17/06/23.
//

import UIKit
import xlsxwriter

class AccessoryViewModel: ObservableObject {
    
    private let databaseManager = DatabaseManager.shared
    
    @Published var accessories: [Accessory] = [] {
        didSet {
            filteredAccessories = accessories
        }
    }
    @Published var filteredAccessories: [Accessory] = []
    
    @Published var documentItemsExport: [Any] = []
    
    func fetchAccessory(){
        
        self.accessories = databaseManager.fetchAccessory()
            .map {
                return Accessory(id: $0.id, name: $0.name, addedAt: $0.addedAt, price: $0.price, stock: $0.stock, imageUrl: $0.imageUrl, location: $0.location, status: $0.status)
            }
    }
    
    func filterSearch(query: String){
        if query.isEmpty {
            fetchAccessory()
        } else {
            self.filteredAccessories = self.accessories.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
    }
    
    func deleteAccessory(id: String, completion: @escaping (Result<Void, Error>) -> Void){
        self.accessories.removeAll { $0.id == id}
        databaseManager.deleteAccessory(id: id, completion: completion)
    }
    
    func generateFileExportName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-dd-MM"
        return "Accessory \(formatter.string(from: Date.now))"
    }
    
    private func generateDocDirectory() -> String{
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask,
                                                           true)
        return dirPaths[0].appending("/")
    }
    
    
    func generateCSVFile(){
        let filename = generateFileExportName().appending(".csv")
        
        let destination_url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        
        var csvHead = "No, Name, Price, Stock, Status, Location\n"
        var number = 0
        
        for accessory in accessories {
            number += 1
            csvHead.append("\(number), \(accessory.name), \(accessory.price), \(accessory.stock), \(accessory.status), \(accessory.location)\n")
        }
        
        do {
            try csvHead.write(to: destination_url!, atomically: true, encoding: .utf8)
        } catch {
            print("error")
        }
        
        self.documentItemsExport = [destination_url as Any]
        
    }
    
    
    func generateExcelFile(){
        let filename = generateFileExportName().appending(".xlsx")
                
        var workbook: UnsafeMutablePointer<lxw_workbook>?
        var worksheet: UnsafeMutablePointer<lxw_worksheet>?
        var format_header: UnsafeMutablePointer<lxw_format>?
        var format_1: UnsafeMutablePointer<lxw_format>?
        
        var destination_path = generateDocDirectory()
        destination_path.append(filename)
        
        workbook = workbook_new(destination_path)
        worksheet = workbook_add_worksheet(workbook, nil)
        
        // Add style
        format_header = workbook_add_format(workbook)
        format_set_bold(format_header)
        format_1 = workbook_add_format(workbook)
        format_set_bg_color(format_1, 0xDDDDDD)
        
        //cell size
        let cell_width: Double = 50
        let cell_height: Double = 50
        var writingLine: UInt32 = 0
        
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
        
        for accessory in accessories {
            writingLine += 1
            
            worksheet_write_string(worksheet, writingLine, 0, "\(writingLine)", nil)
            worksheet_write_string(worksheet, writingLine, 2, accessory.name, nil)
            worksheet_write_number(worksheet, writingLine, 3, accessory.price, nil)
            worksheet_write_number(worksheet, writingLine, 4, Double(accessory.stock), nil)
            worksheet_write_string(worksheet, writingLine, 5, accessory.status, nil)
            worksheet_write_string(worksheet, writingLine, 6, accessory.location, nil)
            
        }
        
        for (index, accessory) in accessories.enumerated() {
            let row = UInt32(index + 1)
            worksheet_set_row(worksheet, row, Double(cell_height), nil)
            let image = Helper.getImage(imageUrl: accessory.imageUrl)
            var options = lxw_image_options()
            
            // Pixel size is Point size x image scale
            let imageScale = image.scale
            let uiimageSizeInPixel = (Double(image.size.width * imageScale), Double(image.size.height * imageScale))
            let scale = Helper.minRatio(left: (cell_width, cell_height),
                                        right: uiimageSizeInPixel )
            options.x_offset = 10
            options.y_offset = 1
            options.x_scale = scale
            options.y_scale = scale
            options.object_position = 1
            
            if let nsdata = image.jpegData(compressionQuality: 0.9) as NSData? {
                let buffer = Helper.getArrayOfBytesFromImage(imageData: nsdata)
                worksheet_insert_image_buffer_opt(worksheet, row, 1, buffer, buffer.count, &options)
            }
            
        }
        workbook_close(workbook)
        
        let docURL = URL(fileURLWithPath: destination_path)
        self.documentItemsExport = [docURL as Any]
    }
}
