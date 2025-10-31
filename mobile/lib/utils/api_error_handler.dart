String getErrorMessage(dynamic error) {
  if (error is String) return error;
  if (error is Map && error.containsKey('message')) return error['message'];
  return 'Something went wrong';
}
