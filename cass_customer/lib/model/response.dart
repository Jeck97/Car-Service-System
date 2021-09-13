class Response<T> {
  static const String MESSAGE = 'message';
  static const String DATA = 'data';

  String? message;
  T? data;
  bool isSuccess;

  Response({this.message, this.data, this.isSuccess = false});
}
