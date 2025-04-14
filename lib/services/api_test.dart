import 'package:http/http.dart' as http;

Future<void> simpleGetTest() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/1');
  final response = await http.get(url);

  print('Status code: ${response.statusCode}');
  print('Body: ${response.body}');
}
