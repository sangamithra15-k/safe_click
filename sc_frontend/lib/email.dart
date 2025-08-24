import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safe_click/api_keys.dart';
import 'package:safe_click/constant.dart';

// ---------------- AI phishing detection function ----------------
Future<Map<String, dynamic>> detectPhishing(String inputText) async {
  final apiKey = openai_key;
  final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

  final prompt = '''
You are an AI assistant that detects phishing attempts in either:
1. The body of an email, or
2. A given URL.

Instructions:
- Always respond in strict JSON format:
  { "isphishing": true/false, "text": "explain why" }

Rules:
- If the input shows phishing indicators (e.g., suspicious links, urgent language, requests for credentials, mismatched domains, obfuscated text, unsafe URLs), set "isphishing" to true and explain clearly why.
- If the input looks safe, set "isphishing" to false and explain why it does not appear malicious.
- Do not output anything outside the JSON object.

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

// ---------------- UI Page ----------------
class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final _controller = TextEditingController();
  bool _loading = false;
  bool? _isPhishing;
  String? _apiResponse;

  Future<void> _checkEmail() async {
    final email = _controller.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _loading = true;
      _isPhishing = null;
      _apiResponse = null;
    });

    try {
      final result = await detectPhishing(email);
      setState(() {
        _isPhishing = result['isphishing'];
        _apiResponse = result['text'];
      });
    } catch (e) {
      setState(() {
        _isPhishing = true;
        _apiResponse = 'Error checking email: $e';
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

    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ Avoids keyboard overflow
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [c2, c1],
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //   ),
          // ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg1.jpg'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // Frosted Glass Container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: size.width * 0.85,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(
                          //   color: Colors.white.withOpacity(0.3),
                          //   width: 1.5,
                          // ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Email Authenticator',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: buttoncolor,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                hintText: 'Paste the email or URL here',
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
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: size.width * 0.5,
                              height: 48,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [c1, c2],
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
                                  onPressed: _loading ? null : _checkEmail,
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
                            const SizedBox(height: 32),
                            if (_loading) ...[
                              const SizedBox(
                                height: 80,
                                width: 80,
                                child: CircularProgressIndicator(
                                  strokeWidth: 8,
                                  valueColor:
                                      AlwaysStoppedAnimation(buttoncolor),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Checking…',
                                style: TextStyle(color: buttoncolor),
                              ),
                            ] else if (_isPhishing != null) ...[
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
                                    ? 'Warning: This may be a phishing attempt!'
                                    : 'Good news: Looks safe.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _isPhishing!
                                      ? Colors.redAccent
                                      : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Scrollable AI response
                              if (_apiResponse != null)
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        size.height * 0.3, // ✅ Limits height
                                  ),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _apiResponse!,
                                        style: const TextStyle(
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
