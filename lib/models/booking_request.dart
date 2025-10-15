class BookingRequest {
  final String id;
  final String productId;
  final String productName;
  final String borrowerName;
  final String borrowerPhone;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final String paymentMethod;
  final String deliveryMethod;
  final DateTime requestDate;
  final String status; // 'pending', 'approved', 'rejected'

  BookingRequest({
    required this.id,
    required this.productId,
    required this.productName,
    required this.borrowerName,
    required this.borrowerPhone,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.paymentMethod,
    required this.deliveryMethod,
    required this.requestDate,
    this.status = 'pending',
  });

  int get durationDays => endDate.difference(startDate).inDays + 1;

  BookingRequest copyWith({
    String? id,
    String? productId,
    String? productName,
    String? borrowerName,
    String? borrowerPhone,
    DateTime? startDate,
    DateTime? endDate,
    double? totalPrice,
    String? paymentMethod,
    String? deliveryMethod,
    DateTime? requestDate,
    String? status,
  }) {
    return BookingRequest(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      borrowerName: borrowerName ?? this.borrowerName,
      borrowerPhone: borrowerPhone ?? this.borrowerPhone,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      requestDate: requestDate ?? this.requestDate,
      status: status ?? this.status,
    );
  }
}
