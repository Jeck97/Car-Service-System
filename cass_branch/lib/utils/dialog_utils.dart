import 'package:flutter/material.dart';

class DialogUtils {
  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext _context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(_context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> confirm(BuildContext context, String message) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(_context).pop(false),
              child: Text('NO'),
            ),
            TextButton(
              onPressed: () => Navigator.of(_context).pop(true),
              child: Text('YES'),
            ),
          ],
        );
      },
    ).then((value) => value).onError((error, stackTrace) => false);
  }
}

class DialogTitle extends StatelessWidget {
  final String _title;
  DialogTitle(this._title);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          _title,
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(color: Colors.indigo),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close, color: Colors.indigo),
          tooltip: 'Close',
        )
      ],
    );
  }
}

class DialogAction extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  DialogAction({
    @required this.label,
    @required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: Colors.indigo),
      ),
      onPressed: onPressed,
    );
  }
}
