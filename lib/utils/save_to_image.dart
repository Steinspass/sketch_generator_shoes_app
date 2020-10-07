import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:picture_generator/widgets/drawing_area_widget.dart';

Future<ByteData> saveToImage(List<DrawingArea> points, double width, double height) async {

  final recorder = ui.PictureRecorder();

  final canvas = Canvas(
    recorder,
    Rect.fromPoints(
      Offset(0.0, 0.0), 
      Offset(200, 200)
    )
  );

  Paint paint = Paint()
                ..strokeCap = StrokeCap.round
                ..isAntiAlias = true
                ..color = Colors.black
                ..strokeWidth = 4.0;
  
  Paint paintBackground = Paint()..style = PaintingStyle.fill..color = Colors.grey[100];

  canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paintBackground);

  for (var x = 0; x < points.length; x++) {
     
    if(points[x] != null && points[x+1] != null){

      canvas.drawLine(
        points[x].point, 
        points[x + 1].point, 
        paint
      );

    }

  }

  final picture = recorder.endRecording();

  final img = await picture.toImage(width.toInt(), height.toInt());

  final pngBytes = await img.toByteData(
    format: ui.ImageByteFormat.png
  );

  //final listBytes = Uint64List.view(pngBytes.buffer);

  //File file = await writeBytes(listBytes);


  return pngBytes; 

}

Future<String> get _localPath async{

  final directory = await getApplicationDocumentsDirectory();

  return directory.path;

}

Future<File> get _localFile async{
  final path = await _localPath;

  return File('$path/test.png');
}

Future<File> writeBytes(Uint64List listBytes) async {

  final file = await _localFile;

  return file.writeAsBytes(listBytes, flush: true);

}