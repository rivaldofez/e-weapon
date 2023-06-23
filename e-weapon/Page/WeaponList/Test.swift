//
//  Test.swift
//  e-weapon
//
//  Created by Rivaldo Fernandes on 22/06/23.
//

import Foundation
import UIKit
import xlsxwriter

    // FAKE DATA
    struct Product {
        var quantity: Int
        var name: String
        var image: String
    }

    class Database {
        let product1 = Product(quantity: 12, name: "super product one", image: "sun.min.fill")
        let product2 = Product(quantity: 24, name: "super product 2", image: "sun.min.fill")
        lazy var productList: [Product] = {
            return [product1, product2]
        }()
    }
    // END OF FAKE DATA

final class ExportXlsxService {
    
    let filename = "export_database.xlsx"
    let cell_width: Double = 64
    let cell_height: Double = 50

    var workbook: UnsafeMutablePointer<lxw_workbook>?
    var worksheet: UnsafeMutablePointer<lxw_worksheet>?
    var format_header: UnsafeMutablePointer<lxw_format>?
    var format_1: UnsafeMutablePointer<lxw_format>?
    
    private var writingLine: UInt32 = 0
    private var needWriterPreparation = false
    
    private var pathBook: String = ""
    
    init() {
        prepareXlsWriter()
    }
    
    /// Get the sandbox directory
    private func docDirectoryPath() -> String{
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask,
                                                           true)
        return dirPaths[0]
    }
    
    /// Prepare the xlsx objects
    private func prepareXlsWriter() {
        print("open \(docDirectoryPath())")
        var destination_path = docDirectoryPath()
        pathBook = destination_path
        destination_path.append(filename)
        workbook = workbook_new(destination_path)
        worksheet = workbook_add_worksheet(workbook, nil)
        // Add style
        format_header = workbook_add_format(workbook)
        format_set_bold(format_header)
        format_1 = workbook_add_format(workbook)
        format_set_bg_color(format_1, 0xDDDDDD)
        needWriterPreparation = false
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
    
    /// The first line is the header, we use bold style, and we write the column titles
    private func buildHeader() {
        writingLine = 0
        let format = format_header
        format_set_bold(format)
        worksheet_write_string(worksheet, writingLine, 0, "image", format)
        worksheet_write_string(worksheet, writingLine, 1, "name", format)
        worksheet_write_string(worksheet, writingLine, 2, "quantity", format)
    }
    
    /// Create a line for a product, change the style for odd row
    private func buildNewLine(product: Product) {
        writingLine += 1
        let lineFormat = (writingLine % 2 == 1) ? format_1 : nil
        worksheet_write_string(worksheet, writingLine, 1, product.name, lineFormat)
        worksheet_write_number(worksheet, writingLine, 2, Double(product.quantity), lineFormat)
    }
    
    /// Create and write / overwrite the xlsx file
    func export() {
        if(needWriterPreparation == true){
            prepareXlsWriter()
        }
        
        buildHeader()
    
        let list = Database().productList
        
        for product in list {
            buildNewLine(product: product)
        }
        
        // Write UIImage to excel
        for (index, product) in list.enumerated() {
            let row = UInt32(index + 1)
            worksheet_set_row(worksheet, row, Double(cell_height), nil)
            if let image = UIImage(systemName: product.image) {
                var options = lxw_image_options()
                // Pixel size is Point size x image scale
                let imageScale = image.scale
                let uiimageSizeInPixel = (Double(image.size.width * imageScale), Double(image.size.height * imageScale))
                let scale = minRatio(left: (cell_width, cell_height),
                                     right: uiimageSizeInPixel )
                options.x_offset = 1
                options.y_offset = 1
                options.x_scale = scale
                options.y_scale = scale
                options.object_position = 1
                
                if let nsdata = image.jpegData(compressionQuality: 0.9) as NSData? {
                    let buffer = getArrayOfBytesFromImage(imageData: nsdata)
                    worksheet_insert_image_buffer_opt(worksheet, row, 0, buffer, buffer.count, &options)
                }
            }
        }
    
        // Closing the workbook will save the xlsx file on the filesystem
        workbook_close(workbook)
        needWriterPreparation = true
        
        
    }
}

