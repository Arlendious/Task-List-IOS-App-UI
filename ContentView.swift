import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: login) {
                    Text("Login")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                Spacer()
            }
            .padding()
            .navigationTitle("Login")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Failed"), message: Text("Invalid username or password."), dismissButton:.default(Text("OK")))
            }
        }
        .fullScreenCover(isPresented: $isLoggedIn, content: ContentView.init)
    }

    func login() {
            if username == "Jayanth" && password == "qwerty" {
                isLoggedIn = true
            } else {
                showAlert = true
            }
        }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct Task: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    var isCompleted = false
}

class TaskStore: ObservableObject {
    @Published var tasks: [Task] = []
    
    func addTask(name: String, date: Date) {
        let task = Task(name: name, date: date)
        tasks.append(task)
    }
    
    func removeTask(at indexSet: IndexSet) {
        tasks.remove(atOffsets: indexSet)
    }
    
    func toggleTask(at index: Int) {
        tasks[index].isCompleted.toggle()
    }
}
struct ContentView: View {
    @ObservedObject var taskStore = TaskStore()
    @State private var taskName = ""
    @State private var taskDate = Date()
    @State private var isLoggedIn = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(taskStore.tasks) { task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                                .foregroundColor(task.isCompleted ? .green : .primary)
                                .onTapGesture {
                                    taskStore.toggleTask(at: taskStore.tasks.firstIndex(where: { $0.id == task.id })!)
                                }
                            VStack(alignment: .leading) {
                                Text(task.name)
                                    .font(.headline)
                                Text(task.date, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: taskStore.removeTask)
                }
                .listStyle(PlainListStyle())
                
                VStack {
                    TextField("Task Name", text: $taskName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
    //                   HStack{
    //                       Spacer()
    //                       Text("Pick the date")
    //                           .font(.custom("SF Pro", size: 18).bold())
    //                           .padding(5)
    //                       Spacer()
    //                   }
                    HStack{
                        Spacer()
                        DatePicker(selection: $taskDate, displayedComponents: [.date, .hourAndMinute]) {
                        }
                        .datePickerStyle(WheelDatePickerStyle())
                        .scaleEffect(1)
                        Spacer()
                        Spacer()
                    }
                    Button(action: addTask) {
                        Text("Add Task")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                }
                .padding()
            }
            .navigationBarTitle("Task List")
            .navigationBarItems(trailing: Button(action: {
                isLoggedIn = true
            }) {
                Image(systemName: "person.circle")
                    .imageScale(.large)
            })
            .sheet(isPresented: $isLoggedIn) {
                LoginView()
            }
        }
    }
        // Your existing methods here...
        func addTask() {
            taskStore.addTask(name: taskName, date: taskDate)
            taskName = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
