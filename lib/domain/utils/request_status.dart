sealed class RequestStatus {}

class Success<T> extends RequestStatus {
  final T data;
  Success(this.data);
}

class Failure extends RequestStatus {
  final Object error;
  Failure(this.error);
}