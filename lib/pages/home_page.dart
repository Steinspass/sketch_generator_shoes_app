import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:picture_generator/api/api_services.dart';
import 'package:picture_generator/utils/save_to_image.dart';
import 'package:picture_generator/widgets/button_gradient_widget.dart';
import 'package:picture_generator/widgets/drawing_area_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _loading = true;

  List<DrawingArea> points = [];

  double paintSizeHeight;
  double paintSizeWidth;

  Widget imageOutput = Container();

  ByteData imgBytes = ByteData(1024);

  String imgUrl = '';


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    paintSizeHeight = MediaQuery.of(context).size.height / 2.4;
    paintSizeWidth = MediaQuery.of(context).size.width - 50;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildStackContainer(),
    );
  }

  Widget _buildStackContainer() {
    return Stack(
      children: [
        _containerBackground(),
        _loading ? _containerPaintUser() : _containerPaintSaved(),
      ],
    );
  }

  Widget _containerBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3B3957),
            Color(0xFF4D344D),
            Color(0xFF57313F),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      ),
    );
  }

  Widget _containerPaintUser() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _boxPaint(),
          _rowButtons(),
        ],
      ),
    );
  }

  Widget _boxPaint() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        height: MediaQuery.of(context).size.height / 2.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400].withOpacity(0.4),
              blurRadius: 5.0,
              spreadRadius: 4
            )
          ],
        ),
        child: _paintDetector(),
      ),
    );
  }

  Widget _paintDetector() {
    return GestureDetector(
      child: _backgroundPainter(),
      onPanDown: (details) {
        this.setState(() {
          points.add(
            DrawingArea(
              point: details.localPosition, 
              areaPaint: 
              Paint()
                ..strokeCap = StrokeCap.round
                ..isAntiAlias = true
                ..color = Colors.black
                ..strokeWidth = 5.0
            )
          );
        });
      },
      onPanUpdate: (details) {
        this.setState(() {
          points.add(
            DrawingArea(
              point: details.localPosition, 
              areaPaint: 
              Paint()
                ..strokeCap = StrokeCap.round
                ..isAntiAlias = true
                ..color = Colors.black
                ..strokeWidth = 5.0
            )
          );
        });
      },
      onPanEnd: (details) {
        this.setState(() {
          points.add(null);
        });
      },
    );
  }

  Widget _backgroundPainter() {
    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(20)
        ),
        child: CustomPaint(
          painter: MyCustomPainter(
            points: points
          ),
        ),
      ),
    );
  }

  Widget _rowButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonGradientWidget(
            title: 'Save the paint', 
            onTap: () async {
              imgBytes = await saveToImage(points, paintSizeWidth, paintSizeHeight);

              final listBytes = Uint64List.view(imgBytes.buffer);

              File file = await writeBytes(listBytes);
              // setState(() { });
              
              imgUrl = await fetchResponse(file);

              _loading = false;
              setState(() { });

              print('* IMAGE URL: $imgUrl');
            }
          ),
          
          ButtonGradientWidget(
            title: 'Clear the paint', 
            onTap: (){
              setState(() {
                points.clear();
              });
            }
          ),
        ],
      ),
    );
  }

  Widget _containerPaintSaved(){
    return SafeArea(
          child: Center(
        child: Column(
          children: [
            SizedBox(height: 30,),
            _imageSaved(),
            SizedBox(height: 30,),
            _imageOutput(),
            _buttonBack(),
          ],
        ),
      ),
    );
  }

  Widget _imageOutput() {
    return Center(
      child: Container(
        height: 256, 
        width: 256,
        child: imgUrl != null 
        ? CachedNetworkImage(imageUrl: imgUrl)
        : Center(child: Text('Error Image', style: TextStyle(color: Colors.white, fontSize: 24.0),))
      ),
    );

  }

  Widget _imageSaved() {
    return Center(
      child: imgBytes != null 
      ? Image.memory(
        Uint8List.view(imgBytes.buffer),
        height: paintSizeHeight,
        width: paintSizeWidth,
      )
      : Center(child: Text('No image Saved', style: TextStyle(color: Colors.white, fontSize: 24.0),))
    );

  }

  Widget _buttonBack() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ButtonGradientWidget(
        title: 'Back to Paint', 
        onTap: (){
          _loading = true;
          this.setState(() { });
        }
      ),
    );
  }
}