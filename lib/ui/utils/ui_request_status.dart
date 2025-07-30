sealed class UiRequestStatus {}

class ShowData<T> extends UiRequestStatus {
  final T data;
  ShowData(this.data);
}

class ShowError extends UiRequestStatus {
  final Object error;
  ShowError(this.error);
}

class ShowLoading extends UiRequestStatus {}

class Inactive extends UiRequestStatus {}