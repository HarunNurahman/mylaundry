import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/configs/constants/app_request.dart';
import 'package:mylaundry/configs/constants/app_response.dart';
import 'package:mylaundry/configs/constants/app_session.dart';
import 'package:mylaundry/configs/constants/failure.dart';
import 'package:mylaundry/models/user/user.dart';

class LaundryService {
  static Future<Either<Failure, Map>> readByUserId(userId, params) async {
    String queryString = AppRequest.params(params);
    Uri url = Uri.parse(
      '${AppConstant.baseUrl}/laundry/user/$userId?$queryString',
    );

    final token = await AppSession.getBearerToken();
    try {
      final response = await http.get(url, headers: AppRequest.header(token));
      final data = AppResponse.data(response);

      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }

      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> claimLaundry(laundryId, claimCode) async {
    Uri url = Uri.parse('${AppConstant.baseUrl}/laundry/claim');
    User? user = await AppSession.getUser();
    final token = await AppSession.getBearerToken();
    try {
      final response = await http.post(
        url,
        headers: AppRequest.header(token),
        body: {
          'id': laundryId,
          'claim_code': claimCode,
          'user_id': user!.id.toString(),
        },
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
