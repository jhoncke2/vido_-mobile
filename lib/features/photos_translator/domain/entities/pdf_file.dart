import 'package:equatable/equatable.dart';
import 'package:vido/features/photos_translator/domain/entities/app_file.dart';

class PdfFile extends AppFile{
  final String url;
  const PdfFile({
    required int id, 
    required String name, 
    required this.url
  }):super(
    id: id,
    name: name
  );
  @override
  List<Object?> get props => [...super.props, url];
}