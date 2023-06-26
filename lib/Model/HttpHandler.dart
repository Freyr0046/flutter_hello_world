import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_hello_world/Model/Response.dart' as ModelResponse;
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart';

class HttpHandler {
  // String _host = "http://stshine.downloadapp.club/api/";
  String _host = "https://api.github.com/";

//  String _host = "http://192.168.0.107:9096/api/";
  String _url;
  List<Asset> _imageAsset = [];
  List<File> _imageList = [];
  Map<String, dynamic> _formData = {};
  static Map<String, HttpHandler>? _cache = {};

  HttpHandler._internal(this._url);

  factory HttpHandler(String key) {
    _cache ??= {};

    if (_cache!.containsKey(key)) {
      // return _cache[key];
      return _cache![key]!;
    } else {
      final httpHandler = HttpHandler._internal(key);
      _cache![key] = httpHandler;
      return httpHandler;
    }
  }

  void setFormData(Map<String, String> formData) {
    _formData = formData;
  }

  void addImageList(List<File> imageList) {
    _imageList = imageList;
  }

  void addImageAssetList(List<Asset> imageAsset) {
    _imageAsset = imageAsset;
  }

  Future postWithAsset(
      Function(dynamic) success, Function(String) error) async {
    print("api_url: $_host$_url");
    print("api_parameters: ${_formData.toString()}");

    var request = http.MultipartRequest("POST", Uri.parse(_host + _url));

    _formData.forEach((String key, dynamic value) {
      if (value == null) {
        error("$key不能為null，api發送失敗");
        return;
      }
      request.fields[key] = value;
    });

    if (_imageAsset != null) {
      for (var i = 0; i < _imageAsset.length; i++) {
        var asset = _imageAsset[i];
        if (asset != null) {
          ByteData byteData = await asset.requestOriginal();
          List<int> imageData = byteData.buffer.asUint8List();
          MultipartFile multipartFile = MultipartFile.fromBytes(
            'upload',
            imageData,
            filename: asset.name,
            contentType: MediaType("image", "jpeg"),
          );

          request.files.add(multipartFile);
        }
      }
    }

    await request.send().then((response) {
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        if (response.statusCode == 200) {
          success(jsonDecode(value));
        } else if (response.statusCode == 401) {
          var r = ModelResponse.Response.fromJson(jsonDecode(value));
          error(r.message);
        }
      });
    });
  }

  Future postWithFile(Function(dynamic) success, Function(String) error) async {
    print("api_url: $_host$_url");
    print("api_parameters: ${_formData.toString()}");

    var request = http.MultipartRequest("POST", Uri.parse(_host + _url));

    _formData.forEach((String key, dynamic value) {
      if (value == null) {
        error("$key不能為null，api發送失敗");
        return;
      }
      request.fields[key] = value;
    });

    if (_imageList != null) {
      for (var i = 0; i < _imageList.length; i++) {
        var file = _imageList[i];
        if (file != null) {
          var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));

          var length = await file.length();

          var multipartFile = http.MultipartFile('upload', stream, length,
              filename: basename(file.path),
              contentType: MediaType('image', 'jpeg'));

          request.files.add(multipartFile);
        }
      }
    }

    await request.send().then((response) {
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
        if (response.statusCode == 200) {
          success(jsonDecode(value));
        } else if (response.statusCode == 401) {
          var r = ModelResponse.Response.fromJson(jsonDecode(value));
          error(r.message);
        }
      });
    });
  }

  Future post(Function(dynamic) success, Function(String) error) async {
    print("api_url: $_host$_url");
    print("api_parameters: ${_formData.toString()}");

    await http
        .post(Uri.parse(_host + _url), //"${_host} ${_url}",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: _formData,
            encoding: Encoding.getByName("utf-8"))
        .then((response) {
      Utf8Decoder decoder = const Utf8Decoder();
      var json = jsonDecode(decoder.convert(response.bodyBytes));

      print("Response_status $_url: ${response.statusCode}");
      print("Response_body $_url: $json");

      if (response.statusCode == 200) {
        if (success != null) {
          success(json);
        }
      } else if (response.statusCode == 401) {
        var r = ModelResponse.Response.fromJson(json);
        if (error != null) {
          error(r.message);
        }
      }
    });
  }

  Future get(Function(dynamic) success, Function(String) error) async {
    print("api_url: $_host$_url");
    print("api_parameters: ${_formData.toString()}");

    await http.get(Uri.parse(_host + _url), headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }).then((response) {
      Utf8Decoder decoder = const Utf8Decoder();
      var json = jsonDecode(decoder.convert(response.bodyBytes));

      print("Response_status $_url: ${response.statusCode}");
      print("Response_body $_url: $json");

      if (response.statusCode == 200) {
        if (success != null) {
          success(json);
        }
      } else if (response.statusCode == 401) {
        var r = ModelResponse.Response.fromJson(json);
        if (error != null) {
          error(r.message);
        }
      }
    });
  }
}
