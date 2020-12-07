import 'package:dio/dio.dart';

ApiClient apiClient = ApiClient();

class ApiClient {
  Dio getInstance() {
    return Dio(
      BaseOptions(
        headers: {'Content-type': 'application/json; charset=utf-8'},
        baseUrl: 'http://65.0.188.240:5000/api/',
        connectTimeout: 90 * 1000,
        receiveTimeout: 60 * 1000,
      ),
    );
  }

  Future<Response<Map>> getCircle(String id) async {
    return await getInstance().get('circle_list/$id');
  }

  Future<Response<Map>> getProfile(String id) async {
    return await getInstance().get('users_profile/$id');
  }

  Future<Response<Map>> userExist(String mobile) async {
    String path = 'users_profile/userExist';
    return await getInstance().post(path, data: {'mobile': mobile});
  }


  Future<Response<Map>> addCircle(Map<String, dynamic> params) async {
    /*Map params = Map<String, dynamic>();
    params['circle_admin'] = circle_admin;
    params['description'] = description;
    params['news_board'] = news_board;
    params['rules'] = rules;
    params['type'] = type;
    params['name'] = name;*/
    return await getInstance().post('circle_list', data: params);
  }

  Future<Response<Map>> login(Map<String, dynamic> params) async {
    /*Map params = Map<String, dynamic>();
    params['password'] = password;
    params['mobile'] = mobile;*/
    return await getInstance().post('users_profile/login', data: params);
  }

  Future<Response<Map>> register(Map<String, dynamic> params) async {
    /*Map params = Map<String, dynamic>();
    params['password'] = password;
    params['mobile'] = mobile;
    params['email'] = email;
    params['name'] = name;*/
    return await getInstance().post('users_profile', data: params);
  }
}

/*1) add circle list
method : post
url )
 http://localhost:5000/api/circle_list
parms :

{
  "name": "sanjeev",
  "type": "family",
  "description": "for my family",
   "circle_admin": "426",
   "rules": "no rule is here",
   "news_board": "hellp its a family group"
}

2) get circle list
method : get
url ) http://localhost:5000/api/circle_list









*/
