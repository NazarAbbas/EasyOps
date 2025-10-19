class ReOpenWorkOrderRequest {
  final String status;
  final String remark;
  final String comment;

  ReOpenWorkOrderRequest({
    required this.status,
    required this.remark,
    required this.comment,
  });

  Map<String, dynamic> toJson() => {
        'status': status,
        'remark': remark,
        'comment': comment,
      };
}
