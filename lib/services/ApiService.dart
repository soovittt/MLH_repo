import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  late String url;

  APIService(this.url);

  Future<String> postRequest(body) async {
    var parsedUrl = Uri.parse(url);
    var response = await http.post(parsedUrl, body: body);
    return response.body;
  }

  Future<Map<String, dynamic>> getRequest() async {
    var parsedUrl = Uri.parse(url);
    http.Response response = await http.get(parsedUrl);
    return jsonDecode(response.body);
  }
}
