import 'package:flutter/cupertino.dart';
import 'app_export.dart';

class AppDialog {
  final BuildContext context;
  final String btnCancelText;
  final String message;

  AppDialog(
    this.context, {
    Key key,
    this.message,
    this.btnCancelText,
  }) {
    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.INFO,
      body: Center(
        child: Text(
          getLocalized(context, message),
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      btnCancelOnPress: () {},
      btnCancelText: btnCancelText,
    ).show();
  }
}

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 247, 247, 247),
      ),
      child: child,
    );
  }
}

class BackgroundBack extends StatelessWidget {
  final List<Widget> children;
  final String title;

  const BackgroundBack({
    Key key,
    this.title = '',
    @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Background(
        child: Column(children: children),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  const DashboardButton(
    this.label, {
    Key key,
    this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(
              icon,
              size: 72,
              color: Color.fromARGB(255, 233, 143, 1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 233, 143, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppImage extends StatelessWidget {
  final VoidCallback onGallery;
  final VoidCallback onCamera;
  final Widget child;

  const AppImage({
    Key key,
    this.child,
    this.onCamera,
    this.onGallery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return getAlertDialog(context);
            });
      }),
      child: child,
    );
  }

  AlertDialog getAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text('From where do you want to take the photo?'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            GestureDetector(
              child: Padding(
                child: Text('Gallery'),
                padding: EdgeInsets.all(12),
              ),
              onTap: onGallery,
            ),
            Divider(),
            GestureDetector(
              child: Padding(
                child: Text('Camera'),
                padding: EdgeInsets.all(12),
              ),
              onTap: onCamera,
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class AppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color color;

  const AppButton({Key key, this.onPressed, this.color, this.label = 'NEXT'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Color.fromARGB(255, 233, 143, 1),
        borderRadius: BorderRadius.circular(0),
        /* boxShadow: [
            BoxShadow(
                color: Colors.orange.shade200,
                offset: Offset(1, -2),
                blurRadius: 5),
            BoxShadow(
                color: Colors.orange.shade200,
                offset: Offset(-1, 2),
                blurRadius: 5)
          ]*/
      ),
      child: ButtonTheme(
        height: 50,
        child: FlatButton(
          onPressed: onPressed,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
    /*return MaterialButton(
      onPressed: onPressed,
      color: Colors.deepOrangeAccent,
      padding: EdgeInsets.all(18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );*/
  }
}

class AppIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;
  final String label;
  final Color done;

  const AppIconButton(
      {Key key, this.onPressed, this.iconData, this.label, this.done})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.fromLTRB(18, 9, 18, 9),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData ?? Icons.play_circle_fill,
                color: const Color.fromARGB(255, 233, 143, 1),
              ),
            ),
            SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.check_circle,
              color: done ?? Colors.grey,
              size: 18,
            ),
            SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black54,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class AppFormField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final VoidCallback onTap;

  final String initialValue;
  final String labelText;
  final String hintText;

  final Icon prefixIcon;
  final Icon suffixIcon;
  final bool readOnly;

  final int maxLength;
  final int minLines;

  AppFormField({
    Key key,
    this.onTap,
    this.hintText,
    this.minLines,
    this.onChanged,
    this.labelText,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.initialValue,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      maxLines: null,
      autofocus: false,
      readOnly: readOnly,
      minLines: minLines,
      onChanged: onChanged,
      maxLength: maxLength,
      controller: controller,
      maxLengthEnforced: false,
      keyboardType: keyboardType,
      initialValue: initialValue,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class AppFormRichText extends StatelessWidget {
  final String labelText;
  final bool required;

  AppFormRichText({
    Key key,
    this.labelText,
    this.required = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: null,
      text: TextSpan(
          text: labelText,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: required ? '*' : '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]),
    );
  }
}

class AppAccordion extends StatelessWidget {
  final List<Widget> children;
  final String title;

  AppAccordion({
    Key key,
    this.title,
    this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(3),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          const Radius.circular(3),
        ),
        child: GFAccordion(
          title: title,
          margin: EdgeInsets.all(0),
          contentPadding: EdgeInsets.all(0),
          textStyle: TextStyle(color: Colors.white, fontSize: 16),
          collapsedIcon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
          expandedIcon: Icon(Icons.keyboard_arrow_up, color: Colors.white),
          collapsedTitleBackgroundColor: Colors.orange.shade300,
          expandedTitleBackgroundColor: Colors.blueGrey,
          contentChild: ListView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(12, 24, 12, 24),
            shrinkWrap: true,
            children: children,
          ),
        ),
      ),
    );
  }
}

class AppLoadingProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 55,
        height: 55,
        color: Colors.transparent,
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}

// CustomPainter class to for the header curved-container
class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color.fromARGB(255, 233, 143, 1);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 250.0, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class GetLoader extends StatelessWidget {
  final String value;
  final bool isEmpty;

  const GetLoader({Key key, this.isEmpty = true, this.value = 'Empty'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: isEmpty
            ? GFShimmer(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : GFLoader(loaderColorOne: Colors.white),
      ),
    );
  }
}
