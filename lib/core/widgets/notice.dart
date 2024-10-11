import 'package:vg_coffee/core/common_libs.dart';

class Notice extends StatelessWidget {
  const Notice({
    required this.icon,
    required this.text,
    required this.subtext,
    this.buttonText,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final String text;
  final String subtext;
  final String? buttonText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 400,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              subtext,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (buttonText == null)
              const SizedBox.shrink()
            else
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.deepPurple,
                  ),
                ),
                onPressed: onPressed,
                child: Text(
                  buttonText!,
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
