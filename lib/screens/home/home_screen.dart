import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as i;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travo_app/gen/colors.gen.dart';
import 'package:travo_app/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ImagePicker _picker;
  late final RecorderController recorderController;
  Uint8List? imageData = null;
  i.Image? result = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _picker = ImagePicker();
    _initialiseControllers();
  }

  void _initialiseControllers() {
    recorderController = RecorderController();
    // ..androidEncoder = AndroidEncoder.aac
    // ..androidOutputFormat = AndroidOutputFormat.mpeg4
    // ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
    // ..sampleRate = 44100;
  }

  @override
  void dispose() {
    // TODO: implement dispose

    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: double.maxFinite),
            CircleProgress(),
            SizedBox(height: 20),
            RecordBar(),
            SizedBox(height: 20),
            Clickable(
              child: Text('open camera'),
              padding: EdgeInsets.all(10),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => CameraScreen()));
              },
            ),
            SizedBox(height: 20),
            Clickable(
              child: Text('take picture'),
              padding: EdgeInsets.all(10),
              onPressed: () async {
                final file = await _picker.pickImage(source: ImageSource.camera);

                if (file != null) {
                  final imageBytes = await file!.readAsBytes();
                  final imageFile = i.decodeImage(imageBytes);
                  final timeStamp = DateTime.now().toString();

                  final result = i.drawString(
                    imageFile!,
                    timeStamp,
                    x: 10,
                    y: 10,
                    font: i.arial48..outline = true,
                  );
                  imageData = i.encodePng(result);
                }
                final newImageData = setState(() {
                  imageData;
                });
                debugPrint(file!.name);
              },
            ),
            SizedBox(height: 20),
            Clickable(
              child: Text('record'),
              padding: EdgeInsets.all(10),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => Home()));
              },
            ),
            if (imageData != null)
              AspectRatio(
                aspectRatio: 1,
                child: Image.memory(imageData!),
              )
          ],
        ),
      ),
    );
  }
}
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     late CameraController controller;
//     return Scaffold(
//       // backgroundColor: Colors.blue.shade50,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(width: double.maxFinite),
//             CircleProgress(),
//             SizedBox(height: 20),
//             RecordBar(),
//             SizedBox(height: 20),
//             Clickable(
//               child: Text('open camera'),
//               padding: EdgeInsets.all(10),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class RecordBar extends StatelessWidget {
  const RecordBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final MediaStream mediaStream = MediaStream();
    // final MediaRecorder recorder = MediaRecorder(mediaStream);
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: ShapeDecoration(
        color: Colors.red.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Row(
        children: [
          Clickable(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
            padding: EdgeInsets.all(3),
            onPressed: () {},
            child: WhiteIcon(iconData: Icons.pause_rounded),
          ),
          Expanded(child: Container()),
          Clickable(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
            padding: EdgeInsets.all(3),
            onPressed: () {},
            child: WhiteIcon(iconData: Icons.done_rounded),
          ),
        ],
      ),
    );
  }
}

class CircleProgress extends StatelessWidget {
  const CircleProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          height: 100,
          width: 100,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                offset: const Offset(0, 3),
                color: Colors.grey.shade400,
              )
            ],
          ),
          child: const CircularProgressIndicator(
            backgroundColor: Colors.yellow,
            color: Colors.lightBlue,
            value: 30 / 40,
            strokeWidth: 40,
          ),
        ),
        Text('40')
      ],
    );
  }
}

class HOME extends StatefulWidget {
  const HOME({Key? key}) : super(key: key);

  @override
  State<HOME> createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Clickable extends CupertinoButton {
  const Clickable({
    super.key,
    required super.child,
    required super.onPressed,
    super.pressedOpacity,
    super.borderRadius,
    super.disabledColor,
    super.alignment,
    super.color,
    super.minSize = 10,
    super.padding = EdgeInsets.zero,
  });
}

class WhiteIcon extends StatelessWidget {
  const WhiteIcon({
    Key? key,
    required this.iconData,
    this.size,
  }) : super(key: key);
  final iconData;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: Colors.white,
      size: size,
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  @override
  void initState() {
    super.initState();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((error) {
      if (error is CameraException) {
        switch (error.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !controller.value.isInitialized
          ? SizedBox.shrink()
          : AspectRatio(
              aspectRatio: 16 / 9,
              child: CameraPreview(controller),
            ),
    );
  }
}

//
// import 'dart:io';
//
// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:audio_waveforms_example/chat_bubble.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Audio Waveforms',
//       debugShowCheckedModeBanner: false,
//       home: Home(),
//     );
//   }
// }

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final RecorderController recorderController;

  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;

  @override
  void initState() {
    super.initState();
    _getDir();
    _initialiseControllers();
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.m4a";
    isLoading = false;
    setState(() {});
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      musicFile = result.files.single.path;
      setState(() {});
    } else {
      debugPrint("File not picked");
    }
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252331),
      appBar: AppBar(
        backgroundColor: const Color(0xFF252331),
        elevation: 1,
        centerTitle: true,
        shadowColor: Colors.grey,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              scale: 1.5,
            ),
            const SizedBox(width: 10),
            const Text('Simform'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (_, index) {
                        return WaveBubble(
                          index: index + 1,
                          isSender: index.isOdd,
                          width: MediaQuery.of(context).size.width / 2,
                          appDirectory: appDirectory,
                        );
                      },
                    ),
                  ),
                  if (isRecordingCompleted)
                    WaveBubble(
                      path: path,
                      isSender: true,
                      appDirectory: appDirectory,
                    ),
                  if (musicFile != null)
                    WaveBubble(
                      path: musicFile,
                      isSender: true,
                      appDirectory: appDirectory,
                    ),
                  SafeArea(
                    child: Row(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: isRecording
                              ? AudioWaveforms(
                                  enableGesture: true,
                                  size: Size(MediaQuery.of(context).size.width / 2, 50),
                                  recorderController: recorderController,
                                  waveStyle: const WaveStyle(
                                    waveColor: Colors.white,
                                    extendWaveform: true,
                                    showMiddleLine: false,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: const Color(0xFF1E1B26),
                                  ),
                                  padding: const EdgeInsets.only(left: 18),
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width / 1.7,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E1B26),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  padding: const EdgeInsets.only(left: 18),
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  child: TextField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      hintText: "Type Something...",
                                      hintStyle: const TextStyle(color: Colors.white54),
                                      contentPadding: const EdgeInsets.only(top: 16),
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        onPressed: _pickFile,
                                        icon: Icon(Icons.adaptive.share),
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        IconButton(
                          onPressed: _refreshWave,
                          icon: Icon(
                            isRecording ? Icons.refresh : Icons.send,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _startOrStopRecording,
                          icon: Icon(isRecording ? Icons.stop : Icons.mic),
                          color: Colors.white,
                          iconSize: 28,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _startOrStopRecording() async {
    try {
      if (isRecording) {
        recorderController.reset();

        final path = await recorderController.stop(false);

        if (path != null) {
          isRecordingCompleted = true;
          debugPrint(path);
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
        }
      } else {
        await recorderController.record(path: path!);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void _refreshWave() {
    if (isRecording) recorderController.refresh();
  }
}

class WaveBubble extends StatefulWidget {
  final bool isSender;
  final int? index;
  final String? path;
  final double? width;
  final Directory appDirectory;

  const WaveBubble({
    Key? key,
    required this.appDirectory,
    this.width,
    this.index,
    this.isSender = false,
    this.path,
  }) : super(key: key);

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  File? file;

  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.white54,
    liveWaveColor: Colors.white,
    spacing: 6,
  );

  @override
  void initState() {
    super.initState();
    controller = PlayerController();
    _preparePlayer();
    playerStateSubscription = controller.onPlayerStateChanged.listen((_) {
      setState(() {});
    });
  }

  void _preparePlayer() async {
    // Opening file from assets folder
    if (widget.index != null) {
      file = File('${widget.appDirectory.path}/audio${widget.index}.mp3');
      await file?.writeAsBytes(
          (await rootBundle.load('assets/audios/audio${widget.index}.mp3')).buffer.asUint8List());
    }
    if (widget.index == null && widget.path == null && file?.path == null) {
      return;
    }
    // Prepare player with extracting waveform if index is even.
    controller.preparePlayer(
      path: widget.path ?? file!.path,
      shouldExtractWaveform: widget.index?.isEven ?? true,
    );
    // Extracting waveform separately if index is odd.
    if (widget.index?.isOdd ?? false) {
      controller
          .extractWaveformData(
            path: widget.path ?? file!.path,
            noOfSamples: playerWaveStyle.getSamplesForWidth(widget.width ?? 200),
          )
          .then((waveformData) => debugPrint(waveformData.toString()));
    }
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.path != null || file?.path != null
        ? Align(
            alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(
                bottom: 6,
                right: widget.isSender ? 0 : 10,
                top: 6,
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: widget.isSender ? const Color(0xFF276bfd) : const Color(0xFF343145),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!controller.playerState.isStopped)
                    IconButton(
                      onPressed: () async {
                        controller.playerState.isPlaying
                            ? await controller.pausePlayer()
                            : await controller.startPlayer(
                                finishMode: FinishMode.loop,
                              );
                      },
                      icon: Icon(
                        controller.playerState.isPlaying ? Icons.stop : Icons.play_arrow,
                      ),
                      color: Colors.white,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                  AudioFileWaveforms(
                    size: Size(MediaQuery.of(context).size.width / 2, 70),
                    playerController: controller,
                    waveformType:
                        widget.index?.isOdd ?? false ? WaveformType.fitWidth : WaveformType.long,
                    playerWaveStyle: playerWaveStyle,
                  ),
                  if (widget.isSender) const SizedBox(width: 10),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
