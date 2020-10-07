import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

Future<String> fetchResponse(File imageFile) async {
  print('* IMAGE FILE PATH: ${imageFile.path}');

  final mimeTypeData = lookupMimeType(imageFile.path, headerBytes: [0xFF, 0xD9]).split('/');

  final imageUploadRequest = http.MultipartRequest('POST', Uri.parse('http://192.168.1.5:5000/generate'));

  print('* MIME TYPE 0: ${mimeTypeData[0]}');

  print('* MIME TYPE 1: ${mimeTypeData[1]}');

  final file = await http.MultipartFile.fromPath('image', imageFile.path, contentType: MediaType(mimeTypeData[0], mimeTypeData[1]) );

  imageUploadRequest.fields['ext'] = mimeTypeData[1];

  imageUploadRequest.files.add(file);

  try{
    final streamedResponse = await imageUploadRequest.send();

    final response = await http.Response.fromStream(streamedResponse);

    print(' * STATUS CODE: ${response.statusCode}');

    final Map<String, dynamic> responseData = json.decode(response.body);

    String outputFile = responseData['result'];

    print('* OUTPUT FILE: ' + outputFile.toString());

    final imageUrl = await displayResponseImage(outputFile);

    print('* IMAGE URL IN API SERVICE:  $imageUrl');  

    return imageUrl;

  }catch(e){
    print('* ERROR: ' + e.toString());

    return null;
  }
}

Future<String> displayResponseImage(String fileName) async{

  String outputFile = 'http://192.168.1.5:5000/download' + fileName;

  return outputFile;
}