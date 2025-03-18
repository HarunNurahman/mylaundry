import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:mylaundry/configs/constants/app_constant.dart';
import 'package:mylaundry/configs/constants/app_request.dart';
import 'package:mylaundry/configs/constants/app_response.dart';
import 'package:mylaundry/configs/constants/app_session.dart';
import 'package:mylaundry/configs/constants/failure.dart';

class ShopService {
  static Future<Either<Failure, Map>> readShopRecommendation() async {
    Uri url = Uri.parse('${AppConstant.baseUrl}/shop/recommendation/limit');
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

  static Future<Either<Failure, Map>> readShop(params) async {
    String queryString = AppRequest.params(params);
    Uri url = Uri.parse('${AppConstant.baseUrl}/shop?$queryString');
    try {
      final response = await http.get(url, headers: AppRequest.header());

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
