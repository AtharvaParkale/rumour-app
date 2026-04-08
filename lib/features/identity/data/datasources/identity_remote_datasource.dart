import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_identity_model.dart';

abstract class IdentityRemoteDataSource {
  Future<UserIdentityModel> fetchRandomUser();
}

class IdentityRemoteDataSourceImpl implements IdentityRemoteDataSource {
  final http.Client client;

  IdentityRemoteDataSourceImpl({required this.client});

  @override
  Future<UserIdentityModel> fetchRandomUser() async {
    final response = await client.get(Uri.parse('https://randomuser.me/api/'));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final userResult = decoded['results'][0];

      final name =
          '${userResult['name']['first']} ${userResult['name']['last']}';
      final avatar = userResult['picture']['large'];

      final safeId = DateTime.now().microsecondsSinceEpoch.toString();

      return UserIdentityModel(id: safeId, name: name, avatar: avatar);
    } else {
      throw Exception('Failed to fetch a new identity randomly.');
    }
  }
}
