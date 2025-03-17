import 'package:dartz/dartz.dart';
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/configs/constants/app_request.dart';
import 'package:mylaundry/configs/constants/app_response.dart';
import 'package:mylaundry/configs/constants/app_session.dart';
import 'package:mylaundry/configs/constants/failure.dart';
import 'package:http/http.dart' as http;

class PromoService {
  static Future<Either<Failure, Map>> readPromo() async {
    Uri url = Uri.parse('${AppConstant.baseUrl}/promo/limit');
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
}
