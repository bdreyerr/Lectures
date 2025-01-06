//
//  ResourceView.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/3/25.
//

import SwiftUI

struct ResourceView: View {
    var resource: Resource
    var body: some View {
        Text("Resource title: \(resource.title!)")
    }
}

#Preview {
    ResourceView(resource: Resource(title: "Hey"))
}
