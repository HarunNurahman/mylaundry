import 'dart:convert';

import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class AppResponse {
  static Map data(Response response) {
    DMethod.printResponse(response);

    switch (response.statusCode) {
      case 200:
      case 201:
        var responseBody = jsonDecode(response.body);
        return responseBody;
      case 204:
        return {'success': true};
      case 400:
        throw Exception(response.body);
      case 401:
        throw Exception(response.body);
      case 404:
        throw Exception(response.body);
      case 500:
        throw Exception(response.body);
      default:
        throw Exception(response.body);
    }
  }

  static invalidResponse(BuildContext context, String messageBody) {
    Map errors = jsonDecode(messageBody)['errors'];
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          titlePadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          title: Text('Invalid'),
          children: [
            ...errors.entries.map((e) {
              return ListTile(
                title: e.key,
                subtitle: Column(
                  children:
                      (e.value as List).map((itemError) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('- '),
                            Expanded(child: Text(itemError)),
                          ],
                        );
                      }).toList(),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(onPressed: () {}, child: Text('Close')),
            ),
          ],
        );
      },
    );
  }
}
