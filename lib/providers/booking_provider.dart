import 'package:flutter/foundation.dart';
import '../models/booking_request.dart';

class BookingProvider extends ChangeNotifier {
  final List<BookingRequest> _bookingRequests = [];

  List<BookingRequest> get allBookings => List.unmodifiable(_bookingRequests);

  // Get bookings for a specific product
  List<BookingRequest> getBookingsByProduct(String productId) {
    return _bookingRequests
        .where((booking) => booking.productId == productId)
        .toList();
  }

  // Get pending bookings for a product
  List<BookingRequest> getPendingBookingsByProduct(String productId) {
    return _bookingRequests
        .where(
          (booking) =>
              booking.productId == productId && booking.status == 'pending',
        )
        .toList();
  }

  // Add new booking request
  void addBookingRequest(BookingRequest booking) {
    _bookingRequests.add(booking);
    notifyListeners();
  }

  // Update booking status
  void updateBookingStatus(String bookingId, String newStatus) {
    final index = _bookingRequests.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookingRequests[index] = _bookingRequests[index].copyWith(
        status: newStatus,
      );
      notifyListeners();
    }
  }

  // Remove booking
  void removeBooking(String bookingId) {
    _bookingRequests.removeWhere((b) => b.id == bookingId);
    notifyListeners();
  }

  // Get booking count for a product
  int getBookingCount(String productId) {
    return getBookingsByProduct(productId).length;
  }

  // Get pending booking count for a product
  int getPendingBookingCount(String productId) {
    return getPendingBookingsByProduct(productId).length;
  }
}
