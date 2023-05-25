import 'dart:convert';

import 'package:flutter_country_restapi/app/data/model/country_model.dart';
import 'package:http/http.dart' as http;

class CountryApi {
  Future<List<Country>?> getAllCountries() async {
    var client = http.Client();

    var uri = Uri.parse('https://restcountries.com/v3.1/all');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return countryFromJson(const Utf8Decoder().convert(response.bodyBytes));
    }
    return null;
  }
}
