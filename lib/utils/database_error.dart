// database_error.dart

class DatabaseError {
  final String message;

  DatabaseError(this.message);

  @override
  String toString() {
    return 'DatabaseError: $message';
  }
}
