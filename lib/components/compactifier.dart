import 'dart:convert';

String correctJsonFormat(String jsonString) {
  // Adjusting the regex to correctly format the jsonString
  var correctedData = jsonString
      .replaceAllMapped(RegExp(r'(\w+)\.'), (match) => '${match[1]}')
      .replaceAllMapped(RegExp(r'(\w+):'), (match) => '"${match[1]}":')
      .replaceAllMapped(RegExp(r': (\w+)'), (match) => ': "${match[1]}"')
      .replaceAll("'", '"');
  correctedData =
      correctedData.replaceAll('true', '1').replaceAll('false', '0');
  Map<String, dynamic> data = jsonDecode(correctedData);

  data.forEach((key, value) {
    if (key != 'Typesteam' && value is String && int.tryParse(value) != null) {
      data[key] = int.parse(value);
    }
  });
  return jsonEncode(data);
}
