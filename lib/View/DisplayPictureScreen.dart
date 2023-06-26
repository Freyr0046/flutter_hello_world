import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 30,
            bottom: 0,
            child: FloatingActionButton(
              onPressed: () async {
                //上傳雲端
                final metadata = SettableMetadata(contentType: "image/jpeg");
                Reference storageRef = FirebaseStorage.instance.ref();

                final uploadTask = storageRef
                    .child("images/${DateTime.now()}-${basename(imagePath)}")//上傳至雲端的路徑及檔名
                    .putFile(File(imagePath), metadata);//選擇欲上傳文件、格式(可不指定格式)
                uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
                  switch (taskSnapshot.state) {//判斷上傳狀態
                    case TaskState.running://上傳中
                      final progress =
                          100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
                      // print("Upload is $progress% complete.");
                      break;
                    case TaskState.paused://停止上傳
                    // print("Upload is paused.");
                      break;
                    case TaskState.canceled://取消上傳
                    // print("Upload was canceled");
                      break;
                    case TaskState.error://上傳失敗
                      Fluttertoast.showToast(
                        msg: "上傳失敗",
                      );
                      break;
                    case TaskState.success://上傳成功
                      Fluttertoast.showToast(
                        msg: "上傳成功",
                      );
                      print("Upload success");
                      break;
                  }
                });
              },
              child: const Icon(Icons.cloud_upload_outlined),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              onPressed: () async {
                //儲存相片至相簿
                GallerySaver.saveImage(imagePath).then((value) {
                  if (value == true) {
                    Fluttertoast.showToast(
                      msg: "照片已儲存至相簿",
                    );
                  }else{
                    Fluttertoast.showToast(
                      msg: "儲存失敗",
                    );
                  }
                });
              },
              child: const Icon(Icons.download),
            ),
          ),
        ],
      ),
    );
  }
}