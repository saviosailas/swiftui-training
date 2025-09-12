//
//  ContentView.swift
//  Today
//
//  Created by savio sailas on 07/09/25.
//

import SwiftUI

struct ContentView: View {
    @FocusState private var isInputActive: Bool
    @State var tasks: [String] = [String]()
    @State var task: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 8.0) {
            Text("Today")
                .font(.system(size: 32, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("NewTaskTxtField",    text: $task, prompt: nil, axis: .vertical)
                .focused($isInputActive)
                .onSubmit {
                    print("new task")
                }
                .padding(.vertical)
                .padding([.leading, .trailing], 7.6)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.blue, lineWidth: 2) //stroke inside the shape's frame
                    /// .stroke(Color.blue, lineWidth: 2)
                    ///  centers the stroke on the edge of the shape's frame
                    /// This means that half of the stroke's width will extend outside the shape's defined frame, and the other half will extend inside
                }
            
            Button { addTask() } label: {
                Text("Add")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background(task.isEmpty ? Color.gray.opacity(0.4): .green)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .disabled(task.isEmpty)
            .frame(maxWidth: .infinity, alignment: .trailing)
            List($tasks, id: \.self) { item in
                Text(item.wrappedValue)
            }
            .listStyle(.inset)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isInputActive = false
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding()
    }
    
    func addTask() {
        tasks.append(task)
        task = ""
    }
}

#Preview {
    ContentView(tasks: ["help\nme", "java is better"])
}
