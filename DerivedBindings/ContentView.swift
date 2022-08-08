import SwiftUI

struct Todo: Identifiable, Equatable, Hashable {
    var id = UUID()
    var text: String?
    var isCompleted: Bool
}

var demoTodos = [
    Todo(text: "Get some milk", isCompleted: false),
    Todo(text: "Make the bed", isCompleted: false),
    Todo(text: nil, isCompleted: false),
]

struct ContentView: View {

    @State var todos = demoTodos

//    var isOnBinding: Binding<Bool> {
//        .init(
//            get: {
//                todos[0].isCompleted
//            },
//            set: { newValue in
//                todos[0].isCompleted = newValue
//            })
//    }

    var body: some View {
        let _ = Self._printChanges()
        VStack {
            List($todos) { $todo in
                HStack {
                    Toggle(isOn: $todo.isCompleted) {
                        TextField("Text", text: $todo.text.unwrap(defaultValue: ""), prompt: Text("Enter your todo"))
                    }
                }
            }
        }
        .onChange(of: todos) { newValue in
            print(newValue)
        }
    }

//    private func textBinding(for todo: Binding<Todo>) -> Binding<String> {
//        todo.text
//            .map(
//                to: { $0 ?? "" },
//                from: { $0.isEmpty ? nil : $0 }
//            )
//    }
}

extension Binding {
    func map<NewValue>(
        to: @escaping (Value) -> NewValue,
        from: @escaping (NewValue) -> Value
    ) -> Binding<NewValue> {
        .init(
            get: { to(wrappedValue) },
            set: { wrappedValue = from($0) }
        )
    }
}

extension Binding {
    func unwrap<T: Equatable>(defaultValue: T) -> Binding<T> where Value == Optional<T> {
        map(
            to: { $0 ?? defaultValue },
            from: { newValue in
                newValue == defaultValue ? nil : newValue
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
