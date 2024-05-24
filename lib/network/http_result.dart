class MainModel {
  MainModel({required this.status, this.data, this.error});

  int status;
  dynamic data, error;

  factory MainModel.fromJson(Map<String, dynamic> json) => MainModel(
        status: json['status'] is int ? json['status'] : 200,
        data: json['data'],
        error: json['errors']
      );


  MainModel copyWith({
    int? status,
    dynamic data,
    dynamic error,
  }) {
    return MainModel(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}

MainModel get defaultModel => MainModel(
  status: 403,
  error: {'description': 'unknown error'},
);
