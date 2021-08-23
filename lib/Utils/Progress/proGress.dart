import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
class CircularProgress extends StatefulWidget {
  const CircularProgress({Key? key}) : super(key: key);

  @override
  _CircularProgressState createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress> with SingleTickerProviderStateMixin{

  AnimationController? progressController;
  Animation<double>? animation;
  double value = 80;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    progressController = AnimationController(vsync: this,duration: Duration(milliseconds: 2000));
    animation = Tween<double>(begin: 0,end: value).animate(progressController!)..addListener(() {
      setState(() {

      });
    });
  }

  var record = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        //color: Colors.teal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomPaint(
              foregroundPainter: CircleProgress(animation!.value),
              child: Container(
                width: 200,
                height: 200,
                child: Center(child: Text("${animation!.value.toInt()}%",style: TextStyle(color: Colors.teal,fontSize: 24),)),
              ),
            ),
            SizedBox(height: 50,),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(top: 20,bottom: 25),
                alignment: Alignment.center,
                width: 270,
                height: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(record ? Icons.fiber_manual_record_rounded : Icons.stop,color: Colors.redAccent,size: 40,),
                    SizedBox(width: 20,),
                    Text("RECORD",style: TextStyle(fontSize: 24,color: Colors.teal),),
                  ],
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                    border:Border.all(
                        color: Colors.teal,
                        width: 3
                    )
                ),
              ),
              onTap: (){
                if(animation!.value == 80){
                  progressController!.reverse();
                }else{
                  progressController!.forward();
                }
                print("SAVE DATA");
                setState(() {
                  record = !record;
                });
              },
            ),
          ],

        ),
      ),
    );
  }
}

class CircleProgress extends CustomPainter{

  double currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle = Paint()
        .. strokeWidth = 10
        ..color = Colors.teal
        .. style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 10
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    Offset center = Offset(size.width/2,size.height/2);
    double radius = min(size.width/2, size.height/2)-7;
    
    canvas.drawCircle(center, radius, outerCircle);

    double angle = 2 * pi * (currentProgress/100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi/2, angle, false, completeArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
