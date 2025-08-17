import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safe_click/api_keys.dart';
import 'package:safe_click/constant.dart';

class VerifyUrlPage extends StatefulWidget {
  const VerifyUrlPage({super.key});

  @override
  State<VerifyUrlPage> createState() => _VerifyUrlPageState();
}

class _VerifyUrlPageState extends State<VerifyUrlPage> {
  final _controller = TextEditingController();
  bool _loading = false;
  bool? _isPhishing;
  String? _apiResponse;

  // Updated _checkUrl to call detectPhishing
  Future<void> _checkUrl() async {
    final url = _controller.text.trim();
    if (url.isEmpty) return;

    setState(() {
      _loading = true;
      _isPhishing = null;
      _apiResponse = null;
    });

    try {
      final result = await detectPhishing(url);
      // Expecting result to be { "isphishing": bool, "text": String }
      setState(() {
        _isPhishing = (result['isphishing'] == true);
        _apiResponse = result['text']?.toString() ?? 'No explanation provided.';
      });
    } catch (e) {
      setState(() {
        _isPhishing = true;
        _apiResponse = 'Error checking URL: $e';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), // dismiss keyboard on tap outside
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/shield.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          child: SingleChildScrollView(
            // ensure page scrolls when keyboard opens or content grows
            padding: EdgeInsets.fromLTRB(12, 12, 12, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // TOP FROSTED HEADER
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 16),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/top_cover.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Safe Click',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // optional settings icon
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.settings,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.search, color: Colors.white),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Search...',
                                      hintStyle:
                                          TextStyle(color: Colors.white70),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Icon(Icons.mic, color: Colors.white),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // FROSTED VERIFICATION CARD
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: size.width * 0.85,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      // note: no inner SingleChildScrollView that expands indefinitely
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 6),
                          const Text(
                            'Quick URL check',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: buttoncolor,
                            ),
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: 'paste the url here',
                              hintStyle: TextStyle(color: buttoncolor),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: buttoncolor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: buttoncolor, width: 2),
                              ),
                            ),
                            style: const TextStyle(color: buttoncolor),
                            keyboardType: TextInputType.url,
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: size.width * 0.5,
                            height: 48,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00E5FF), // Neon Cyan
                                    Color(0xFF007BFF),
                                    Color.fromARGB(
                                        255, 188, 236, 239) // Electric Blue
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.6),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _loading ? null : _checkUrl,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .transparent, // Transparent so gradient shows
                                  shadowColor: Colors
                                      .transparent, // Remove default shadow
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: const Text(
                                  'VERIFY URL',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Loading state
                          if (_loading) ...[
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: CircularProgressIndicator(
                                strokeWidth: 8,
                                valueColor: AlwaysStoppedAnimation(buttoncolor),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text('Loading…',
                                style: TextStyle(color: buttoncolor)),
                          ],

                          // Result / Response area (constrained so it won't overflow)
                          if (!_loading && _isPhishing != null) ...[
                            const SizedBox(height: 8),
                            Icon(
                              _isPhishing! ? Icons.close : Icons.check,
                              size: 64,
                              color: _isPhishing!
                                  ? Colors.redAccent
                                  : Colors.greenAccent,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isPhishing!
                                  ? 'Warning: This link may be a phishing attempt!'
                                  : 'Good news: This link is most likely safe.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _isPhishing!
                                    ? Colors.redAccent
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Constrain the height of the response and make it scrollable inside
                            // if (_apiResponse != null)
                            //   ConstrainedBox(
                            //     constraints: BoxConstraints(
                            //       // limit height to a portion of available screen
                            //       maxHeight: size.height * 0.3,
                            //       minHeight: 0,
                            //     ),
                            //     child: SingleChildScrollView(
                            //       child: Container(
                            //         width: double.infinity,
                            //         padding: const EdgeInsets.all(12),
                            //         decoration: BoxDecoration(
                            //           color: Colors.white70,
                            //           borderRadius: BorderRadius.circular(12),
                            //         ),
                            //         child: Text(
                            //           _apiResponse!,
                            //           style: const TextStyle(
                            //               color: Colors.black87),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- AI phishing detection function ----------------
Future<Map<String, dynamic>> detectPhishing(String inputText) async {
  final apiKey = openai_key;
  final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

  final prompt = '''
You are an AI assistant that detects phishing attempts in emails or the given URL is a phishing site or not safe. 
For the input below:
- Respond in strict JSON: { "isphishing": true/false, "text": "explain why" }
- If phishing indicators are present, set isphishing to true and explain your reasoning.
- If safe, set isphishing to false and explain why.
Input: "$inputText"
''';

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  final body = json.encode({
    'model': 'openai/gpt-oss-20b:free',
    'messages': [
      {'role': 'user', 'content': prompt},
    ],
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final content = data['choices'][0]['message']['content'] as String;
      final Map<String, dynamic> result = json.decode(content);
      return result;
    } else {
      throw Exception('Failed to get response: ${response.statusCode}');
    }
  } catch (e) {
    return {'isphishing': false, 'text': 'Error occurred: $e'};
  }
}
