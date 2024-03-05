import 'package:flutter/material.dart';
class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key, this.isDeleteForAll = false, this.deleteForAll, this.deleteForMe});
  final bool isDeleteForAll;
  final VoidCallback? deleteForMe, deleteForAll;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("DeleteMessage"),
      actions:
      [
        InkWell(
            onTap:(){
              deleteForMe!();
              Navigator.pop(context);
            },
            child: const Text("Delete for me")),
        if(isDeleteForAll) InkWell(
            onTap: (){
              deleteForAll!();
              Navigator.pop(context);
            },
            child: const Text("Delete for all"))
      ],
    );
  }
}
