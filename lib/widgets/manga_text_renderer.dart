import 'package:flutter/material.dart';
import '../theme/manga_theme.dart';

/// 🎨 MANGA-STYLED TEXT RENDERER
/// Renders markdown-style text with cartoonish/manga fonts
class MangaTextRenderer extends StatelessWidget {
  final String text;

  const MangaTextRenderer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _parseAndRender(text),
    );
  }

  List<Widget> _parseAndRender(String text) {
    final List<Widget> widgets = [];
    final lines = text.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      
      // Skip empty lines unless between content
      if (line.trim().isEmpty) {
        if (widgets.isNotEmpty) {
          widgets.add(const SizedBox(height: 8));
        }
        continue;
      }

      // Emoji headers (## with emoji)
      if (line.startsWith('## ') && _containsEmoji(line)) {
        widgets.add(_buildEmojiHeader(line.substring(3)));
        widgets.add(const SizedBox(height: 16));
        continue;
      }

      // H2 headers (##)
      if (line.startsWith('## ')) {
        widgets.add(_buildH2Header(line.substring(3)));
        widgets.add(const SizedBox(height: 16));
        continue;
      }

      // Horizontal rules (---)
      if (line.trim().startsWith('---')) {
        widgets.add(const SizedBox(height: 12));
        widgets.add(_buildDivider());
        widgets.add(const SizedBox(height: 12));
        continue;
      }

      // Numbered headers (1️⃣, 2️⃣, etc)
      if (_isNumberedHeader(line)) {
        widgets.add(_buildNumberedHeader(line));
        widgets.add(const SizedBox(height: 12));
        continue;
      }

      // Bold headers (**text**)
      if (line.trim().startsWith('**') && line.trim().endsWith('**')) {
        widgets.add(_buildBoldHeader(line.trim()));
        widgets.add(const SizedBox(height: 10));
        continue;
      }

      // Code blocks (```)
      if (line.trim().startsWith('```')) {
        final codeLines = <String>[];
        i++; // Skip opening ```
        while (i < lines.length && !lines[i].trim().startsWith('```')) {
          codeLines.add(lines[i]);
          i++;
        }
        widgets.add(_buildCodeBlock(codeLines.join('\n')));
        widgets.add(const SizedBox(height: 16));
        continue;
      }

      // Tables (╔═══, ║, etc)
      if (line.contains('╔') || line.contains('║') || line.contains('╠')) {
        final tableLines = <String>[line];
        i++;
        while (i < lines.length && (lines[i].contains('║') || lines[i].contains('╚') || lines[i].contains('╠'))) {
          tableLines.add(lines[i]);
          i++;
        }
        i--; // Back up one line
        widgets.add(_buildTable(tableLines.join('\n')));
        widgets.add(const SizedBox(height: 16));
        continue;
      }

      // Bullet points (- or •)
      if (line.trim().startsWith('- ') || line.trim().startsWith('• ')) {
        widgets.add(_buildBulletPoint(line.trim().substring(2)));
        widgets.add(const SizedBox(height: 6));
        continue;
      }

      // Checkmarks and crosses (✅, ❌)
      if (line.trim().startsWith('✅') || line.trim().startsWith('❌')) {
        widgets.add(_buildCheckItem(line.trim()));
        widgets.add(const SizedBox(height: 6));
        continue;
      }

      // Regular paragraph with inline formatting
      widgets.add(_buildRichText(line));
      widgets.add(const SizedBox(height: 8));
    }

    return widgets;
  }

  bool _containsEmoji(String text) {
    final emojiRegex = RegExp(r'[\u{1F300}-\u{1F9FF}]', unicode: true);
    return emojiRegex.hasMatch(text);
  }

  bool _isNumberedHeader(String line) {
    return line.contains('1️⃣') || line.contains('2️⃣') || line.contains('3️⃣') || 
           line.contains('4️⃣') || line.contains('5️⃣') || line.contains('6️⃣');
  }

  Widget _buildEmojiHeader(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MangaTheme.highlightYellow.withOpacity(0.3),
        border: Border.all(color: MangaTheme.inkBlack, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: MangaTheme.inkBlack,
          letterSpacing: 2.0,
          fontFamily: 'Impact',
          shadows: [
            Shadow(
              color: MangaTheme.highlightYellow,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildH2Header(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: MangaTheme.mangaRed,
        letterSpacing: 1.5,
        fontFamily: 'Impact',
      ),
    );
  }

  Widget _buildNumberedHeader(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: MangaTheme.speedlineBlue.withOpacity(0.2),
        border: const Border(
          left: BorderSide(color: MangaTheme.mangaRed, width: 4),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: MangaTheme.inkBlack,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildBoldHeader(String text) {
    final cleanText = text.replaceAll('**', '').replaceAll('*', '');
    return Text(
      cleanText,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w900,
        color: MangaTheme.inkBlack,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MangaTheme.mangaRed,
            MangaTheme.accentOrange,
            MangaTheme.highlightYellow,
          ],
        ),
        border: Border.all(color: MangaTheme.inkBlack, width: 1),
      ),
    );
  }

  Widget _buildCodeBlock(String code) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MangaTheme.panelGray,
        border: Border.all(color: MangaTheme.inkBlack, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontSize: 13,
          color: MangaTheme.inkBlack,
          height: 1.5,
          fontWeight: FontWeight.w600,
          fontFamily: 'Courier',
        ),
      ),
    );
  }

  Widget _buildTable(String table) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: MangaTheme.paperWhite,
        border: Border.all(color: MangaTheme.inkBlack, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        table,
        style: const TextStyle(
          fontSize: 12,
          color: MangaTheme.inkBlack,
          height: 1.4,
          fontWeight: FontWeight.w600,
          fontFamily: 'Courier',
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6, right: 8),
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: MangaTheme.mangaRed,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: MangaTheme.inkBlack,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildRichText(text),
        ),
      ],
    );
  }

  Widget _buildCheckItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text.substring(0, 2), // ✅ or ❌
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildRichText(text.substring(2).trim()),
        ),
      ],
    );
  }

  Widget _buildRichText(String text) {
    final spans = <InlineSpan>[];
    int currentIndex = 0;

    // Parse inline markdown
    final boldRegex = RegExp(r'\*\*([^\*]+)\*\*');
    final matches = boldRegex.allMatches(text).toList();

    if (matches.isEmpty) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          height: 1.6,
          color: MangaTheme.inkBlack,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    for (final match in matches) {
      // Add text before match
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, match.start),
          style: const TextStyle(
            fontSize: 15,
            height: 1.6,
            color: MangaTheme.inkBlack,
            fontWeight: FontWeight.w500,
          ),
        ));
      }

      // Add bold text with manga-style highlighting
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(
          fontSize: 15,
          height: 1.6,
          color: MangaTheme.inkBlack,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
          backgroundColor: MangaTheme.highlightYellow,
          shadows: [
            Shadow(
              color: MangaTheme.inkBlack,
              offset: Offset(0.5, 0.5),
              blurRadius: 0,
            ),
          ],
        ),
      ));

      currentIndex = match.end;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: const TextStyle(
          fontSize: 15,
          height: 1.6,
          color: MangaTheme.inkBlack,
          fontWeight: FontWeight.w500,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
