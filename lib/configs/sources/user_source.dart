import 'package:dartz/dartz.dart';
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/configs/constants/app_request.dart';
import 'package:mylaundry/configs/constants/app_response.dart';
import 'package:mylaundry/configs/constants/failure.dart';
import 'package:http/http.dart' as http;

class UserSource {
  static Future<Either<Failure, Map>> register(
    String username,
    String email,
    String password,
  ) async {
    Uri url = Uri.parse('${AppConstant.baseUrl}/register');
    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(),
        body: {'username': username, 'email': email, 'password': password},
      );

      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(FetchFailure(e.toString()));
    }
  }
}
