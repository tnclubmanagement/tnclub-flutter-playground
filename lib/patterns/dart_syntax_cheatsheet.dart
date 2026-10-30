import 'package:flutter/material.dart';

import '../widgets/cheatsheet_scaffold.dart';
import '../widgets/code_panel.dart';

/// Trang tổng hợp (cheat sheet) các CÚ PHÁP Dart/Flutter hay gặp nhưng dễ
/// gây bối rối khi mới đọc code của người khác: null-aware operator, cascade
/// `..`, spread `...`, collection if/for, async/await, pattern matching,
/// constructor riêng tư `ClassName._(...)`...
///
/// Đây CHỈ là trang thông tin tĩnh (giống LibrariesPage/AtomicWidgetsCheatsheet):
/// code mẫu bên dưới minh hoạ cú pháp, không chạy thật trong app này.
class DartSyntaxCheatsheet extends StatelessWidget {
  const DartSyntaxCheatsheet({super.key});

  static const _items = [
    // ---- Null safety ----
    _SyntaxInfo(
      name: 'Null-aware operators: ?.  ??  ??=  !',
      category: 'Null safety',
      description:
          '`?.` gọi method/đọc field nếu object KHÁC null, trả null nếu '
          'object là null (không throw lỗi). `??` cho giá trị mặc định khi '
          'bên trái là null. `??=` chỉ gán khi biến đang null. `!` ("bang '
          'operator") ép Dart tin rằng giá trị KHÔNG null - nếu sai sẽ '
          'crash runtime, chỉ dùng khi chắc chắn 100%.',
      snippet: '''
String? name; // có thể null

print(name?.length);      // null nếu name null, không throw
final display = name ?? 'Ẩn danh'; // dùng 'Ẩn danh' nếu name null
name ??= 'Khách';          // chỉ gán nếu name đang null
print(name!.length);      // ép "chắc chắn không null" - cẩn thận!''',
    ),
    _SyntaxInfo(
      name: 'late',
      category: 'Null safety',
      description:
          'Khai báo field/biến non-nullable nhưng CHƯA gán giá trị ngay lúc '
          'khởi tạo - cam kết với Dart là "sẽ gán trước khi dùng". Hay gặp '
          'với các field chỉ tính được trong `initState()` (không phải lúc '
          'khai báo field).',
      snippet: '''
class _MyState extends State<MyWidget> {
  late AnimationController controller; // chưa có giá trị ngay

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this); // gán ở đây
  }
}''',
    ),
    // ---- Cú pháp rút gọn ----
    _SyntaxInfo(
      name: 'Cascade notation: ..',
      category: 'Cú pháp rút gọn',
      description:
          'Gọi NHIỀU method/set NHIỀU field liên tiếp trên CÙNG 1 object mà '
          'không cần lặp lại tên biến mỗi lần. Khác với `.` thường (trả về '
          'kết quả của method đó), `..` luôn trả về chính object ban đầu.',
      snippet: '''
// Không có cascade: lặp lại "controller" 3 lần
controller.text = 'abc';
controller.selection = TextSelection.collapsed(offset: 3);

// Có cascade: viết liên tiếp, đọc như 1 "chuỗi lệnh" trên cùng object
final controller = TextEditingController()
  ..text = 'abc'
  ..selection = const TextSelection.collapsed(offset: 3);''',
    ),
    _SyntaxInfo(
      name: 'Spread operator: ...  và  ...?',
      category: 'Cú pháp rút gọn',
      description:
          '"Trải" các phần tử của 1 List/Set/Map khác vào bên trong literal '
          'hiện tại, thay vì phải viết `.addAll(...)` riêng. `...?` (null-'
          'aware spread) bỏ qua an toàn nếu list đó là null.',
      snippet: '''
final demos = [1, 2, 3];
final examples = [4, 5];
final all = [...demos, ...examples, 6]; // [1, 2, 3, 4, 5, 6]

List<int>? maybeNull;
final safe = [0, ...?maybeNull, 1]; // [0, 1] - không throw dù maybeNull null''',
    ),
    _SyntaxInfo(
      name: 'Collection if / for trong literal',
      category: 'Cú pháp rút gọn',
      description:
          'Viết `if`/`for` NGAY TRONG 1 List/Set/Map literal để thêm phần '
          'tử có điều kiện hoặc tạo nhiều phần tử từ 1 vòng lặp - thường '
          'dùng để build `children:` của Row/Column/Wrap gọn hơn so với '
          'việc tạo list tạm rồi filter/map bên ngoài.',
      snippet: '''
Widget build(BuildContext context) {
  return Column(
    children: [
      const Text('Luôn hiện'),
      if (isLoggedIn) const Text('Chào bạn!'),      // collection if
      for (final item in items) Text(item.name),    // collection for
    ],
  );
}''',
    ),
    _SyntaxInfo(
      name: 'Arrow function: =>',
      category: 'Cú pháp rút gọn',
      description:
          'Viết tắt cho hàm/method chỉ có 1 câu lệnh RETURN duy nhất, thay '
          'cho `{ return ...; }`. Hay thấy trong `build()` đơn giản, getter, '
          'callback ngắn (`onPressed: () => doSomething()`).',
      snippet: '''
// Tương đương:
int square(int x) { return x * x; }
int square(int x) => x * x;

// Hay gặp nhất: builder/callback ngắn
onPressed: () => Navigator.of(context).pop(),
itemBuilder: (context, index) => Text('Item \$index'),''',
    ),
    _SyntaxInfo(
      name: 'Named parameters { } vs positional optional [ ]',
      category: 'Cú pháp rút gọn',
      description:
          '`{ }` trong tham số = NAMED parameter (gọi bằng tên, ví dụ hầu '
          'hết tham số widget Flutter: `Text(data, style: ...)`), thêm '
          '`required` nếu bắt buộc. `[ ]` = positional OPTIONAL (gọi theo '
          'thứ tự, không cần tên, có thể bỏ qua). Khác hoàn toàn với tham '
          'số thường (không có dấu ngoặc) là bắt buộc & theo thứ tự.',
      snippet: '''
// Named: gọi bằng tên, thứ tự tự do, rõ nghĩa hơn khi nhiều tham số
void showMessage({required String text, int durationMs = 2000}) {}
showMessage(text: 'Xin chào', durationMs: 1000);
showMessage(text: 'Xin chào'); // durationMs dùng giá trị mặc định

// Positional optional: theo thứ tự, có thể bỏ qua từ cuối lên
String greet(String name, [String? title]) => title == null ? name : '\$title \$name';
greet('Tri');          // "Tri"
greet('Tri', 'Mr.');    // "Mr. Tri"''',
    ),
    // ---- Pattern matching & kiểu dữ liệu mới ----
    _SyntaxInfo(
      name: 'switch như 1 EXPRESSION (=> và các case)',
      category: 'Pattern matching',
      description:
          'Khác với `switch` statement cũ (dùng `case: ... break;`), '
          '`switch` EXPRESSION trả về giá trị trực tiếp bằng `=>`, không '
          'cần `break`, bắt buộc xử lý hết các nhánh (hoặc có `_` cho '
          '"mọi trường hợp còn lại"). Có thể so sánh khoảng giá trị bằng '
          '`&&`/so sánh (relational pattern).',
      snippet: '''
String rank(int score) => switch (score) {
  100 => 'Hoàn hảo',
  >= 80 && < 100 => 'Giỏi',
  >= 50 && < 80 => 'Trung bình',
  _ => 'Cần cố gắng', // bắt buộc có nếu chưa cover hết trường hợp
};''',
    ),
    _SyntaxInfo(
      name: 'Record: (kiểu1, kiểu2, {kiểu3 ten})',
      category: 'Pattern matching',
      description:
          'Gom nhiều giá trị khác kiểu vào 1 "bộ" nhẹ, KHÔNG cần tự định '
          'nghĩa class riêng - tiện khi 1 hàm cần trả về nhiều giá trị '
          'cùng lúc. Có thể dùng vị trí `(a, b)` hoặc đặt tên `(a, {b})`, '
          'và destructure (tách) trực tiếp ra biến bằng pattern.',
      snippet: '''
// Trả về nhiều giá trị cùng lúc mà không cần tạo class
(int, int) minMax(List<int> xs) => (xs.reduce((a, b) => a < b ? a : b),
                                     xs.reduce((a, b) => a > b ? a : b));

final (min, max) = minMax([3, 1, 4, 1, 5]); // destructure trực tiếp
print('min=\$min max=\$max');''',
    ),
    _SyntaxInfo(
      name: 'Enhanced enum (enum có field/method/constructor)',
      category: 'Pattern matching',
      description:
          'Enum hiện đại KHÔNG chỉ là danh sách tên - có thể gắn field, '
          'constructor, method, getter như 1 class bình thường (nhưng vẫn '
          'chỉ có đúng các instance đã khai báo). Hay dùng thay cho '
          '`switch` rải rác nhiều nơi để tra "màu/icon ứng với trạng thái '
          'nào" ngay trong enum.',
      snippet: '''
enum Priority {
  low(Colors.grey, 'Thấp'),
  medium(Colors.orange, 'Trung bình'),
  high(Colors.red, 'Cao');

  final Color color;
  final String label;
  const Priority(this.color, this.label); // constructor của enum
}

Priority.high.color; // Colors.red - không cần switch ở nơi dùng''',
    ),
    _SyntaxInfo(
      name: 'Destructuring: tách List/Map/object ra biến',
      category: 'Pattern matching',
      description:
          'Pattern không chỉ dùng trong `switch` - có thể dùng ngay ở '
          'phép gán (`final` + pattern bên trái) để "tách" nhanh các '
          'phần tử của List/Map (hoặc field của object qua named '
          'pattern `Class(field: biến)`) ra thành biến riêng, thay vì '
          'truy cập `list[0]`, `list[1]`... từng dòng.',
      snippet: '''
final [first, second, ...rest] = [1, 2, 3, 4, 5];
print('\$first \$second \$rest'); // 1 2 [3, 4, 5]

final {'name': name, 'age': age} = {'name': 'Tri', 'age': 25};
print('\$name - \$age tuổi');

// Named pattern: tách field của object theo tên
final Point(x: px, y: py) = Point(1, 2);''',
    ),
    // ---- Bất đồng bộ ----
    _SyntaxInfo(
      name: 'async / await / Future',
      category: 'Bất đồng bộ',
      description:
          '`Future<T>` đại diện cho 1 giá trị kiểu T sẽ có SAU NÀY (ví dụ '
          'sau khi gọi API). Hàm đánh dấu `async` được PHÉP dùng `await` '
          'bên trong để "đợi" 1 Future xong rồi mới chạy tiếp - code đọc '
          'tuần tự như code đồng bộ thay vì phải lồng callback.',
      snippet: '''
Future<String> fetchUserName() async {
  await Future.delayed(const Duration(seconds: 1)); // giả lập gọi API
  return 'Tri Ngo';
}

Future<void> loadData() async {
  final name = await fetchUserName(); // đợi xong mới chạy dòng dưới
  print('Xin chào, \$name');
}''',
    ),
    _SyntaxInfo(
      name: 'Stream & async* / yield',
      category: 'Bất đồng bộ',
      description:
          '`Stream<T>` đại diện cho NHIỀU giá trị kiểu T phát ra theo thời '
          'gian (khác `Future` chỉ có 1 giá trị). Hàm đánh dấu `async*` '
          '(generator function) dùng `yield` để "phát" từng giá trị vào '
          'stream, và `await for` để lắng nghe stream đó trong 1 hàm '
          '`async`.',
      snippet: '''
Stream<int> countUpTo(int max) async* {
  for (var i = 1; i <= max; i++) {
    await Future.delayed(const Duration(seconds: 1));
    yield i; // phát từng giá trị vào stream
  }
}

Future<void> listen() async {
  await for (final n in countUpTo(3)) {
    print(n); // in 1, rồi 2, rồi 3 - mỗi giá trị cách nhau 1 giây
  }
}''',
    ),
    _SyntaxInfo(
      name: 'FutureBuilder / StreamBuilder',
      category: 'Bất đồng bộ',
      description:
          'Widget giúp build UI dựa trên kết quả của 1 Future/Stream mà '
          'KHÔNG cần tự quản lý setState() theo dõi trạng thái loading/lỗi/'
          'xong - `snapshot` cho biết đang ở trạng thái nào qua '
          '`connectionState` và `hasData`/`hasError`.',
      snippet: '''
FutureBuilder<String>(
  future: fetchUserName(),
  builder: (context, snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) return Text('Lỗi: \${snapshot.error}');
    return Text('Xin chào, \${snapshot.data}');
  },
)''',
    ),
    // ---- Kiểu dữ liệu & generic ----
    _SyntaxInfo(
      name: 'Generic: <T>',
      category: 'Kiểu dữ liệu',
      description:
          'Cho phép 1 class/hàm hoạt động với NHIỀU kiểu dữ liệu khác nhau '
          'mà vẫn giữ được type-safety (không phải ép về `dynamic`). `T` '
          'chỉ là tên quy ước (có thể đặt tên khác), được "điền vào" bằng '
          'kiểu cụ thể khi dùng, ví dụ `List<String>`, `Future<int>`.',
      snippet: '''
class Box<T> {
  final T value;
  const Box(this.value);
}

final intBox = Box<int>(42);        // T = int
final strBox = Box<String>('Tri');   // T = String

T firstOrDefault<T>(List<T> list, T fallback) => list.isEmpty ? fallback : list.first;''',
    ),
    _SyntaxInfo(
      name: 'is / as — kiểm tra & ép kiểu',
      category: 'Kiểu dữ liệu',
      description:
          '`is` kiểm tra object có thuộc 1 kiểu không (trả `bool`), kèm '
          '"type promotion" - sau `if (x is Foo)`, Dart tự hiểu `x` là '
          '`Foo` trong nhánh đó mà không cần ép thủ công. `as` ép kiểu '
          'tường minh, throw lỗi runtime nếu ép sai.',
      snippet: '''
void handle(Object value) {
  if (value is String) {
    print(value.length); // Dart tự biết value là String ở đây, không cần ép
  }
  final s = value as String; // ép tường minh - lỗi nếu value không phải String
}''',
    ),
    _SyntaxInfo(
      name: 'typedef',
      category: 'Kiểu dữ liệu',
      description:
          'Đặt 1 tên ngắn/gợi nhớ cho 1 kiểu (thường là kiểu hàm) phức tạp, '
          'dùng lại nhiều nơi cho gọn và dễ đọc hơn - ví dụ chính '
          '`WidgetBuilder` trong Flutter (`Widget Function(BuildContext)`) '
          'là 1 typedef.',
      snippet: '''
// Flutter đã định nghĩa sẵn, ví dụ:
typedef WidgetBuilder = Widget Function(BuildContext context);

// Tự định nghĩa cho callback riêng của bạn:
typedef OnItemSelected = void Function(int index, String label);

void registerCallback(OnItemSelected onSelected) { /* ... */ }''',
    ),
    // ---- Biến & khai báo ----
    _SyntaxInfo(
      name: 'var / final / const / dynamic / Object',
      category: 'Biến & khai báo',
      description:
          '`var` suy luận kiểu lúc gán, vẫn CÓ kiểu cố định (không đổi '
          'kiểu sau đó). `final` gán 1 lần, giá trị có thể tính ra lúc '
          'RUNTIME. `const` cũng gán 1 lần nhưng giá trị phải biết được lúc '
          'COMPILE TIME. `dynamic` tắt type-check (biết rủi ro, Dart không '
          'cảnh báo gì). `Object`/`Object?` vẫn CÓ type-check nhưng chấp '
          'nhận mọi kiểu - khác `dynamic` ở việc vẫn phải ép kiểu trước khi '
          'gọi method riêng của kiểu con.',
      snippet: '''
var name = 'Tri';      // suy luận kiểu String, không đổi sang int được
final now = DateTime.now(); // chạy mỗi lần gọi lại khác nhau -> final, không phải const
const pi = 3.14;        // phải biết giá trị ngay lúc compile

dynamic x = 'abc';
x = 123;                // dynamic: đổi kiểu tuỳ ý, Dart không báo lỗi
x.foo();                 // chỉ lỗi lúc RUNTIME nếu method không tồn tại

Object y = 'abc';
// y.length;             // LỖI compile-time: Object không có .length
(y as String).length;     // phải ép kiểu trước''',
    ),
    _SyntaxInfo(
      name: 'required (tham số named bắt buộc)',
      category: 'Biến & khai báo',
      description:
          'Đánh dấu 1 named parameter là BẮT BUỘC phải truyền khi gọi, dù '
          'nó nằm trong `{ }`. Rất hay gặp trong constructor của widget '
          '(`const MyWidget({super.key, required this.title})`).',
      snippet: '''
class Greeting extends StatelessWidget {
  final String name; // bắt buộc phải truyền
  const Greeting({super.key, required this.name});
}

Greeting(name: 'Tri');  // OK
// Greeting();           // LỖI: thiếu tham số bắt buộc "name"''',
    ),
    // ---- Toán tử ----
    _SyntaxInfo(
      name: 'Toán tử so sánh/logic/ba ngôi: ==  &&  ||  !  ?:',
      category: 'Toán tử',
      description:
          '`==` so sánh GIÁ TRỊ (có thể override, khác `identical()` so '
          'sánh CÙNG 1 object trong bộ nhớ). `&&`/`||`/`!` là AND/OR/NOT '
          'logic, có "short-circuit" (vế sau không chạy nếu vế trước đã đủ '
          'quyết định kết quả). `cond ? a : b` (ternary) là if/else rút '
          'gọn dạng expression.',
      snippet: '''
final a = 5, b = 5;
print(a == b);        // true - so sánh giá trị
print(identical(a, b)); // so sánh cùng 1 object trong bộ nhớ (với int nhỏ thường cũng true)

bool isValid(String? s) => s != null && s.isNotEmpty; // s.isNotEmpty không chạy nếu s null

final label = isLoggedIn ? 'Đăng xuất' : 'Đăng nhập';''',
    ),
    _SyntaxInfo(
      name: 'Operator overloading (==, +, []...)',
      category: 'Toán tử',
      description:
          'Dart cho phép định nghĩa lại hành vi của 1 số toán tử (`==`, '
          '`+`, `-`, `[]`, `[]=`...) cho class tự viết bằng từ khoá '
          '`operator`. Khi override `==` NÊN override thêm `hashCode` đi '
          'kèm (2 object bằng nhau phải có cùng hashCode), nếu không các '
          'cấu trúc dùng hash (Set, Map key) sẽ hoạt động sai.',
      snippet: '''
class Point {
  final double x, y;
  const Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      other is Point && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y); // bắt buộc đi kèm khi override ==

  Point operator +(Point other) => Point(x + other.x, y + other.y);
}

print(const Point(1, 2) == const Point(1, 2)); // true
print(const Point(1, 2) + const Point(3, 4));  // Point(4, 6)''',
    ),
    // ---- Vòng lặp & điều kiện ----
    _SyntaxInfo(
      name: 'for / for-in / while / do-while',
      category: 'Vòng lặp & điều kiện',
      description:
          '`for (init; cond; step)` vòng lặp kiểu C truyền thống. '
          '`for (x in iterable)` lặp qua từng phần tử (thường dùng hơn khi '
          'chỉ cần đọc phần tử, không cần index). `while` kiểm tra điều '
          'kiện TRƯỚC mỗi lần lặp, `do-while` chạy ít nhất 1 lần rồi mới '
          'kiểm tra điều kiện ở CUỐI.',
      snippet: '''
for (var i = 0; i < 3; i++) { print(i); }      // 0 1 2

for (final item in ['a', 'b', 'c']) { print(item); } // a b c

var n = 3;
while (n > 0) { print(n); n--; }               // 3 2 1

var m = 0;
do { print(m); m++; } while (m < 3);           // 0 1 2 (chạy ít nhất 1 lần)''',
    ),
    _SyntaxInfo(
      name: 'break / continue / nhãn (label)',
      category: 'Vòng lặp & điều kiện',
      description:
          '`break` thoát hẳn vòng lặp gần nhất, `continue` bỏ qua phần '
          'còn lại của lần lặp hiện tại rồi tiếp tục lần sau. Với vòng lặp '
          'LỒNG NHAU, đặt 1 "nhãn" (`ten:`) trước vòng lặp ngoài để '
          '`break`/`continue` nhảy thẳng tới đúng vòng lặp đó, không chỉ '
          'vòng gần nhất.',
      snippet: '''
outer:
for (var i = 0; i < 3; i++) {
  for (var j = 0; j < 3; j++) {
    if (j == 1) continue outer; // bỏ qua, nhảy về vòng "outer", không phải vòng j
    if (i == 2) break outer;     // thoát HẲN cả 2 vòng, không chỉ vòng j
    print('\$i-\$j');
  }
}''',
    ),
    // ---- Hàm (function) ----
    _SyntaxInfo(
      name: 'Anonymous function & closure',
      category: 'Hàm (function)',
      description:
          'Hàm không có tên, gán vào biến hoặc truyền trực tiếp làm tham '
          'số (callback) - rất phổ biến trong Flutter (`onPressed`, '
          '`builder`...). "Closure" là khi hàm đó "nhớ" và dùng được biến '
          'ở MÔI TRƯỜNG NÓ ĐƯỢC TẠO RA, dù hàm được gọi ở nơi khác/sau đó.',
      snippet: '''
int Function() makeCounter() {
  var count = 0;
  // Hàm trả về "đóng" (closure) biến count - mỗi lần GỌI LẠI vẫn nhớ và
  // cộng tiếp từ giá trị count cũ, không reset về 0.
  return () { count++; return count; };
}

final counter = makeCounter();
print(counter()); // 1
print(counter()); // 2 - vẫn nhớ count từ lần gọi trước

// Ví dụ closure thực tế hơn - mỗi button "nhớ" đúng giá trị index của nó:
List<Widget> buildButtons(List<String> labels) {
  return [
    for (final label in labels)
      ElevatedButton(onPressed: () => print('Bấm \$label'), child: Text(label)),
  ];
}''',
    ),
    // ---- OOP: kế thừa, interface, mixin ----
    _SyntaxInfo(
      name: 'extends + super + @override',
      category: 'OOP: kế thừa & mixin',
      description:
          '`extends` kế thừa 1 class CHA DUY NHẤT (Dart không cho đa kế '
          'thừa qua extends), được dùng lại field/method của cha. `super` '
          'gọi tới constructor/method của cha. `@override` (annotation) '
          'không bắt buộc về mặt chạy được, nhưng NÊN luôn thêm khi override '
          '- Dart sẽ báo lỗi compile nếu bạn "override" nhầm method không '
          'tồn tại ở cha (gõ sai tên), giúp bắt lỗi sớm.',
      snippet: '''
class Animal {
  final String name;
  const Animal(this.name);
  String speak() => '\$name không nói gì';
}

class Dog extends Animal {
  const Dog(super.name); // chuyển tham số thẳng cho constructor cha

  @override
  String speak() => '\$name: Gâu gâu! (\${super.speak()})'; // gọi thêm bản của cha
}''',
    ),
    _SyntaxInfo(
      name: 'abstract class',
      category: 'OOP: kế thừa & mixin',
      description:
          'Class KHÔNG thể tạo instance trực tiếp (`Shape()` sẽ lỗi), chỉ '
          'dùng để làm class cha định nghĩa "khung" chung - có thể có '
          'method CHƯA implement (chỉ khai báo, để class con tự viết) lẫn '
          'method ĐÃ implement sẵn để con dùng chung.',
      snippet: '''
abstract class Shape {
  double area(); // chưa implement - BẮT BUỘC class con phải viết

  void printArea() => print('Diện tích: \${area()}'); // đã implement, con dùng chung
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);
  @override
  double area() => 3.14 * radius * radius;
}

// Shape();      // LỖI: không tạo được instance của abstract class
Circle(2).printArea();''',
    ),
    _SyntaxInfo(
      name: 'implements (interface)',
      category: 'OOP: kế thừa & mixin',
      description:
          'Dart KHÔNG có từ khoá `interface` riêng - BẤT KỲ class nào '
          '(thường/abstract) đều có thể được dùng làm "interface" bằng '
          '`implements`. Khác `extends`: 1 class có thể `implements` '
          'NHIỀU "interface" cùng lúc, nhưng phải tự viết lại TOÀN BỘ '
          'method (không được kế thừa implementation có sẵn như `extends`).',
      snippet: '''
class Flyer { void fly() {} }
class Swimmer { void swim() {} }

// Implements NHIỀU "interface" cùng lúc (extends thì chỉ được 1):
class Duck implements Flyer, Swimmer {
  @override
  void fly() => print('Vịt bay (chậm thôi)');
  @override
  void swim() => print('Vịt bơi');
}''',
    ),
    _SyntaxInfo(
      name: 'mixin + with',
      category: 'OOP: kế thừa & mixin',
      description:
          '`mixin` đóng gói 1 nhóm method/field để "trộn" vào NHIỀU class '
          'khác nhau bằng từ khoá `with`, dùng khi muốn chia sẻ code '
          'giữa các class KHÔNG cùng 1 nhánh kế thừa (khác với `extends` '
          'chỉ 1 cha). 1 class có thể `with` nhiều mixin cùng lúc. Hay '
          'gặp nhất trong Flutter: `with SingleTickerProviderStateMixin`.',
      snippet: '''
mixin Logger {
  void log(String msg) => print('[LOG] \$msg');
}

class ApiClient with Logger {
  void fetch() {
    log('Đang gọi API...'); // dùng method từ mixin, không cần extends
  }
}

// Quen thuộc trong Flutter:
class _MyState extends State<MyWidget> with SingleTickerProviderStateMixin {
  // "vsync: this" dùng được là nhờ mixin này
}''',
    ),
    _SyntaxInfo(
      name: 'static members',
      category: 'OOP: kế thừa & mixin',
      description:
          'Field/method gắn với CLASS, không phải với từng instance - '
          'gọi qua `ClassName.member`, không cần tạo object. Hay dùng cho '
          'hằng số chung hoặc helper không phụ thuộc instance nào.',
      snippet: '''
class AppConfig {
  static const String appName = 'Layout Playground'; // 1 bản duy nhất cho cả app
  static int instanceCount = 0;

  AppConfig() { instanceCount++; } // tăng biến static mỗi lần tạo instance
}

print(AppConfig.appName); // gọi qua tên class, không cần AppConfig()''',
    ),
    // ---- Collection & Iterable methods ----
    _SyntaxInfo(
      name: 'map / where / fold / reduce',
      category: 'Collection methods',
      description:
          '`map` biến đổi MỖI phần tử thành 1 giá trị khác (1-1). `where` '
          'lọc giữ lại phần tử thoả điều kiện. `fold` gộp cả list thành 1 '
          'giá trị, có giá trị khởi đầu tự chọn. `reduce` giống `fold` '
          'nhưng lấy chính phần tử ĐẦU TIÊN làm khởi đầu (list rỗng sẽ '
          'lỗi, `fold` thì không).',
      snippet: '''
final nums = [1, 2, 3, 4, 5];

final doubled = nums.map((n) => n * 2).toList();     // [2, 4, 6, 8, 10]
final evens = nums.where((n) => n.isEven).toList();   // [2, 4]
final sum = nums.fold<int>(0, (acc, n) => acc + n);   // 15, bắt đầu từ 0
final sum2 = nums.reduce((a, b) => a + b);             // 15, bắt đầu từ nums[0]''',
    ),
    _SyntaxInfo(
      name: 'firstWhere / any / every / sort',
      category: 'Collection methods',
      description:
          '`firstWhere` tìm phần tử ĐẦU TIÊN thoả điều kiện (throw nếu '
          'không có, trừ khi truyền `orElse`). `any`/`every` kiểm tra có '
          '"ít nhất 1"/"tất cả" phần tử thoả điều kiện, trả `bool`. '
          '`sort` sắp xếp TẠI CHỖ (mutate list gốc) theo hàm so sánh tự '
          'định nghĩa.',
      snippet: '''
final users = [('Tri', 25), ('An', 30), ('Bo', 20)];

final found = users.firstWhere((u) => u.\$2 > 24, orElse: () => ('?', 0));
final hasAdult = users.any((u) => u.\$2 >= 18);   // true
final allAdult = users.every((u) => u.\$2 >= 18); // true

final sorted = [...users]..sort((a, b) => a.\$2.compareTo(b.\$2)); // tăng dần theo tuổi''',
    ),
    // ---- String ----
    _SyntaxInfo(
      name: 'Multi-line string & raw string',
      category: 'String',
      description:
          'Dấu nháy 3 lần (`\'\'\'...\'\'\'` hoặc `"""..."""`) tạo string NHIỀU '
          'DÒNG, giữ nguyên xuống dòng/khoảng trắng. Thêm `r` trước string '
          '(raw string) để Dart hiểu các ký tự như `\\n`, `\$` theo NGHĨA '
          'ĐEN, không escape/interpolate - rất tiện khi viết regex.',
      snippet: '''
final poem = \'\'\'
Dòng 1
Dòng 2\'\'\'; // giữ nguyên xuống dòng

final pattern = r'\\d+\\.\\d+'; // raw string: \\d không bị hiểu là ký tự đặc biệt
print(r'Giá: \$100');          // in ra đúng "Giá: \$100", không interpolate''',
    ),
    _SyntaxInfo(
      name: 'Các method String hay dùng',
      category: 'String',
      description:
          '`split` tách string thành List theo 1 ký tự/pattern. `trim` bỏ '
          'khoảng trắng đầu/cuối. `contains`/`startsWith`/`endsWith` kiểm '
          'tra chuỗi con. `toUpperCase`/`toLowerCase` đổi hoa/thường. Tất '
          'cả đều trả về giá trị MỚI, KHÔNG thay đổi string gốc (String '
          'trong Dart là immutable).',
      snippet: '''
const s = '  Hello, Flutter!  ';
print(s.trim());                 // 'Hello, Flutter!'
print(s.trim().split(', '));     // ['Hello', 'Flutter!']
print(s.contains('Flutter'));    // true
print(s.trim().toUpperCase());   // 'HELLO, FLUTTER!'
''',
    ),
    // ---- Exception handling ----
    _SyntaxInfo(
      name: 'try / catch / on / finally / throw',
      category: 'Exception handling',
      description:
          '`try { }` bọc code có thể lỗi, `catch (e)` bắt lỗi BẤT KỲ loại '
          'nào, `on SpecificType catch (e)` chỉ bắt đúng loại lỗi đó (có '
          'thể viết nhiều `on` liên tiếp cho nhiều loại). `finally` LUÔN '
          'chạy dù có lỗi hay không (hay dùng để dọn dẹp resource). '
          '`throw` ném lỗi tự tạo, `rethrow` ném lại lỗi đang bắt được '
          '(giữ nguyên stack trace) để lớp gọi bên ngoài cũng biết.',
      snippet: '''
class ValidationError implements Exception {
  final String message;
  ValidationError(this.message);
}

void validate(int age) {
  if (age < 0) throw ValidationError('Tuổi không hợp lệ');
}

try {
  validate(-5);
} on ValidationError catch (e) {
  print('Lỗi validate: \${e.message}');
} catch (e) {
  print('Lỗi khác: \$e');
} finally {
  print('Luôn chạy dù có lỗi hay không');
}''',
    ),
    // ---- Mở rộng kiểu có sẵn ----
    _SyntaxInfo(
      name: 'extension method',
      category: 'Mở rộng kiểu (extension)',
      description:
          'Gắn thêm method/getter vào 1 kiểu ĐÃ TỒN TẠI (kể cả kiểu có '
          'sẵn như `int`, `String`, hay `BuildContext` của Flutter) mà '
          'KHÔNG cần sửa source gốc hoặc tạo subclass - chỉ hoạt động ở '
          'những file có `import` extension đó.',
      snippet: '''
extension ContextExtension on BuildContext {
  // Dùng context.theme thay cho Theme.of(context) dài dòng
  ThemeData get theme => Theme.of(this);
}

// Ở nơi dùng (sau khi import file chứa extension):
Text('Xin chào', style: context.theme.textTheme.titleLarge);''',
    ),
    _SyntaxInfo(
      name: 'extension type (Dart 3)',
      category: 'Mở rộng kiểu (extension)',
      description:
          'Tạo 1 "lớp vỏ" bọc quanh 1 kiểu có sẵn (ví dụ `int`) để có '
          'type-safety riêng mà KHÔNG tốn chi phí tạo object thật lúc '
          'runtime (được "xoá" khi compile, khác với class bình thường). '
          'Hữu ích để phân biệt 2 giá trị cùng kiểu gốc nhưng ý nghĩa khác '
          'nhau (vd UserId vs ProductId, cả 2 đều là int).',
      snippet: '''
extension type UserId(int value) {
  bool get isGuest => value == 0;
}

void greetUser(UserId id) => print('Chào user #\${id.value}');

final id = UserId(42);
greetUser(id);
// greetUser(42); // LỖI: int thường không tự gán được vào UserId''',
    ),
    // ---- Annotation ----
    _SyntaxInfo(
      name: 'Annotation thường gặp: @override @immutable...',
      category: 'Annotation',
      description:
          'Annotation (bắt đầu bằng `@`) là METADATA gắn vào code, không '
          'ảnh hưởng runtime trực tiếp nhưng được analyzer/tool dùng để '
          'cảnh báo. `@override` báo "method này override cha" (lỗi nếu '
          'không đúng). `@immutable` báo "mọi field của class này nên là '
          'final" (cảnh báo nếu không). `@mustCallSuper` báo "class con '
          'override method này PHẢI gọi `super.method()`".',
      snippet: '''
@immutable
class Point {
  final double x, y; // @immutable cảnh báo nếu thêm field không final
  const Point(this.x, this.y);
}

class Base {
  @mustCallSuper
  void dispose() { /* dọn dẹp */ }
}

class Derived extends Base {
  @override
  void dispose() {
    super.dispose(); // bắt buộc gọi, nếu quên sẽ bị cảnh báo
  }
}''',
    ),
    // ---- Constructor ----
    _SyntaxInfo(
      name: 'Constructor mặc định (default)',
      category: 'Constructor',
      description:
          'Tên constructor TRÙNG với tên class. Mỗi class chỉ có 1 '
          'constructor mặc định. `this.x` trong tham số là cú pháp tắt: tự '
          'gán tham số vào field cùng tên, không cần viết lại trong body.',
      snippet: '''
class Point {
  final double x;
  final double y;

  // Tương đương:
  //   Point(double x, double y) { this.x = x; this.y = y; }
  Point(this.x, this.y);
}

final p = Point(1, 2);''',
    ),
    _SyntaxInfo(
      name: 'Named constructor',
      category: 'Constructor',
      description:
          '`ClassName.tenRieng(...)` - thêm 1 cách tạo object khác, đặt tên '
          'theo Ý NGHĨA để chỗ gọi dễ đọc hơn so với nhồi nhiều tham số '
          'optional vào 1 constructor duy nhất. 1 class có thể có nhiều '
          'named constructor, cộng với 1 constructor mặc định (nếu có).',
      snippet: '''
class StatusBadge {
  final String label;
  final Color color;

  const StatusBadge(this.label, this.color); // constructor mặc định

  // Named constructor: gọi theo ngữ nghĩa, không cần tự nhớ màu
  const StatusBadge.success(String label) : this(label, Colors.green);
  const StatusBadge.error(String label) : this(label, Colors.red);
}

StatusBadge.success('Thành công'); // đọc code là hiểu ngay ý nghĩa''',
    ),
    _SyntaxInfo(
      name: 'Dấu _ trong tên: KHÔNG phải cú pháp constructor, mà là "private"',
      category: 'Constructor',
      description:
          'Trong Dart, bất kỳ identifier (tên class/method/field/biến...) '
          'bắt đầu bằng `_` đều là "library-private": chỉ dùng được trong '
          'CÙNG 1 FILE .dart, file khác import vào sẽ không gọi được. '
          '`ClassName._(...)` chỉ là 1 named constructor có tên là `_` '
          '(tên rỗng/ẩn danh theo quy ước) - không có gì đặc biệt về cú '
          'pháp ngoài việc nó bị ẩn với bên ngoài file.',
      snippet: '''
// Trong file a.dart:
class StatusBadge {
  // Đây là NAMED CONSTRUCTOR tên "_", chỉ gọi được trong file a.dart này.
  const StatusBadge._(this.label, this.color);
  final String label;
  final Color color;
}

// Trong file b.dart (import a.dart):
StatusBadge._('x', Colors.red); // LỖI: không thấy constructor này
StatusBadge.success('x');        // OK nếu success là named constructor public''',
    ),
    _SyntaxInfo(
      name: 'Vì sao cần constructor private `._(...)`?',
      category: 'Constructor',
      description:
          'Dùng để GIẤU cách tạo object "thô" (nhận đủ mọi tham số), chỉ '
          'cho bên ngoài dùng các named constructor "thân thiện" (success/ '
          'warning/error...) - mỗi named constructor RE-DIRECT (chuyển '
          'hướng) sang constructor private bằng `: this._(...)` để tái sử '
          'dụng logic gán field, không phải viết lại initializer nhiều lần.',
      snippet: '''
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  // (1) Constructor "thô", PRIVATE - không ai bên ngoài gọi trực tiếp được.
  const StatusBadge._(this.label, this.color, this.icon);

  // (2) Các named constructor PUBLIC, mỗi cái "redirect" (: this._(...))
  //     sang (1) kèm icon/color đã chọn sẵn theo ngữ nghĩa.
  const StatusBadge.success(String label)
    : this._(label, Colors.green, Icons.check_circle);

  const StatusBadge.warning(String label)
    : this._(label, Colors.orange, Icons.warning_amber);
}

// Nơi gọi chỉ thấy .success/.warning - không thấy (và không cần biết) ._''',
    ),
    _SyntaxInfo(
      name: 'Factory constructor',
      category: 'Constructor',
      description:
          'Thêm từ khoá `factory` phía trước. Khác constructor thường: '
          'được chạy LOGIC TUỲ Ý trong thân hàm trước khi quyết định trả '
          'về object nào (dùng `return`, không dùng `:` initializer list), '
          'và CÓ THỂ trả về object đã tồn tại (cache/singleton) thay vì '
          'luôn tạo mới. Hay dùng khi "tạo ra cái gì" phụ thuộc runtime input.',
      snippet: '''
factory StatusBadge.fromHttpCode(int code) {
  // Logic tuỳ ý: if/switch/gọi hàm khác... (constructor thường KHÔNG làm được)
  if (code >= 200 && code < 300) return StatusBadge.success('HTTP \$code OK');
  if (code >= 300 && code < 500) return StatusBadge.warning('HTTP \$code');
  return StatusBadge.error('HTTP \$code Error');
}

StatusBadge.fromHttpCode(404); // tự chọn ra badge warning''',
    ),
    _SyntaxInfo(
      name: 'const constructor',
      category: 'Constructor',
      description:
          'Constructor đánh dấu `const` cho phép tạo object ở COMPILE TIME '
          '(hằng số, không đổi) - Flutter có thể tái dùng lại đúng 1 '
          'instance thay vì tạo mới mỗi lần build() chạy lại, giúp rebuild '
          'nhanh hơn. Điều kiện: MỌI field phải `final`, và mọi giá trị '
          'truyền vào constructor đó cũng phải là const.',
      snippet: '''
class StatusBadge {
  final String label; // phải final mới const được
  const StatusBadge(this.label);
}

const StatusBadge('OK');        // OK: literal là hằng số
const StatusBadge(someVar);     // LỖI nếu someVar không phải const

const SizedBox(height: 16);     // ví dụ quen thuộc trong Flutter''',
    ),
    _SyntaxInfo(
      name: 'Initializer list (dấu `:` sau constructor)',
      category: 'Constructor',
      description:
          'Phần sau dấu `:` (trước `{ }` hoặc trước `;` nếu không có body) '
          'chạy TRƯỚC body, dùng để: gán field không nhận trực tiếp qua '
          'tham số, redirect sang constructor khác (`this(...)`/`this._(...)`), '
          'gọi constructor của class cha (`super(...)`), hoặc `assert(...)` '
          'kiểm tra điều kiện đầu vào.',
      snippet: '''
class Circle {
  final double radius;
  final double area;

  Circle(this.radius)
    : assert(radius > 0, 'radius phải > 0'), // kiểm tra điều kiện
      area = 3.14 * radius * radius;          // field tính từ tham số khác

  // Redirect: constructor này CHỈ gọi sang constructor kia, không có body
  Circle.unit() : this(1.0);
}''',
    ),
  ];

  static List<String> get _categories =>
      _items.map((i) => i.category).toSet().toList();

  @override
  Widget build(BuildContext context) {
    return CategoryFilterScaffold(
      title: 'Dart syntax cheat sheet',
      categories: _categories,
      bodyBuilder: (category) => _SyntaxList(
        items: category == null
            ? _items
            : _items.where((i) => i.category == category).toList(),
      ),
    );
  }
}

class _SyntaxList extends StatelessWidget {
  final List<_SyntaxInfo> items;

  const _SyntaxList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Những cú pháp Dart/Flutter hay gặp trong code thực tế nhưng '
              'dễ gây bối rối khi mới đọc. Lọc theo nhóm bằng tab ở trên, '
              'hoặc xem "Tất cả".',
            ),
          );
        }
        return _SyntaxCard(info: items[index - 1]);
      },
    );
  }
}

class _SyntaxInfo {
  final String name;
  final String category;
  final String description;
  final String snippet;

  const _SyntaxInfo({
    required this.name,
    required this.category,
    required this.description,
    required this.snippet,
  });
}

class _SyntaxCard extends StatelessWidget {
  final _SyntaxInfo info;

  const _SyntaxCard({required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    info.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    info.category,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              info.description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: CodePanel(source: info.snippet, error: null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
