//
//  SelectedWorkoutView.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import SwiftUI

struct SelectedWorkoutView: View {
    var workoutIndex: Int?
    
    @StateObject private var viewModel: SelectedWorkoutViewModel = SelectedWorkoutViewModel()
    @FocusState private var weightFocused: Bool
    @FocusState private var repsFocused: Bool
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            // Tab 1: Exercise list view
            ScrollView {
                Text(viewModel.name)
                Text("(rest \(viewModel.restInSeconds) s)")
                    .font(.footnote)
                Spacer()
                
                ForEach(0..<viewModel.exercises.count, id:\.self) { i in
                    Button {
                        viewModel.selectExercise(index: i)
                    } label: {
                        viewModel.exercises[i].completed ?
                        Label(viewModel.exercises[i].name, systemImage: "checkmark.circle.fill") :
                        Label(viewModel.exercises[i].name, systemImage: "circle")
                    }
                    .background(viewModel.selectedExerciseIndx == i ? .blue : .black)
                }
            }
            .tabItem {
                Text("List")
            }
            .tag(SelectedWorkoutViewModel.Tab.WORKOUT_VIEW)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Stop") {
                        
                    }
                }
            }
            
            // Tab 2: Selected exercise view
            ScrollView {
                Text("00:00:00")
                    .font(.title2)
                HStack {
                    Text("000 kCal")
                        .fontWeight(.bold)
                        .frame(width: 80, height: 30, alignment: .center)
                        .padding()
                        .foregroundColor(.pink)
                    
                    Text("\(Image(systemName: "heart")) 000")
                        .fontWeight(.bold)
                        .frame(width: 80, height: 30, alignment: .center)
                        .padding()
                        .foregroundColor(.yellow)
                }
                HStack {
                    Text("\(viewModel.weight, specifier: "%.2f") kg")
                        .frame(width: 80, height: 30, alignment: .center)
                        .focusable()
                        .focused($weightFocused)
                        .digitalCrownRotation($viewModel.weight, from: 0, through: .infinity, by: 1.25)
                        .padding()
                        .border(weightFocused ? .primary : .secondary, width: 2)
                    Text("\(viewModel.reps)")
                        .frame(width: 80, height: 30, alignment: .center)
                        .focusable()
                        .focused($repsFocused)
                        .digitalCrownRotation($viewModel.weight, from: 0, through: .infinity, by: 1)
                        .padding()
                        .border(repsFocused ? .primary : .secondary, width: 2)
                }
                Button("Done") {
                    viewModel.markDone()
                }
            }
            .tag(SelectedWorkoutViewModel.Tab.EXERCISE_VIEW)
            .tabItem {
                Text("Exercise")
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Next") {
                        
                    }
                }
            }
        }
        .onAppear {
            guard let index = workoutIndex else {
                return
            }
            
            viewModel.requestDetails(workoutIndex: index)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SelectedWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedWorkoutView()
    }
}