// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:vido/features/files_navigator/external/fake/tree.dart';
import 'package:vido/features/files_navigator/external/fake/tree_node.dart';
import '../../../../core/domain/entities/app_file.dart';
import '../../../../core/domain/entities/folder.dart';
import '../../../../core/domain/entities/pdf_file.dart';

final appFiles = Tree<int, AppFile>(
  root: TreeNode(
    key: 0, 
    value: Folder(
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
        key: 10,
        value: Folder(
          id: 10,
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
            key: 100,
            value: const PdfFile(
              id: 100, 
              name: 'Factura 1', 
              parentId: 10, 
              url: 'http://www.africau.edu/images/default/sample.pdf',
              canBeRead: true,
              canBeEdited: true,
              canBeDeleted: false
            ), 
            children: [

            ]
          ),
          TreeNode(
            key: 101,
            value: const PdfFile(
              id: 101, 
              name: 'Factura 2', 
              parentId: 10, 
              url: 'http://www.africau.edu/images/default/sample.pdf',
              canBeRead: true,
              canBeEdited: true,
              canBeDeleted: false
            ), 
            children: [

            ]
          ),
          TreeNode(
            key: 102, 
            value: const PdfFile(
              id: 102, 
              name: 'Factura 3', 
              parentId: 10, 
              url: 'http://www.africau.edu/images/default/sample.pdf',
              canBeRead: true,
              canBeEdited: true,
              canBeDeleted: false
            ), 
            children: [

            ]
          ),
          TreeNode(
            key: 103, 
            value: const PdfFile(
              id: 103, 
              name: 'Factura 4', 
              parentId: 10, 
              url: 'http://www.africau.edu/images/default/sample.pdf',
              canBeRead: false,
              canBeEdited: true,
              canBeDeleted: false
            ), 
            children: [

            ]
          ),
          TreeNode(
            key: 104,
            value: Folder(
              id: 104,
              name: 'facturas específicas', 
              parentId: 0,
              children: [],
              canBeRead: false,
              canBeEdited: true,
              canBeDeleted: false,
              canBeCreatedOnIt: true
            ),
            children: []
          )
        ]
      ),
      TreeNode(
        key: 11, 
        value: const PdfFile(
          id: 11, 
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
        key: 12, 
        value: Folder(
          id: 12, 
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
            key: 120, 
            value: Folder(
              id: 120, 
              name: 'viajes antiguos', 
              parentId: 12, 
              children: [],
              canBeRead: true,
              canBeEdited: true,
              canBeDeleted: false,
              canBeCreatedOnIt: true
            ), 
            children: [
              TreeNode(
                key: 1200,
                value: const PdfFile(
                  id: 1200, 
                  name: 'viaje viejo 1', 
                  parentId: 120, 
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
            key: 1201, 
            value: const PdfFile(
              id: 1201, 
              name: 'viaje 1', 
              parentId: 120, 
              url: 'http://www.africau.edu/images/default/sample.pdf',
              canBeRead: true,
              canBeEdited: true,
              canBeDeleted: false
            ), 
            children: [

            ]
          ),
          TreeNode(
            key: 1202, 
            value: const PdfFile(
              id: 1202, 
              name: 'viaje 2', 
              parentId: 120, 
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
        key: 13, 
        value: Folder(
          id: 13, 
          name: 'reuniones', 
          parentId: 0, 
          children: [],
          canBeRead: true,
          canBeEdited: true,
          canBeDeleted: false,
          canBeCreatedOnIt: false
        ), 
        children: [

        ]
      ),
      TreeNode(
        key: 14, 
        value: Folder(
          id: 14, 
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