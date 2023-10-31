import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class TestFirebase extends StatefulWidget {
  const TestFirebase({super.key});

  @override
  State<TestFirebase> createState() => _TestFirebaseState();
}

class _TestFirebaseState extends State<TestFirebase> {
  // Future<void> processFiles() async {
  //   // Initialize Firebase
  //   await firebase_storage.FirebaseStorage.instance.ref().child('OPENATTACHMENT').listAll().then((result) {
  //     result.items.forEach((item) async {
  //       final metadata = await item.getMetadata();
  //       final uploadDate = DateTime.parse(metadata.customMetadata!['uploadDate']!);
  //       final now = DateTime.now();
  //
  //       if (uploadDate.year < 2020) {
  //         // Delete the file if it's older than 2020
  //         await item.delete();
  //       } else {
  //         // Move the file to a folder based on the year
  //         final newRef = firebase_storage.FirebaseStorage.instance.ref().child('year_${uploadDate.year}').child(item.name);
  //         await item.writeTo(newRef);
  //       }
  //     });
  //   });
  // }

  List<FileItem> fileItems = [];
  int batchSize = 10000;
  int currentIndex = 0;

  Future<void> loadMoreFiles() async {
    final storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child('');
    final listResult = await storageRef.list(ListOptions(
        maxResults: batchSize,
        pageToken: currentIndex == 0 ? null : fileItems.last.name));
    firebase_storage.Reference _upload =
        FirebaseStorage.instance.ref().child('-0BIZAPP');
    firebase_storage.Reference _upload2020 =
        FirebaseStorage.instance.ref().child('-0BIZAPP2020');
    firebase_storage.Reference _upload2021 =
        FirebaseStorage.instance.ref().child('-0BIZAPP2021');
    // firebase_storage.Reference _upload2022 = FirebaseStorage.instance.ref().child('-0BIZAPP2022');
    // firebase_storage.Reference _upload2023 = FirebaseStorage.instance.ref().child('-0BIZAPP2023');

    for (var item in listResult.items) {
      final data = await item.getData(); // Get the data to calculate size
      final sizeKB = data!.length / 1024;

      item.getMetadata().then((metadata) {
        /// Check metadata for upload date
        DateTime? uploadDate = metadata.updated;
        String? type = metadata.contentType;

        print(
            'Processing item at index: ${listResult.items.indexOf(item)}'); // Print current index

        item.getDownloadURL().then((url) => {
              if (type!.contains('pdf'))
                {
                  print('pdf type: ${metadata.fullPath} $type -- $uploadDate'),

                  /// data tahun 2020
                  if (uploadDate!.isBefore(DateTime(2020)))
                    {
                      setState(() {
                        _upload
                            .child(item.fullPath)
                            .putData(
                                data,
                                SettableMetadata(
                                    contentType: 'application/pdf'))
                            .storage;

                        /// delete current pathfile
                        item.delete();
                      })
                    },

                  /// data tahun 2020
                  if (uploadDate.isAfter(DateTime(2020)) &&
                      uploadDate.isBefore(DateTime(2021)))
                    {
                      setState(() {
                        _upload2020
                            .child(item.fullPath)
                            .putData(
                                data,
                                SettableMetadata(
                                    contentType: 'application/pdf'))
                            .storage;

                        /// delete current pathfile
                        item.delete();
                      })
                    },

                  /// data tahun 2021
                  if (uploadDate.isAfter(DateTime(2021)) &&
                      uploadDate.isBefore(DateTime(2022)))
                    {
                      setState(() {
                        _upload2021
                            .child(item.fullPath)
                            .putData(
                                data,
                                SettableMetadata(
                                    contentType: 'application/pdf'))
                            .storage;

                        /// delete current pathfile
                        item.delete();
                      })
                    },
                }
              else if (type.contains('html'))
                {
                  print('html type: ${metadata.fullPath} $type. deleted'),

                  /// delete current pathfile
                  item.delete()
                }
              else
                {
                  /// Increment index for non-PDF files
                  currentIndex = currentIndex + 1,
                  print(
                      'img type: ${metadata.fullPath} $type. xperlu move folder $currentIndex'),
                },

              ///
              // /// data tahun 2022
              // if(uploadDate.isAfter(DateTime(2022)) && uploadDate.isBefore(DateTime(2023))){
              //   setState(() {
              //     _upload2022.child(item.fullPath).putData(data, SettableMetadata()).storage;
              //     /// delete current pathfile
              //     item.delete();
              //   })
              // },

              // /// data tahun 2023
              // if(uploadDate.isAfter(DateTime(2023))){
              //   setState(() {
              //     _upload2023.child(item.fullPath).putData(data, SettableMetadata()).storage;
              //     /// delete current pathfile
              //     item.delete();
              //   })
              // },
            });
      });
    }

    currentIndex = currentIndex + batchSize;
    print('$batchSize : $currentIndex');
  }

  List deleteFile = [];
  xxaa(DateTime x, String path) {
    // DateTime currentDate = DateTime.now();
    DateTime targetDate = DateTime(2020, 7);

    x = DateTime(x.year, x.month, x.day); // Set time to midnight

    if (x.isBefore(targetDate)) {
      print('Current date is before 7 2020.');
      _deleteFile(path);
    } else if (x.isAfter(targetDate)) {
      print('Current date is after 1 2020.');
    } else {
      print('Current date is 1 2020.');
    }
  }

  Future<void> _deleteFile(String filePath) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference fileRef = storage.ref().child(filePath);

    try {
      await fileRef.delete();
      print('File deleted successfully.');
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  //   fileItems.add(FileItem(
  //       item.fullPath,
  //       sizeKB.toInt(),
  //       uploadDate,
  //       item.fullPath
  // ));

  // letak filename
  ///

  // Future<void> moveFile(String sourcePath, String destinationPath) async {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //
  //   Reference sourceRef = storage.ref().child(sourcePath);
  //   Reference destinationRef = storage.ref().child(destinationPath);
  //   firebase_storage.Reference reference = FirebaseStorage.instance.ref().child('OPENATTACHMENT_III').child('/$filename');
  //   firebase_storage.UploadTask uploadTask = reference.putData(filebytes, SettableMetadata(contentType: "application/pdf"));
  //
  //   try {
  //     // Download file from source
  //     final DownloadTaskSnapshot downloadTask = await sourceRef.writeToFile(localFile);
  //
  //     // Upload file to new destination
  //     await destinationRef.putFile(downloadTask.file);
  //
  //     // Delete the file from the source
  //     // await sourceRef.delete();
  //
  //     print('File moved successfully.');
  //   } catch (e) {
  //     print('Error moving file: $e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    loadMoreFiles().then((value) {
      debugPrint('completed');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File List'),
      ),
      body: const SizedBox(),
      // body: ListView.builder(
      //   shrinkWrap: true,
      //   itemCount: fileItems.length,
      //   itemBuilder: (context, index) {
      //     final file = fileItems[index];
      //     return ListTile(
      //       onTap: ()=> xxaa(file.date, file.path),
      //       title: Text(file.name),
      //       subtitle: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text('Size: ${file.size.toStringAsFixed(2)} kb'),
      //           Text('date: ${file.date} '),
      //         ],
      //       ),
      //     );
      //   },
      // ),
      floatingActionButton: const FloatingActionButton(
        // onPressed: loadMoreFiles,
        onPressed: null,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FileItem {
  final String name;
  final String path;
  final DateTime date;
  final int size;

  FileItem(this.name, this.size, this.date, this.path);
}
