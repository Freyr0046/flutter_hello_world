
class Response{
  Response({required this.message});

  final String message;

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
        message: json['message']
    );
  }
}