import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../features/orders/data/models/order_model.dart';
import '../features/customers/data/models/customer_model.dart';
import 'package:intl/intl.dart';

class PdfService {
  static Future<void> generateAndShareInvoice(
    OrderModel order,
    List<OrderItemModel> items,
    Customer customer,
    List<dynamic> itemDetails // Passing item names as well
  ) async {
    final pdf = pw.Document();
    final dateStr = DateFormat('dd MMM yyyy, hh:mm a').format(order.dateTime);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('APLI BHAJI', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Vegetables & Medicines'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Invoice #${order.id}'),
                      pw.Text('Date: $dateStr'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 30),

              // Customer Details
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey300)),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Bill To:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(customer.name),
                    pw.Text('Phone: ${customer.phone}'),
                    if (customer.houseNumber != null) pw.Text('House No: ${customer.houseNumber}'),
                    if (customer.address != null) pw.Text('Address: ${customer.address}'),
                    pw.Text('Status: ${order.status}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),

              // Items Table
              pw.Table.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ['Item', 'Qty', 'Unit', 'Price', 'Total'],
                data: List.generate(items.length, (index) {
                  final item = items[index];
                  return [
                    'Item ID: ${item.itemId}', // Ideally item names should be passed
                    item.quantity.toString(),
                    'unit',
                    item.price.toStringAsFixed(2),
                    item.total.toStringAsFixed(2),
                  ];
                }),
              ),

              pw.SizedBox(height: 30),

              // Footer / Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Subtotal: ₹${order.totalAmount.toStringAsFixed(2)}'),
                      pw.Text('Discount: ₹${order.discount.toStringAsFixed(2)}'),
                      pw.Divider(color: PdfColors.black),
                      pw.Text('Final Total: ₹${order.finalAmount.toStringAsFixed(2)}',
                        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Center(child: pw.Text('Thank you for your business!', style: pw.TextStyle(fontStyle: pw.FontStyle.italic))),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice_${order.id}.pdf');
  }
}
