import 'package:flutter/material.dart';
import 'package:hostels/apptheme.dart';
import 'package:hostels/ui/home/detail_room/order/order_appbar.dart';
import 'package:hostels/variables/util_variables.dart';
import 'package:gap/gap.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key, required this.imageUrl});

  final List<String> imageUrl;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  double _scaleFactor = 1.0;
  int currentIndex = 0;
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap(TapDownDetails details) {
    setState(() {
      if (_scaleFactor == 1.0) {
        _scaleFactor = 2.0;
      } else if (_scaleFactor == 2.0) {
        _scaleFactor = 4.0;
      } else {
        _scaleFactor = 1.0;
      }
      final position = details.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * (_scaleFactor - 1),
            -position.dy * (_scaleFactor - 1))
        ..scale(_scaleFactor);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData mTheme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            alignment: Alignment.bottomLeft,
            height: 130.o,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Gap(20.o),
                Row(
                  children: [
                    Gap(20.o),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: mTheme.colorScheme.onBackground,
                        )),
                  ],
                ),
              ],
            ),
          )),
      body: Stack(
        children: [
          InteractiveViewer(
            transformationController: _transformationController,
            child: GestureDetector(
              onDoubleTapDown: _handleDoubleTap,
              child: PageView(
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: List.generate(
                  widget.imageUrl.length,
                  (index) {
                    return Image.network(
                        fit: BoxFit.fitWidth, widget.imageUrl[index]);
                  },

                ),
              ),
            ),
          ),
          Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${currentIndex+1}',style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyLarge!.color),),
                  const Text(' ⸻ '),
                  Text('${widget.imageUrl.length}',style: theme.primaryTextStyle.copyWith(color: mTheme.textTheme.bodyLarge!.color),),
                ],
              ))
        ],
      ),
    );
  }
}
