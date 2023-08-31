import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:mime/mime.dart';

class FileDisplay extends StatefulWidget {
  final List<String> files;

  const FileDisplay({
    required this.files,
    super.key,
  });

  @override
  State<FileDisplay> createState() => _FileDisplayState();
}

class _FileDisplayState extends State<FileDisplay> {
  late List<String> files;

  @override
  void initState() {
    super.initState();
    files = widget.files;
  }

  String getFileType(String file) {
    final String? mimeType = lookupMimeType(file);
    if (mimeType == null) {
      return 'document';
    }
    if (mimeType.startsWith('image')) {
      return 'image';
    }
    if (mimeType.startsWith('video')) {
      return 'video';
    } else {
      return 'document';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCarousel(
      items: files
          .map(
            (String file) => Builder(
              builder: (BuildContext context) {
                final String fileType = getFileType(file);
                if (fileType == 'image') {
                  return Image.network(file);
                } else {
                  return TextButton(
                    onPressed: () {
                      FileDownloader.downloadFile(
                        url: file,
                      );
                    },
                    child: Text('Download file'),
                  );
                }
              },
            ),
          )
          .toList(),
      options: CarouselOptions(),
    );
  }
}
