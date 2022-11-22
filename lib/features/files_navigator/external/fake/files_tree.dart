import 'package:vido/features/files_navigator/external/fake/tree.dart';
import 'package:vido/features/files_navigator/external/fake/tree_node.dart';
import '../../../../core/domain/entities/app_file.dart';
import '../../../../core/domain/entities/folder.dart';
import '../../../../core/domain/entities/pdf_file.dart';

final appFiles = Tree<int, AppFile>(
  root: TreeNode(
    key: 0, 
    value: const Folder(
      id: 0, 
      name: 'root', 
      parentId: -1, 
      children: [],
      canBeRead: true,
      canBeEdited: true,
      canBeDeleted: false,
      canBeCreatedOnIt: true
    ), 
    children: [
      TreeNode(
        key: 1, 
        value: const Folder(
          id: 1, 
          name: 'facturas', 
          parentId: 0, 
          children: [],
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false,
          canBeCreatedOnIt: true
        ), 
        children: [
          TreeNode(
            key: 2,
            value: const PdfFile(
              id: 2, 
              name: 'Factura 1', 
              parentId: 0, 
              url: 'http://www.africau.edu/images/default/sample.pdf',
              canBeRead: true,
              canBeEdited: true,
              canBeDeleted: false
            ), 
            children: [

            ]
          ),
          TreeNode(
            key: 3,
            value: const PdfFile(
              id: 3, 
              name: 'Factura 2', 
              parentId: 0, 
              url: 'http://www.africau.edu/images/default/sample.pdf',
              canBeRead: true,
              canBeEdited: true,
              canBeDeleted: false
            ), 
            children: [

            ]
          ),
          TreeNode(
            key: 4, 
            value: const PdfFile(
              id: 4, 
              name: 'Factura 3', 
              parentId: 0, 
              url: 'http://www.africau.edu/images/default/sample.pdf',
              canBeRead: true,
              canBeEdited: true,
              canBeDeleted: false
            ), 
            children: [

            ]
          )
        ]
      ),
      TreeNode(
        key: 5, 
        value: const PdfFile(
          id: 5, 
          name: 'file 1', 
          parentId: 0, 
          url: 'http://www.africau.edu/images/default/sample.pdf',
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false
        ), 
        children: [

        ]
      ),
      TreeNode(
        key: 6, 
        value: Folder(
          id: 6, 
          name: 'viajes', 
          parentId: 0, 
          children: [],
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false,
          canBeCreatedOnIt: true
        ), 
        children: [
          TreeNode(
            key: 7, 
            value: const Folder(
              id: 7, 
              name: 'viajes antiguos', 
              parentId: 0, 
              children: [],
              canBeRead: true,
              canBeEdited: true,
              canBeDeleted: false,
              canBeCreatedOnIt: true
            ), 
            children: [
              TreeNode(
                key: 8,
                value: const PdfFile(
                  id: 8, 
                  name: 'viaje viejo 1', 
                  parentId: 0, 
                  url: 'http://www.africau.edu/images/default/sample.pdf',
                  canBeRead: true,
                  canBeEdited: true,
                  canBeDeleted: false
                ), 
                children: [

                ]
              )
            ]
          ),
          TreeNode(
            key: 9, 
            value: const PdfFile(
              id: 9, 
              name: 'viaje 1', 
              parentId: 0, 
              url: 'http://www.africau.edu/images/default/sample.pdf',
              canBeRead: true,
              canBeEdited: true,
              canBeDeleted: false
            ), 
            children: [

            ]
          ),
          TreeNode(
            key: 10, 
            value: const PdfFile(
              id: 10, 
              name: 'viaje 1', 
              parentId: 0, 
              url: 'http://www.africau.edu/images/default/sample.pdf',
              canBeRead: true,
              canBeEdited: true,
              canBeDeleted: false
            ), 
            children: [

            ]
          )
        ]
      ),
      TreeNode(
        key: 11, 
        value: const Folder(
          id: 11, 
          name: 'reuniones', 
          parentId: 0, 
          children: [],
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false,
          canBeCreatedOnIt: true
        ), 
        children: [

        ]
      ),
      TreeNode(
        key: 12, 
        value: const Folder(
          id: 12, 
          name: 'salidas', 
          parentId: 0, 
          children: [],
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false,
          canBeCreatedOnIt: true
        ), 
        children: [

        ]
      )
    ]
  )
);