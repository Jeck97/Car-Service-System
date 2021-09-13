import 'package:cass_branch/utils/constants.dart';
import 'package:flutter/material.dart';

import 'add_customer_dialog.dart';

const List<String> _COLUMNS = [
  'ID',
  'Name',
  'Phone',
  'Email',
  'App User',
  'Registered Date',
];

class CustomerTable extends StatelessWidget {
  final DataTableSource customerTableSource;
  final TextEditingController controller;
  final Function onFetched;

  CustomerTable({
    @required this.customerTableSource,
    @required this.controller,
    @required this.onFetched,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PaginatedDataTable(
        showFirstLastButtons: true,
        source: customerTableSource,
        rowsPerPage: PaginatedDataTable.defaultRowsPerPage,
        showCheckboxColumn: false,
        header: _CustomerTableHeader(
          controller: controller,
          onFetched: onFetched,
        ),
        actions: _actions(context),
        columns: _dataColumns(),
      ),
    );
  }

  List<Widget> _actions(BuildContext context) {
    return <IconButton>[
      IconButton(
        icon: Icon(Icons.add),
        tooltip: 'Add a new customer',
        onPressed: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AddCustomerDialog(),
        ),
      ),
      IconButton(
        icon: Icon(Icons.refresh),
        tooltip: 'Refresh',
        onPressed: () {
          controller.clear();
          onFetched();
        },
      ),
    ];
  }

  List<DataColumn> _dataColumns() {
    return List.generate(
      _COLUMNS.length,
      (index) {
        return DataColumn(
          label: Text(
            _COLUMNS[index],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

class _CustomerTableHeader extends StatefulWidget {
  final TextEditingController controller;
  final void Function() onFetched;

  _CustomerTableHeader({
    @required this.controller,
    @required this.onFetched,
  });

  @override
  _CustomerTableHeaderState createState() => _CustomerTableHeaderState();
}

class _CustomerTableHeaderState extends State<_CustomerTableHeader> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    _focusNode
        .addListener(() => setState(() => _hasFocus = _focusNode.hasFocus));
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(() {});
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      onSubmitted: (_) => widget.onFetched(),
      decoration: InputDecoration(
        hintText: 'Search name, phone number or email',
        border: OutlineInputBorder(borderRadius: BORDER_RADIUS24),
        prefixIconConstraints: BoxConstraints(minWidth: 72.0),
        suffixIconConstraints: BoxConstraints(minWidth: 72.0),
        prefixIcon: Icon(Icons.search),
        suffixIcon: _hasFocus ? _closeButton() : null,
      ),
    );
  }

  Widget _closeButton() {
    return IconButton(
      icon: Icon(Icons.close),
      onPressed: () => widget.controller.text.isNotEmpty
          ? widget.controller.clear()
          : _focusNode.unfocus(),
    );
  }
}
