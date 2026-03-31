import 'package:sikshana/app/utils/exports.dart';
import 'package:dio/dio.dart' as d;

class AddMediaUrlBottomSheet extends StatefulWidget {
  final String sectionId;

  const AddMediaUrlBottomSheet({super.key, required this.sectionId});

  @override
  State<AddMediaUrlBottomSheet> createState() => _AddMediaUrlBottomSheetState();
}

class _AddMediaUrlBottomSheetState extends State<AddMediaUrlBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final LessonPlanGeneratedViewController _controllerLessonPlan =
      Get.find<LessonPlanGeneratedViewController>();

  String? _errorText;
  Timer? _debounce;
  bool _isLoading = false;

  /// NEW: Holds detected or user-selected media type
  String _selectedType = ''; // "image" or "video"

  /// Classifies the given URL as either 'image' or 'video' based on its extension
  /// or by checking the content type via a HEAD request.
  ///
  /// Returns 'image' if the URL contains common image extensions or if the
  /// content type returned by a HEAD request is an image. Otherwise, returns 'video'.
  Future<String> classifyUrlSimplified(String url) async {
    final String lowerUrl = url.toLowerCase();

    const List<String> imageExtensions = <String>[
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
      '.tiff',
    ];

    for (final String ext in imageExtensions) {
      if (lowerUrl.contains(ext)) {
        return 'image';
      }
    }

    final bool returnVal = await isImageUrlDio(lowerUrl);
    return returnVal ? 'image' : 'video';
  }

  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<bool> isImageUrlDio(String url) async {
    try {
      final d.Dio dio = d.Dio();
      final d.Response<dynamic> response = await dio.request(
        url,
        options: d.Options(method: 'HEAD'),
      );
      final String? contentType = response.headers.value('content-type');
      if (contentType != null && contentType.startsWith('image/')) {
        return true;
      }
    } catch (e) {
      debugPrint('Image validation failed: $e');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
              child: AddMediaUrlBottomSheetHeader(
                title: 'Add Image/Video URL',
                onClose: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(
              height: 1.2,
              thickness: 1.2,
              color: AppColors.kEBEBEB,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 16),

                  Text(
                    'Image/Video URL',
                    style: AppTextStyle.lato(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.k171A1F,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// -------------------------------
                  /// TEXT FIELD WITH AUTO-DETECT
                  /// -------------------------------
                  TextField(
                    controller: _controller,
                    onChanged: (String val) {
                      setState(() => _errorText = null);

                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(
                        const Duration(milliseconds: 500),
                        () async {
                          if (val.trim().isEmpty) {
                            _selectedType = '';
                            setState(() {
                              _isLoading = false;
                            });
                            return;
                          }
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            /// AUTO DETECT → SET DEFAULT RADIO VALUE
                            final String detected = await classifyUrlSimplified(
                              val.trim(),
                            );
                            _selectedType = detected; // "image" or "video"
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                      );
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF6F8FA),
                      hintText: 'Ex: https://www.youtube.com/watch?...',
                      hintStyle: AppTextStyle.lato(
                        color: AppColors.k9095A0,
                        fontSize: 12.sp,
                      ),
                      suffixIcon: IconButton(
                        icon: _isLoading
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.link, color: AppColors.k9095A0),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            final ClipboardData? data = await Clipboard.getData(
                              Clipboard.kTextPlain,
                            );
                            final String text = data?.text?.trim() ?? '';
                            if (text.isEmpty) {
                              setState(() => _errorText = 'Clipboard is empty');
                              return;
                            }
                            _controller.text = text;

                            /// AUTO-DETECT ON PASTE
                            final String detected = await classifyUrlSimplified(
                              text,
                            );
                            _selectedType = detected;

                            setState(() => _errorText = null);
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _errorText == null
                              ? AppColors.kEBEBEB
                              : Colors.red,
                          width: 1.4,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _errorText == null
                              ? AppColors.kEBEBEB
                              : Colors.red,
                          width: 1.4,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _errorText == null
                              ? AppColors.k46A0F1
                              : Colors.red,
                          width: 1.4,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 13,
                      ),
                      errorText: _errorText,
                    ),
                    style: AppTextStyle.lato(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  /// -------------------------------
                  /// RADIO OPTIONS (ONLY IMAGE/VIDEO)
                  /// -------------------------------
                  if (_controller.text.trim().isNotEmpty) ...<Widget>[
                    const SizedBox(height: 22),

                    Text(
                      'Select Media Type',
                      style: AppTextStyle.lato(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.k171A1F,
                      ),
                    ),
                    const SizedBox(height: 8),

                    RadioListTile<String>(
                      value: 'image',
                      groupValue: _selectedType,
                      onChanged: (String? v) =>
                          setState(() => _selectedType = v ?? 'image'),
                      title: Text(
                        'Image',
                        style: AppTextStyle.lato(fontSize: 12.sp),
                      ),
                    ),

                    RadioListTile<String>(
                      value: 'video',
                      groupValue: _selectedType,
                      onChanged: (String? v) =>
                          setState(() => _selectedType = v ?? 'video'),
                      title: Text(
                        'Video',
                        style: AppTextStyle.lato(fontSize: 12.sp),
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  ElevatedButton(
                    onPressed: () async {
                      final String url = _controller.text.trim();
                      if (url.isEmpty || !_isValidUrl(url)) {
                        setState(() => _errorText = 'Please enter a valid URL');
                        return;
                      }
                      if (_selectedType.isEmpty) {
                        setState(
                          () => _errorText = 'Unable to classify media type',
                        );
                        return;
                      }
                      await _controllerLessonPlan.addMedia(
                        sectionId: widget.sectionId,
                        title: '',
                        type: _selectedType, // AUTO + USER OVERRIDE
                        link: url,
                      );
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.k46A0F1,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      'Attach Link',
                      style: AppTextStyle.lato(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kFFFFFF,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: AppColors.kEBEBEB,
                          width: 1.4,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyle.lato(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class AddMediaUrlBottomSheetHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const AddMediaUrlBottomSheetHeader({
    super.key,
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Container(
        width: 100,
        height: 5,
        decoration: BoxDecoration(
          color: AppColors.kEBEBEB,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: AppTextStyle.lato(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.k000000,
            ),
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.kEBEBEB),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(6),
              child: const Icon(Icons.close),
            ),
            onTap: onClose,
          ),
        ],
      ),
    ],
  );
}
