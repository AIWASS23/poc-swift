//
//  HomeView.swift
//  StoreApp
//
//  Created by Marcelo de Araújo on 09/12/22.
//

import SwiftUI

struct HomeView: View {
    
    let courses = Course.sample
    
    var body: some View {
        NavigationView {
            List(courses) { course in 
                VStack(alignment: .leading) {
                    Text(course.name)
                        .font(.title)
                    
                    HStack {
                        Text(course.duration)
                        Spacer()
                        Text(course.category)
                    }.foregroundColor(.secondary)
                }.padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.secondary.opacity(0.3)))
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Home")
        }
    }
}